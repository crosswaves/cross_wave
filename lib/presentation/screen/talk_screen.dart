import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speak_talk/presentation/screen/home_screen.dart';
import '../../api_file/models/chat_model.dart';
import '../../api_file/providers/chats_provider.dart';
import '../../api_file/widgets/chat_item.dart';
import '../../api_file/widgets/my_app_bar.dart';
import '../../api_file/widgets/text_and_voice_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});

  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> {
  late Offset _floatingButtonPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        _floatingButtonPosition = Offset(screenSize.width - 80,
            screenSize.height - 160); // Adjust the offset as needed
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // 여기에 키를 설정합니다.
      appBar: MyAppBar(scaffoldKey: _scaffoldKey), // 키를 MyAppBar에 전달합니다.
      body: Consumer(
        builder: (context, ref, child) {
          final List<ChatModel> chats =
          ref.watch(chatsProvider).reversed.toList();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) => ChatItem(
                    text: chats[index].message,
                    isMe: chats[index].isMe,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextAndVoiceField(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: _floatingButtonPosition.dx,
            top: _floatingButtonPosition.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.phone, color: Colors.red), // 전화 아이콘
              ),
              onDraggableCanceled: (_, __) {
                setState(() {
                  _floatingButtonPosition = __;
                });
              },
              onDragEnd: (details) {
                setState(() {
                  _floatingButtonPosition = details.offset;
                });
              },
              childWhenDragging: Container(),
              child: FloatingActionButton(
                onPressed: () => _confirmExitCall(context),
                child: const Icon(Icons.phone, color: Colors.red), // 전화 아이콘
              ), // 드래그 중에는 빈 컨테이너로 표시
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _confirmExitCall(BuildContext context) async {
    bool? confirmExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("대화 종료"),
        content: const Text("대화를 종료하시겠습니까? 대화 내용은 저장됩니다."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // YES
            },
            child: const Text("예"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // NO
            },
            child: const Text("아니오"),
          ),
        ],
      ),
    );

    if (confirmExit == true) {
      final List<ChatModel> chats =
      ProviderScope.containerOf(context).read(chatsProvider);
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (chats.isNotEmpty) {
        DateTime startTime = chats.first.timestamp.toDate();
        DateTime endTime = chats.last.timestamp.toDate();
        Duration duration = endTime.difference(startTime);
        String formattedDuration = formatDuration(duration);

        List<Map<String, dynamic>> messagesList = chats.map((chat) {
          return {
            'isMe': chat.isMe,
            'message': chat.message,
            'timestamp': chat.timestamp,
          };
        }).toList();

        // 대화 정보를 Firestore에 저장
        await FirebaseFirestore.instance.collection('conversations').add({
          'uid': uid,
          'startTime': startTime,
          'endTime': endTime,
          'duration': formattedDuration,
          'messages': messagesList,
        });
      }

      ProviderScope.containerOf(context)
          .read(chatsProvider.notifier)
          .clearChat();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '통화 시간: ${hours}시간 ${minutes}분 ${seconds}초';
    } else if (minutes > 0) {
      return '통화 시간: ${minutes}분 ${seconds}초';
    } else {
      return '통화 시간: ${seconds}초';
    }
  }
}
