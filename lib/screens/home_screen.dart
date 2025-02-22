import 'package:flutter/material.dart';
import 'match_screen.dart';
import 'season_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VB Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MatchScreen()),
                );
              },
              child: Text('Gestisci Partita'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeasonScreen()),
                );
              },
              child: Text('Andamento Stagione'),
            ),
          ],
        ),
      ),
    );
  }
}
