import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speak_talk/presentation/screen/info_pay_screen.dart';
import 'package:flutter_speak_talk/presentation/screen/select_theme_screen.dart';
import 'package:flutter_speak_talk/utils/firebase_store.dart';
import '../../domain/model/profile.dart';
import 'info_screen.dart';
import 'talk_archive_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseStoreService _firebaseStoreService = FirebaseStoreService();

  List<Profile> profiles = [];

  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  String _selectedDrawerItem = 'Item 1';

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
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildHomeTab() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black45),
        backgroundColor: const Color(0xFFC4E6F3),
        // title: const Text('Home'),
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
                      child: Text('${snapshot.data!.membershipLevel}회원', style: TextStyle(color: Colors.black54),),
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
                return Text('No data available'); // 데이터 없음
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
                  leading: Icon(Icons.attach_money),
                  title: Text('프리미엄 업그레이드'),
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
                  leading: Icon(Icons.account_box),
                  title: Text('개인정보 처리약관'),
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
                  leading: Icon(Icons.logout),
                  title: Text('로그 아웃'),
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
            ListTile(
                title: DropdownButton<String>(
              value: _selectedDrawerItem,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDrawerItem = newValue!;
                });
                Navigator.pop(context);
              },
              items: <String>['Item 1', 'Item 2']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )),
          ],
        ),
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
                        // CircleAvatar(
                        //   backgroundImage:
                        //       NetworkImage(snapshot.data!.profilePicture ?? ''),
                        //   radius: 50,
                        //   backgroundColor: Colors.red,
                        // ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              '${snapshot.data!.name} 님 반가워요!',
                              style:
                                  TextStyle(fontSize: 32, color: Colors.white),
                            ),
                            // Text(
                            //   // 멤버쉽(회원) 레벨
                            //   '${snapshot.data!.membershipLevel} 회원 입니다',
                            //   style:
                            //       TextStyle(fontSize: 18, color: Colors.white),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(10),
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
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
                          SizedBox(
                            width: 350,
                            height: 10,
                            child: LinearProgressIndicator(
                              value: snapshot.data!.remainingChats / 5,
                              backgroundColor: Colors.black,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.topLeft,
                      child: Text('나의 레벨'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5, color: Colors.grey),
                      ),
                      child: Row(
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
                        ],
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
