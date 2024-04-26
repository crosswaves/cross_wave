import 'package:flutter/material.dart';

import 'payment_widget.dart';

class LastLessonDetailWidget extends StatelessWidget {
  const LastLessonDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {'id': 1, 'text': 'Hi, my name is David?', 'time': '10:00 AM'},
      {'id': 2, 'text': 'Hey David, How are you?', 'time': '10:01 AM'},
      {'id': 1, 'text': 'I\'m pretty good! How are you?', 'time': '10:02 AM'},
      {'id': 1, 'text': 'not too bad.. have you had a dinner?', 'time': '10:00 AM'},
      {'id': 2, 'text': 'not really, I am planning to. how about you?', 'time': '10:01 AM'},
      {'id': 1, 'text': 'I\'v just had', 'time': '10:02 AM'},
      {'id': 1, 'text': 'Hi, my name is David?', 'time': '10:00 AM'},
      {'id': 2, 'text': 'Hey David, How are you?', 'time': '10:01 AM'},
      {'id': 1, 'text': 'I\'m pretty good! How are you?', 'time': '10:02 AM'},
      {'id': 1, 'text': 'not too bad.. have you had a dinner?', 'time': '10:00 AM'},
      {'id': 2, 'text': 'not really, I am planning to. how about you?', 'time': '10:01 AM'},
      {'id': 1, 'text': 'I\'v just had', 'time': '10:02 AM'},
      // 추가 메시지
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('\$date 일차 수업 상세보기'),
        backgroundColor: Color(0xFF91A7E8),
        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('AI feedback'),
                    content: Text('AI 피드백은 유료서비스 입니다. 결제하시겠습니까?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();  // 다이얼로그 닫기
                        },
                        child: Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          // FeedbackScreen으로 이동하는 코드나 추가 행동
                          Navigator.of(context).pop();  // 먼저 다이얼로그를 닫고
                          // 여기에 필요한 네비게이션 로직 추가
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentWidget()));
                        },
                        child: Text('확인'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('AI feedback'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          bool isMe = messages[index]['id'] == 1; // 내가 보낸 메시지인지 확인

          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: isMe ? Color(0xFF91A7E8) : Colors.grey[300],
                borderRadius: isMe
                    ? BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
              ),
              child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      messages[index]['text'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 10
                      ),
                    ),
                    Text(
                      messages[index]['time'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 10
                      ),
                    ),
                  ]),
            ),
          );
        },
      ),
    );
  }
}
