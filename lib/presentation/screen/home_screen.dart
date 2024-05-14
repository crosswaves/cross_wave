import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speak_talk/presentation/screen/info_pay_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/select_theme_screen.dart';
import 'package:flutter_speak_talk/utils/firebase_store.dart';
import '../../data/repository/weekely_message_counter_impl.dart';
import '../../domain/model/profile.dart';
import '../../domain/repository/weekely_message_counter.dart';
import '../components/achieve_bar_chart.dart';
import 'info_screen.dart';
import 'talk_archive_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseStoreService _firebaseStoreService = FirebaseStoreService();
  final WeeklyMessageCounter _weeklyMessageCounter = WeeklyMessageCounterImpl();
  late List<Widget> _widgetOptions;

  int _selectedIndex = 0;
  List<Profile> profiles = [];
  List<int> _messageCounts = List.filled(7, 0);

  Future<void> _loadMessageCounts() async {
    try {
      // Firebase Authentication에서 현재 로그인된 사용자의 정보 가져오기
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // WeeklyMessageCounterImpl에서 주간 메시지 수 가져오기
        final List<int> counts =
            await _weeklyMessageCounter.getWeeklyMessageCount(user.uid);
        setState(() {
          _messageCounts = counts;
        });
      }
    } catch (e) {
      // Error handling
      print('Failed to load message counts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMessageCounts();
    _widgetOptions = [
      buildHomeTab(),
      SelectThemeScreen(
        title: '주제를 선택해주세요',
        onSelected: (String title) {
          print('Selected: $title');
        },
      ),
      InfoScreen(),
    ];
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    _showExitConfirmationDialog();
    return true;
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 종료'),
        content: const Text('앱을 종료하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('x'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('o'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.transparent,
        color: Colors.indigo,
        buttonBackgroundColor: Colors.indigo,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.account_box, size: 30, color: Colors.white),
          Icon(Icons.more_horiz, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildHomeTab() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        backgroundColor: const Color(0xFFC4E6F3),
        title: const Text('Home'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InfoPayScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Row(
                children: [
                  Text('프리미엄 구독하기', style: TextStyle(color: Colors.white)),
                  Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 15,
                  ),
                ],
              )),
        ],
      ),
      body: SingleChildScrollView(
        // FutureBuilder 비동기 처리
        child: FutureBuilder<Profile>(
          future: _firebaseStoreService.readProfile(),
          builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // 에러 메시지 출력
            } else if (snapshot.hasData && snapshot.data != null) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.black,
                      Colors.lightBlue,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data!.profilePicture ?? ''),
                          radius: 50,
                          backgroundColor: Colors.red,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              '이름: ${snapshot.data!.name}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              // 멤버쉽(회원) 레벨
                              '${snapshot.data!.membershipLevel} 회원 입니다',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 30),
                        SizedBox(
                          width: 200,
                          height: 25,
                          child: Text(
                            'AI 채팅 잔여횟수 (${snapshot.data!.remainingChats} / 5)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 350,
                      height: 10,
                      child: LinearProgressIndicator(
                        value: snapshot.data!.remainingChats / 5,
                        backgroundColor: Colors.black,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${snapshot.data!.level} 레벨',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            const Image(
                              width: 30,
                              height: 30,
                              image: AssetImage('assets/bronze.png'),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TalkArchiveScreen()), // Create a MaterialPageRoute to the TalkArchiveScreen
                            );
                          },
                          child: const Text(
                            '지난 학습 보기',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 25),
                        SizedBox(
                          width: 100,
                          height: 25,
                          child: Text(
                            '주간 성취도',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AchieveBarChart(messageCounts: _messageCounts),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            } else {
              return const Text('No profile found');
            }
          },
        ),
      ),
    );
  }
}
