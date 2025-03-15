import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/matches/match_screen.dart';
import 'screens/season_screen.dart';
import 'db/database.dart';
import 'screens/teams/teams_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  await dotenv.load(fileName: ".env");
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
        '/match': (context) => MatchesScreen(),
        '/season': (context) => SeasonScreen(),
        '/teams': (context) => TeamsScreen(),
      },
    );
  }
}
