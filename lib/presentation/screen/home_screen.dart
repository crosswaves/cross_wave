import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speak_talk/presentation/screen/select_theme_screen.dart';
import 'package:flutter_speak_talk/utils/firebase_store.dart';
import '../../data/domain/model/profile.dart';
import 'info_screen.dart';
import 'talk_archive_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseStoreService _firebaseStoreService =
      FirebaseStoreService();

  List<Profile> profiles = [];

  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

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

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      buildHomeTab(),
      const SelectThemeScreen(),
      InfoScreen(),
    ];
    BackButtonInterceptor.add(myInterceptor);
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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildHomeTab() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2CFF2),
        title: const Text('Home'),
        actions: [
          ElevatedButton(
              onPressed: () {
                _firebaseStoreService.createNewProfile();
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
                          backgroundImage: NetworkImage(
                              'https://entertainimg.kbsmedia.co.kr/cms/uploads/PERSON_20230425100142_a6929970038832dc461ad8ee40ef52e4.png'),
                          radius: 50,
                          backgroundColor: Colors.red,
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              '이름: ${snapshot.data!.name}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              // 멤버쉽(회원) 레벨
                              '${snapshot.data!.membershipLevel} 입니다',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30),
                        SizedBox(
                          width: 200,
                          height: 25,
                          child: Text(
                            'AI 채팅 잔여횟수 (${snapshot.data!.remainingChats} / 5)',
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
                    const SizedBox(
                      width: 350,
                      height: 10,
                      child: LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Image(
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
                    Container(
                      width: 350,
                      height: 200,
                      color: Colors.blue,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 9,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  const texts = [
                                    '일',
                                    '월',
                                    '화',
                                    '수',
                                    '목',
                                    '금',
                                    '토'
                                  ];
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 4.0,
                                    child: Text(texts[value.toInt()]),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(
                            7,
                            (index) => BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: index + 1,
                                  color: Colors.amber,
                                )
                              ],
                            ),
                          ),
                        ),
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
    );
  }
}
