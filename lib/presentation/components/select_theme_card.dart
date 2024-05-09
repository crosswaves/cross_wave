import 'package:flutter/material.dart';

class SelectThemeItems extends StatefulWidget {
  const SelectThemeItems({super.key, required this.title});

  // final int index; // 각 타일이 몇 번재 항목인지 표현하는 인덱스
  final String title;

  @override
  State<SelectThemeItems> createState() => _SelectThemeItemsState();
}

class _SelectThemeItemsState extends State<SelectThemeItems> {
  Color? backgroundColor = const Color(0xFFA3C4D6); // 각 타일의 배경색

  void _toggleBackgroundColor() {
    setState(() {
      // 배경색이 현재 설정된 색과 다른 색으로 토글
      backgroundColor = backgroundColor == const Color(0xFF0D427F)
          ? Color(0xFFA3C4D6)
          : const Color(0xFF0D427F);
    });
  }

  // 각 타일의 제목
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleBackgroundColor,
      child: Card(
        elevation: 2.0, // 카드의 그림자 깊이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            alignment: Alignment.center,
            color: backgroundColor,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // child: const Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children:<Widget> [
            // Text(
            //   '커리어',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),            Text(
            //   '여행',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),            Text(
            //   '영화/음악',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),            Text(
            //   '침목',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),            Text(
            //   '문화',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),            Text(
            //   '연애',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),            Text(
            //   '쇼핑',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),            Text(
            //   '음식',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),            Text(
            //   '가족',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            // ],
          ),
        ),
      ),
    );
  }
}
