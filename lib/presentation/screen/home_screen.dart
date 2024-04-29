import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speak_talk/presentation/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: 'My',
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
      body: Container(
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
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150, // 원의 폭
                  height: 150, // 원의 높이
                  decoration: const BoxDecoration(
                    color: Colors.red, // 원의 색상
                    shape: BoxShape.circle, // 원 형태
                  ),
                ),
                const SizedBox(width: 20), // 원과 사각형 사이의 간격
                Container(
                  width: 125, // 사각형의 폭
                  height: 125, // 사각형의 높이
                  color: Colors.green, // 사각형의 색상
                ),
                const SizedBox(width: 20), // 사각형들 사이의 간격
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    // auth_utils 파일에 isFirstLogin 값을 true로 설정.
                    //첫 번째 로그인 상태로
                    await prefs.setBool('isFirstLogin', true);

                    // 로그아웃 후에 로그아웃된거 메시지
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("로그아웃 되었습니다."),
                      ),
                    );

                    // 로그아웃 담에 로그인 페이지로
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber,
                    minimumSize: const Size(75, 125),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                  width: 100,
                  height: 25,
                  child: Text(
                    '일일 성취도',
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
                value: 0.7,
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
                Container(
                  width: 160, // 두 번째 사각형의 폭
                  height: 175, // 두 번째 사각형의 높이
                  color: Colors.blue, // 두 번째 사각형의 색상
                ),
                Container(
                  width: 160, // 두 번째 사각형의 폭
                  height: 175, // 두 번째 사각형의 높이
                  color: Colors.blue, // 두 번째 사각형의 색상
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
                  width: 30,
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
            Container(
              width: 350, // Container의 폭
              height: 145, // Container의 높이
              color: Colors.blue, // Container의 색상
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 9, // Y축의 최대값
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
          ],
        ),
      ),
    );
  }
}
