import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speak_talk/presentation/screen/info_photo_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/intro_name_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/model/profile.dart';
import '../../utils/firebase_service.dart';
import '../../utils/firebase_store.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';

class InfoScreen extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseStoreService _firebaseStore = FirebaseStoreService();

  InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.bottomLeft,
        //     end: Alignment.topRight,
        //     colors: [
        //       Colors.black,
        //       Colors.lightBlue,
        //     ],
        //   ),
        // ),
        child: SingleChildScrollView(
          child: Padding(
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
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoPhotoScreen()));
                          },
                          child: FutureBuilder<Profile>(
                            future: _firebaseStore.readProfile(),
                            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // 데이터를 아직 가져오지 못한 경우 로딩 표시
                                return const CircleAvatar(
                                  radius: 75,
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                // 데이터를 가져오는 도중 에러 발생한 경우
                                return const CircleAvatar(
                                  radius: 75,
                                  child: Icon(Icons.error),
                                );
                              } else if (snapshot.hasData) {
                                // 데이터를 가져와서 사용자 정보 표시
                                var userData = snapshot.data!;
                                var photoUrl = userData.profilePicture ?? '';
                                return Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 75,
                                      backgroundImage: NetworkImage(photoUrl),
                                    ),
                                    Positioned(
                                      bottom: 60,
                                      right: 60,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          // color: Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          // color: Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ]
                                );
                              } else {
                                // 데이터가 없는 경우 빈 프로필 사진 표시
                                return const CircleAvatar(
                                  radius: 75,
                                  // backgroundColor: Colors.grey,
                                );
                              }
                            },
                          ),
                        ),
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
                              logout(context); // 로그아웃 함수 호출
                            } else {
                              // 요금제 업그레이드, 개인정보처리 약관 등 클릭 시 처리
                              // ... 각 항목에 해당하는 처리 코드 작성
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              // color: Colors.blueGrey, // 배경색 지정
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
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return FutureBuilder<Profile>(
      future: _firebaseStore.readProfile(), // 사용자 정보 가져오는 FutureBuilder
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 데이터 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return const Text('Error'); // 에러가 발생하면 에러 메시지 표시
        } else {
          final userData = snapshot.data;
          final name = userData?.name ?? 'Unknown'; // displayName이 없으면 'Unknown'으로 처리
          final DateTime creationTime = userData?.joinDate ?? DateTime.parse('2999-12-31'); // creationTime이 없으면 'Unknown'으로 처리
          final DateTime lastLoginTime = userData?.lastSignInTime ?? DateTime.parse('2999-12-31'); // creationTime이 없으면 'Unknown'으로 처리

          // DateTime을 원하는 형식의 문자열로 변환
          final formattedCreationTime = DateFormat('yyyy-MM-dd').format(creationTime);
          final formattedLastLogin = DateFormat('yyyy-MM-dd HH:mm:ss').format(lastLoginTime);

          // final timestamp = (creationTime as Timestamp).toDate();
          // final Timestamp timestamp = creationTime as Timestamp;  // Timestamp로 캐스팅
          // DateTime을 원하는 형식의 문자열로 변환
          // DateTime dateTime = timestamp.toDate();  // Timestamp를 DateTime으로 변환
          // final formattedCreationTime = DateFormat('yyyy-MM-dd').format(dateTime);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '이름 : $name',
                    style: const TextStyle(fontSize: 22),
                  ),
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const IntroNameScreen()));
                  }, icon: const Icon(Icons.edit)),
                ],
              ),
              Text(
                '가입일 : $formattedCreationTime',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '최근로그인 :\n $formattedLastLogin',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          );
        }
      },
    );
  }

  // Future<DocumentSnapshot?> _getUserData() async {
  //   User? user = _authService.getCurrentUser();
  //   if (user != null) {
  //     return await _authService.getUserData(user);
  //   }
  //   return null;
  // }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance(); // 1. SharedPreferences 인스턴스 가져오기
    await prefs.setBool('isFirstLogin', true); // 2. 'isFirstLogin' 값을 true로 설정하여 첫 번째 로그인 상태로 변경
    await _authService.signOut(); // 3. Firebase 로그아웃

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