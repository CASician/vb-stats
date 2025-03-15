import 'package:flutter/material.dart';

import '../widgets/navbar.dart';

class SeasonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Season Screen'),
      ),
      body: Center(
        child: Text('Questa è la SeasonScreen vuota.'),
      ),
      bottomNavigationBar: CustomNavbar(currentIndex: 2),
    );
  }
}
