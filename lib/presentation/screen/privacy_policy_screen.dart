import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Future<String> _loadPrivacyPolicyText() async {
    try {
      return await rootBundle.loadString('assets/privacy_policy.md');
    } catch (e) {
      print('Error reading privacy policy file: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 처리방침'),
      ),
      body: FutureBuilder(
        future: _loadPrivacyPolicyText(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Markdown(data: snapshot.data!);
          } else {
            return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
          }
        },
      ),
    );
  }
}
