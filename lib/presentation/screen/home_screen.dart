import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speak_talk/presentation/screen/info_pay_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/intro_level_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/privacy_policy_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/select_theme_screen.dart';
import 'package:flutter_speak_talk/utils/firebase_store.dart';
import 'package:lottie/lottie.dart';
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final FirebaseStoreService _firebaseStoreService = FirebaseStoreService();
  final WeeklyMessageCounter _weeklyMessageCounter = WeeklyMessageCounterImpl();
  late List<Widget> _widgetOptions;

  int _selectedIndex = 0;
  List<Profile> profiles = [];
  List<int> _messageCounts = List.filled(7, 0);

  // 애니메이션 효과
  late AnimationController _controller;
  late Animation<Offset> _animation;
  // 다크모드
  // bool _isDarkMode = false;

  // 레벨설정
  String _getImageForLevel (String level) {
    switch (level) {
      case 'Gold':
        return 'assets/gold.png';
      case 'Silver':
        return 'assets/silver.png';
      case 'Bronze':
        return 'assets/bronze.png';
      case 'Iron':
        return 'assets/iron.png';
      default:
        return 'assets/iron.png';
    }
  }

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
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeAnimationController();
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();

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



  // 애니메이션 효과 / 초기화
  void _initializeAnimationController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);

    // 애니메이션
    _controller.dispose();
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
          Icon(Icons.volume_up, size: 30, color: Colors.white),
          Icon(Icons.more_horiz, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildHomeTab() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black45),
        // backgroundColor: const Color(0xFFC4E6F3),
        actions: <Widget>[
          FutureBuilder<Profile>(
            future: _firebaseStoreService.readProfile(),
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // 에러 메시지 출력
              } else if (snapshot.hasData && snapshot.data != null) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text('${snapshot.data!.membershipLevel}회원'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InfoScreen()),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage:
                          NetworkImage(snapshot.data!.profilePicture ?? ''),
                          radius: 20,
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Text('No data available'); // 데이터 없음
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text('메뉴', style: TextStyle(color: Colors.black)),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('프리미엄 업그레이드'),
                  onTap: () {
                    setState(() {
                      _selectedDrawerItem = 'Item 1';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InfoPayScreen()),
                    );
                  },
                ),
              ),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.account_box),
                  title: const Text('개인정보 처리방침'),
                  onTap: () {
                    setState(() {
                      _selectedDrawerItem = 'Item 1';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen()),
                    );
                  },
                ),
              ),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading:
                  const Icon(Icons.dark_mode),
                  title: const Text('다크모드'),
                  onTap: () {
                    setState(
                          () {
                        _selectedDrawerItem = 'Item 1';
                      },
                    );
                  },
                ),
              ),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('로그 아웃'),
                  onTap: () {
                    setState(() {
                      _selectedDrawerItem = 'Item 1';
                    });
                    InfoScreen().logout(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _animation,
            child: child,
          );
        },
        child: SingleChildScrollView(
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
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Lottie.asset('assets/lottie/lottie_welcome.json', width: 100, height: 100),
                              SizedBox(width: 30),
                              Column(
                                children: [
                                  Text(
                                    '${snapshot.data!.name} 님',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  Text('반가워요!',style: const TextStyle(fontSize: 32))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: const Text('AI 채팅 잔여횟수',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(10),
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF3F3E3E)
                              : const Color(0xFFEFF3F7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                const Icon(Icons.local_fire_department_rounded,
                                    size: 23),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 200,
                                  height: 25,
                                  child: Text(
                                    '(${snapshot.data!.remainingChats} / ${snapshot.data!.maxChats})',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
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
                                value: snapshot.data!.remainingChats / snapshot.data!.maxChats,
                                backgroundColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          '나의 레벨',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntroLevelScreen(name: snapshot.data!.name ?? '')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFFEFF3F7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${snapshot.data!.level} 레벨',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Image(
                                    width: 30,
                                    height: 30,
                                    image: AssetImage(_getImageForLevel(snapshot.data!.level)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 450,
                        child: ElevatedButton(
                          onHover: (value) {
                            print('Hovering');
                          },
                          autofocus: true,
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
                      ),
                      const SizedBox(height: 10),
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF2C2C2C)
                              : const Color(0xFFEFF3F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AchieveBarChart(messageCounts: _messageCounts),
                        ),
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
      ),
    );
  }
}
