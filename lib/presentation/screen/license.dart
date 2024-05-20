import 'package:flutter/material.dart';

class LicenseScreen extends StatefulWidget {
  const LicenseScreen({Key? key}) : super(key: key);

  @override
  _LicenseScreenState createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLicensePage(
        context: context,
        applicationName: 'Cross Wave',
        applicationVersion: '1.0.0',
        applicationLegalese: '© 2024 Cross Wave',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Information'),
      ),
      body: const Center(
        child: Text('Loading licenses...'),
      ),
    );
  }
}
