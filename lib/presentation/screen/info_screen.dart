import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/info_photo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 80,
                ),

                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        // TODO 사진 업로드 기능 추가
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoPhotoScreen()));
                      },
                      child: const CircleAvatar(
                        radius: 75,
                      ),
                    ), // TODO 사진 업로드 기능 추가
                    const SizedBox(
                      width: 20,
                    ),
                    _buildUserInfoSection(context), // 유저 이름 섹션 불러오기
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                ListView.separated(
                  shrinkWrap: true, // ListView의 높이를 감싸는 콘텐츠에 맞춥니다.
                  itemCount: 3, // 항목 개수
                  separatorBuilder: (context, index) => const Divider(), // 구분선 추가
                  itemBuilder: (context, index) {
                    final title = ['요금제 업그레이드', '개인정보처리 약관', '로그아웃'][index];
                    return InkWell(
                      onTap: () {
                        if (index == 2) {
                          _logout(context); // 로그아웃 함수 호출
                        } else {
                          // 요금제 업그레이드, 개인정보처리 약관 등 클릭 시 처리
                          // ... 각 항목에 해당하는 처리 코드 작성
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1.0), // 왼쪽 테두리 추가
                            bottom: BorderSide(width: 1.0), // 아래쪽 테두리 추가
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0), // 여백 추가
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_right), // 화살표 아이콘 추가
                            const SizedBox(width: 16.0),
                            Text(
                              title,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserName(), // 이름 가져오는 FutureBuilder
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final name = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이름 : $name',
                style: const TextStyle(fontSize: 22),
              ),
              const Text(
                '가입일 : 2024-04-29',
                style: TextStyle(fontSize: 18),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator(); // 이름 로딩 중 표시
        }
      },
    );
  }

  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? 'Unknown';
    return name;
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance(); // 1. SharedPreferences 인스턴스 가져오기
    await prefs.setBool('isFirstLogin', true); // 2. 'isFirstLogin' 값을 true로 설정하여 첫 번째 로그인 상태로 변경
    // 3. 로그아웃 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("로그아웃 되었습니다."),
      ),
    );
    // 4. 로그인 페이지로 이동 (Navigator.pushReplacement 사용하여 기존 페이지 스택 유지 안 함)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}
