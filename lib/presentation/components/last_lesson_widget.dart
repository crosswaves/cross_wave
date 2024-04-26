import 'package:flutter/material.dart';

import 'last_lesson_detail_widget.dart';

class LastLessonScreen extends StatelessWidget {
  const LastLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지난 학습'),
        backgroundColor: Color(0xFF91A7E8),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(

              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LastLessonDetailWidget()));
                },
                child: ListTile(
                  title: Text('Lesson ${index + 1}'),
                  subtitle: Text('2021-09-0${index + 1}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          },
        )
      ),
    );
  }
}
