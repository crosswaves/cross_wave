import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speak_talk/presentation/screen/info_photo_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/intro_name_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/model/profile.dart';
import '../../utils/firebase_service.dart';
import '../../utils/firebase_store.dart';
import 'info_pay_screen.dart';
import 'license.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';

import 'privacy_policy_screen.dart';

class InfoScreen extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseStoreService _firebaseStore = FirebaseStoreService();

  InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InfoPhotoScreen()));
                          },
                          child: FutureBuilder<Profile>(
                            future: _firebaseStore.readProfile(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Profile> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                return Stack(children: [
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
                                ]);
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
                      shrinkWrap: true,
                      // ListView의 높이를 감싸는 콘텐츠에 맞춥니다.
                      itemCount: 5,
                      // 항목 개수
                      separatorBuilder: (context, index) => const Divider(),
                      // 구분선 추가
                      itemBuilder: (context, index) {
                        final title = [
                          '요금제 업그레이드',
                          '개인정보 처리방침',
                          '라이선스',
                          '로그아웃',
                          '회원탈퇴'
                        ][index];
                        return InkWell(
                          onTap: () {
                            if (index == 3) {
                              logout(context); // 로그아웃 함수 호출
                            } else if (index == 1) {
                              // 개인정보처리 약관 클릭 시 PrivacyPolicyScreen으로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PrivacyPolicyScreen()),
                              );
                            } else if (index == 2) {
                              // 라이선스 터치시
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LicenseScreen()),
                              );
                            } else if (index == 4) {
                              // 회원탈퇴 메서드
                              deleteAccount(context);
                            } else if (index == 0) {
                              // 요금제 업그레이드 페이지 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const InfoPayScreen()),
                              );
                            }

                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
          final name =
              userData?.name ?? 'Unknown'; // displayName이 없으면 'Unknown'으로 처리
          final DateTime creationTime = userData?.joinDate ??
              DateTime.parse('2999-12-31'); // creationTime이 없으면 'Unknown'으로 처리
          final DateTime lastLoginTime = userData?.lastSignInTime ??
              DateTime.parse('2999-12-31'); // creationTime이 없으면 'Unknown'으로 처리

          // DateTime을 원하는 형식의 문자열로 변환
          final formattedCreationTime =
              DateFormat('yyyy-MM-dd').format(creationTime);
          final formattedLastLogin =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(lastLoginTime);

          // final timestamp = (creationTime as Timestamp).toDate();
          // final Timestamp timestamp = creationTime as Timestamp;  // Timestamp로 캐스팅
          // DateTime을 원하는 형식의 문자열로 변환
          // DateTime dateTime = timestamp.toDate();  // Timestamp를 DateTime으로 변환
          // final formattedCreationTime = DateFormat('yyyy-MM-dd').format(dateTime);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이름 :',style: const TextStyle(fontSize: 18),),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      '$name',
                      style: const TextStyle(fontSize: 22),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      alignment: Alignment.centerLeft,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const IntroNameScreen()));
                      },
                      icon: const Icon(Icons.edit),
                      iconSize: 15,
                    ),
                  ),
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
    final prefs =
        await SharedPreferences.getInstance(); // 1. SharedPreferences 인스턴스 가져오기
    await prefs.setBool('isFirstLogin',
        true); // 2. 'isFirstLogin' 값을 true로 설정하여 첫 번째 로그인 상태로 변경
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

  // 회원탈퇴 메서드
  void deleteAccount(BuildContext context) async {
    final firebaseStore = FirebaseStoreService(); // FirebaseStore 인스턴스를 생성합니다.
    final prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스를 가져옵니다.

    try {
      await firebaseStore.deleteProfile(); // Firebase Firestore에서 프로필을 삭제합니다.
      await _authService.signOut(); // Firebase Authentication에서 로그아웃합니다.

      await prefs.setBool('isFirstLogin', true); // 'isFirstLogin' 값을 true로 설정하여 첫 번째 로그인 상태로 변경합니다.

      // 로그아웃 메시지를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("회원 탈퇴가 완료되었습니다."),
        ),
      );

      // 로그인 페이지로 이동합니다. (Navigator.pushReplacement를 사용하여 기존 페이지 스택을 유지하지 않습니다.)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      // 에러 메시지를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("회원 탈퇴 중 오류가 발생했습니다: $e"),
        ),
      );
    }
  }
}
