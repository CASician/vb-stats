import 'package:flutter/material.dart';
import 'package:vb_stats/widgets/text_button.dart';
import '../widgets/navbar.dart';
import 'matches/match_screen.dart';
import 'season_screen.dart';
import 'teams/teams_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('VB Stats')
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 100),
            TextButtonMio(
                onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MatchesScreen()),
                  );},
                label: 'PARTITE'
            ),
            SizedBox(height: 16),
            TextButtonMio(
                onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeamsScreen()),
                  );},
                label: 'SQUADRE'
            ),

            SizedBox(height: 48),
            TextButtonMio(
                onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SeasonScreen()),
                  );},
                label: 'STAGIONE'
            ),

          ],
        ),
      ),
      bottomNavigationBar: CustomNavbar(currentIndex: 0),
    );
  }
}
