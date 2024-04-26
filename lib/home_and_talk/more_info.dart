import 'package:flutter/material.dart';

import 'home.dart';
import 'profile_screen.dart';

class MoreInfo extends StatefulWidget {
  const MoreInfo({super.key});

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
      ),
      body: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.home,
                      size: 40,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MoreInfo(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 40,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
