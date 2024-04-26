import 'package:flutter/material.dart';

class PaymentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제 화면'),
        backgroundColor: Color(0xFF91A7E8),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('카드 정보 입력', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '카드 번호',
                hintText: '1234 5678 9012 3456',
              ),
              keyboardType: TextInputType.number,
              maxLength: 19,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '만료 날짜',
                hintText: 'MM/YY',
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CVV',
                hintText: '123',
              ),
              keyboardType: TextInputType.number,
              maxLength: 3,
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 결제 로직을 구현하거나 결제 확인 다이얼로그 표시
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('결제 확인'),
                      content: Text('결제를 진행하시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('확인'),
                          onPressed: () {
                            // 여기에 결제 처리 로직 추가
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Text('결제하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
