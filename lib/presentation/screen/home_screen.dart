import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/z_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2CFF2),
        title: const Text('Home'),
        actions: [
          ElevatedButton(
              onPressed: () {},
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
        child: Container(
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
              const SizedBox(
                height: 25,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 150, // 원의 폭
                  //   height: 150, // 원의 높이
                  //   decoration: const BoxDecoration(
                  //     color: Colors.red, // 원의 색상
                  //     shape: BoxShape.circle, // 원 형태
                  //   ),
                  // ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://entertainimg.kbsmedia.co.kr/cms/uploads/PERSON_20230425100142_a6929970038832dc461ad8ee40ef52e4.png'),
                    radius: 50,
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 20), // 원과 사각형 사이의 간격
                  Column(
                    children: [
                      Text(
                        '이름: 아이유',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        '일반회원 입니다',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  // const SizedBox(width: 20), // 사각형들 사이의 간격
                  // TextButton(
                  //   onPressed: () async {
                  //     // 로그아웃을 호출하여 로그인 상태를 false로 설정합니다.
                  //     await AuthUtils.logout();
                  //     // 로그인 화면으로 이동합니다.
                  //     context.go('/login');
                  //   },
                  //   style: TextButton.styleFrom(
                  //     backgroundColor: Colors.amber,
                  //     minimumSize: const Size(75, 125),
                  //   ),
                  //   child: const Text(
                  //     'Logout',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 200,
                    height: 25,
                    child: Text(
                      'AI 채팅 잔여횟수 (3 / 5)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 350,
                height: 10,
                child: LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Column(
                    children: [
                      Text(
                        '나의 영어 레벨',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
                              builder: (context) => const Logout()));
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
              const SizedBox(
                height: 50,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 25,
                  ),
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
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 350, // Container의 폭
                height: 200, // Container의 높이
                color: Colors.blue, // Container의 색상
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 9,
                    // Y축의 최대값
                    barTouchData: BarTouchData(
                      enabled: false,
                    ),
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
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const texts = ['일', '월', '화', '수', '목', '금', '토'];
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
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: List.generate(
                        7,
                        (index) => BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: index + 1, // Y값 (높이)
                                  color: Colors.amber,
                                )
                              ],
                            )),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box,
              color: Colors.grey,
            ),
            label: 'Speak',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey,
            ),
            label: 'Info',
          ),
        ],
        selectedItemColor: Colors.green,
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          // setState(() {
          //   _selectedIndex = index;
          // });
        },
      ),
    );
  }
}
