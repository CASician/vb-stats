import 'package:flutter/material.dart';
import 'package:vb_stats/screens/home_screen.dart';
import 'package:vb_stats/screens/settings_screen.dart';
import 'package:vb_stats/screens/teams/teams_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../screens/season_screen.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;

  const CustomNavbar({
    required this.currentIndex,
    super.key,
  });

  void _onItemTapped(BuildContext context, int index) {
    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = HomeScreen();
        break;
      case 1:
        nextScreen = TeamsScreen();
        break;
      case 2:
        nextScreen = SeasonScreen();
        break;
      case 3:
        nextScreen = SettingsScreen();
        break;
      default:
        nextScreen = HomeScreen();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(int.parse(dotenv.env['BACKGROUND_COLOR'] ?? '0xFF4CAF50')),
      selectedItemColor: Color(int.parse(dotenv.env['PRIMARY_COLOR'] ?? '0xFF4CAF50')),
      unselectedItemColor: Color(int.parse(dotenv.env['SECONDARY_COLOR'] ?? '0xFF4CAF50')),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_volleyball_outlined),
          label: 'Teams',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Stagione',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Impostazioni',
        ),
      ],
    );
  }
}
