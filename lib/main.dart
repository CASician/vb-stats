import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/match_screen.dart';
import 'screens/season_screen.dart';
import 'screens/stat_screen.dart';

void main() {
  runApp(VBStatsApp());
}

class VBStatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VB Stats',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/match': (context) => MatchScreen(),
        '/season': (context) => SeasonScreen(),
      },
    );
  }
}
