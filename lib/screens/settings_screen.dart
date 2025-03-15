import 'package:flutter/material.dart';

import '../widgets/navbar.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Screen'),
      ),
      body: Center(
        child: Text('Questa è la SettingsScreen vuota.'),
      ),
      bottomNavigationBar: CustomNavbar(currentIndex: 3),
    );
  }
}
