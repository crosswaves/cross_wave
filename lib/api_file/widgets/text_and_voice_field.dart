import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speak_talk/utils/firebase_service.dart';
import 'package:flutter_speak_talk/utils/firebase_store.dart';
import '../../domain/model/profile.dart';
import '../models/chat_model.dart';
import '../providers/chats_provider.dart';
import '../services/ai_handler.dart';
import '../services/voice_handler.dart'; // 수정된 VoiceHandler 사용
import 'toggle_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({super.key});

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  final AIHandler _aiHandler = AIHandler();
  final VoiceHandler _voiceHandler = VoiceHandler();
  var _isReplying = false;
  var _isListening = false;

  // 파이어베이스
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();
  final FirebaseStoreService _firebaseStore = FirebaseStoreService();

  // Futurebuilder 캐싱
  late Future<Profile> _profileFuture;
  bool _isInitialMessageSent = false;

  @override
  void initState() {
    super.initState();
    _voiceHandler.initSpeech();
    _profileFuture = _firebaseStore.readProfile();
    _profileFuture.then((profile) {
      if (profile != null) {
        _sendInitialMessage(profile);
        _isInitialMessageSent = true;
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  // 새로운 코드
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
      future: _profileFuture,
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  onChanged: (value) {
                    value.isNotEmpty
                        ? setInputMode(InputMode.text)
                        : setInputMode(InputMode.voice);
                  },
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              ToggleButton(
                isListening: _isListening,
                isReplying: _isReplying,
                inputMode: _inputMode,
                sendTextMessage: () {
                  final message = _messageController.text;
                  _messageController.clear();
                  sendTextMessage(message);
                  FocusScope.of(context).unfocus(); // 키보드 포커스 해제
                },
                sendVoiceMessage: sendVoiceMessage,
              )
            ],
          );
        } else {
          return Text('데이터를 찾을 수 없습니다.');
        }
      },
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendVoiceMessage() async {
    if (!_voiceHandler.isEnabled) {
      print('Voice not supported');
      return;
    }
    if (_voiceHandler.speechToText.isListening) {
      await _voiceHandler.stopListening();
      setListeningState(false);
    } else {
      setListeningState(true);
      final result = await _voiceHandler.startListening();
      setListeningState(false);
      sendTextMessage(result);
    }
  }

  void sendTextMessage(String message) async {
    setReplyingState(true);
    addToChatList(message, true, DateTime.now().toString());
    final aiResponse = await _aiHandler.getResponse(message);
    addToChatList(aiResponse, false, DateTime.now().toString());
    _voiceHandler.speak(aiResponse); // AI 응답을 TTS로 읽기
    setReplyingState(false);
  }

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void addToChatList(String message, bool isMe, String id) {
    final chats = ref.read(chatsProvider.notifier);
    chats.add(ChatModel(
      id: id,
      message: message,
      isMe: isMe,
      timestamp: Timestamp.now(),
    ));
  }

  void _sendInitialMessage(Profile profile) {
    String initialMessage = "Welcome! How can I assist you today?";
    final theme = profile.theme;
    if (theme != null) {
      initialMessage = "Welcome, would you like to talk about $theme today?.";
    }
    _handleAiResponse(initialMessage);
  }

  void _handleAiResponse(String initialMessage) async {
    final aiResponse = await _aiHandler.getResponse(initialMessage);
    addToChatList(aiResponse, false, DateTime.now().toString());
    _voiceHandler.speak(aiResponse);
  }
}
