import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceHandler {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _speechEnabled = false;
  String _localeId = 'en_US'; // 영어 설정을 위한 localeId 초기 값

  // TTS 초기화
  Future<void> initTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(1.0);
  }

  // STT 초기화
  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
        onError: (val) => print('Error: $val'), debugLogging: true);
    if (_speechEnabled) {
      var locales = await _speechToText.locales();

      // 사용 가능한 로케일 중에서 영어 로케일 찾기
      var locale = locales.firstWhere((locale) => locale.localeId == _localeId,
          orElse: () => locales.first);
      _localeId = locale.localeId; // 실제 사용 가능한 로케일 ID로 설정
    }
    await initTTS(); // TTS 초기화
  }

  Future<String> startListening() async {
    final completer = Completer<String>();
    if (!_speechEnabled) {
      return Future.error("Speech not initialized");
    }
    _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          completer.complete(result.recognizedWords);
        }
      },
      localeId: _localeId, // 정확하게 설정된 localeId 사용
    );
    return completer.future;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  // TTS로 말하기 (특정 상황에서만 호출)
  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  SpeechToText get speechToText => _speechToText;
  bool get isEnabled => _speechEnabled;
}
