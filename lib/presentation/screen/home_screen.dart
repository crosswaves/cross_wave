import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  List<int> _messageCounts = List.filled(7, 0);

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
  }

  Future<void> _loadMessageCounts() async {
    try {
      // Firebase Authentication에서 현재 로그인된 사용자의 정보 가져오기
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // WeeklyMessageCounterImpl에서 주간 메시지 수 가져오기
        final List<int> counts = await _weeklyMessageCounter.getWeeklyMessageCount(user.uid);
        setState(() {
          _messageCounts = counts;
        });
      }
    } catch (e) {
      // Error handling
      print('Failed to load message counts: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                  builder: (context) => const InfoPayScreen(),
                ),
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Profile>(
          future: _firebaseStoreService.readProfile(),
          builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // 에러 메시지 출력
            } else if (snapshot.hasData && snapshot.data != null) {
              return buildHomeTabBody(snapshot.data!);
            } else {
              return const Text('No profile found');
            }
          },
        ),
      ),
    );
  }

  Widget buildHomeTabBody(Profile profile) {
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
                backgroundImage: NetworkImage(profile.profilePicture ?? ''),
                radius: 50,
                backgroundColor: Colors.red,
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    '이름: ${profile.name}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    '${profile.membershipLevel} 회원 입니다',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
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
                  'AI 채팅 잔여횟수 (${profile.remainingChats} / 5)',
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
              value: profile.remainingChats / 5,
              backgroundColor: Colors.black,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '${profile.level} 레벨',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
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
                      builder: (context) => const TalkArchiveScreen(),
                    ),
                  );
                },
                child: const Text(
                  '지난 학습 보기',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: SizedBox(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Speak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}