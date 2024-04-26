import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('반갑습니다 \$name님'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // home으로 이동하는 코드
            },
            child: const Text('로그아웃'),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: CircleAvatar(
                      radius: 50,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text('이름: \$name'),
                      SizedBox(height: 10),
                      Text('이메일: \$email'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 130,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('일일 성취 진행도'),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 250,
                    height: 10,
                    child: LinearProgressIndicator(
                      value: 0.8,
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 250,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Text(
                          '\$level',
                          style: TextStyle(fontSize: 18),
                        ),
                        Image(
                          width: 70,
                          height: 70,
                          image: AssetImage(
                            'assets/images/bronze.png',
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 100),
                  ElevatedButton(
                    onPressed: () {

                    },
                    child: Text('지난 학습 보기'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 400,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('주간 진행도', style: TextStyle(fontSize: 24),),
                   SizedBox(height: 150),
                   Text('일    월    화    수    목    금    토    일',style: TextStyle(fontSize: 24),),
                ],
              ),
            ),
          ),
        ],
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
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey,
            ),
            label: 'more',
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
      )
    );
  }
}
