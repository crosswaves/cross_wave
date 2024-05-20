import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/talk_history_screen.dart';
import 'package:intl/intl.dart';
import '../../data/repository/conversation_history_load_impl.dart';
import '../../domain/model/conversation_history.dart';
import 'home_screen.dart';

class TalkArchiveScreen extends StatelessWidget {
  const TalkArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final conversationHistoryLoad = ConversationHistoryLoadImpl();

    return Scaffold(
      appBar: AppBar(
        title: const Text('이전 대화 목록'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: FutureBuilder<List<ConversationHistory>>(
        future: conversationHistoryLoad.getConversationHistory(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터 로드에 실패했습니다: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('대화 기록이 없습니다.'));
          } else {
            final conversations = snapshot.data!;
            conversations.sort((a, b) => b.startTime.compareTo(a.startTime));
            return ConversationListScreen(conversations: conversations);
          }
        },
      ),
    );
  }
}

class ConversationListScreen extends StatefulWidget {
  final List<ConversationHistory> conversations;

  const ConversationListScreen({super.key, required this.conversations});

  @override
  _ConversationListScreenState createState() => _ConversationListScreenState();
}

enum SortOption { recent, oldest }

class _ConversationListScreenState extends State<ConversationListScreen> {
  SortOption _currentSortOption = SortOption.recent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () {
                _showSortOptions(context);
              },
            ),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshConversations,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: widget.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = widget.conversations[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        conversation.previewMessage.length > 150 // 최대 길이 설정
                            ? '${conversation.previewMessage.substring(0, 150)}...' // 최대 길이를 초과할 경우 생략 부호 추가
                            : conversation.previewMessage,
                      ),
                      subtitle: Text(DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                          .format(conversation.startTime.toLocal())),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _confirmDeleteConversation(context, conversation.id);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TalkHistoryScreen(
                              conversationId: conversation.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _refreshConversations() async {
    // 대화 목록을 다시 불러와서 UI를 갱신합니다.
    widget.conversations.clear(); // 기존 대화 목록 초기화
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final conversationHistoryLoad = ConversationHistoryLoadImpl();
    widget.conversations.addAll(await conversationHistoryLoad
        .getConversationHistory(uid)); // 새로운 대화 목록 불러오기
    setState(() {}); // UI 갱신
  }

  Future<void> _confirmDeleteConversation(
      BuildContext context, String conversationId) async {
    // 삭제 여부를 물어보는 다이얼로그를 표시합니다.
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("대화 삭제"),
          content: const Text("해당 대화 내용을 삭제하시겠습니까? 삭제 이후에는 대화 내역을 되돌릴 수 없습니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // "YES"를 선택한 경우
              child: const Text("YES"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // "NO"를 선택한 경우
              child: const Text("NO"),
            ),
          ],
        );
      },
    );

    // 사용자가 "YES"를 선택한 경우에만 대화를 삭제합니다.
    if (confirm == true) {
      await _deleteConversation(context, conversationId);
    }
  }

  Future<void> _deleteConversation(
      BuildContext context, String conversationId) async {
    try {
      // Firestore에서 해당 대화의 DocumentReference를 가져옵니다.
      DocumentReference conversationRef = FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId);
      // 대화의 DocumentReference를 사용하여 해당 대화를 삭제합니다.
      await conversationRef.delete();
      print('대화가 성공적으로 삭제되었습니다.');
      // 삭제한 후에 대화 목록을 다시 불러와서 UI를 갱신합니다.
      await _refreshConversations();
    } catch (e) {
      // 대화 삭제 중에 오류가 발생한 경우 처리합니다.
      print('대화를 삭제하는 중 오류가 발생했습니다: $e');
    }
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('최신순으로 정렬'),
              onTap: () {
                setState(() {
                  _currentSortOption = SortOption.recent;
                  widget.conversations
                      .sort((a, b) => b.startTime.compareTo(a.startTime));
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: const Text('오래된순으로 정렬'),
              onTap: () {
                setState(() {
                  _currentSortOption = SortOption.oldest;
                  widget.conversations
                      .sort((a, b) => a.startTime.compareTo(b.startTime));
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
