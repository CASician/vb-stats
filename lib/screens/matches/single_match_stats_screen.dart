import 'package:flutter/material.dart';
import 'package:vb_stats/controllers/player_controller.dart';
import 'package:vb_stats/db/database.dart';
import 'package:vb_stats/models/match.dart';
import 'package:vb_stats/models/team.dart';
import 'package:vb_stats/screens/matches/play/choose_team.dart';

class SingleMatchStatsScreen extends StatelessWidget {
  final Match match;

  const SingleMatchStatsScreen({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Stats'),
      ),
      body: Column(
        children: [
          // Lista di blocchi placeholder per le statistiche
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Numero di blocchi placeholder
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length]
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "No stats yet",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FutureBuilder per mostrare il nome della squadra in casa
              FutureBuilder<Team?>(
                future: DatabaseHelper.instance.getTeamById(match.team),
                builder: (context, snapshot) {
                  String teamName = snapshot.hasData && snapshot.data != null
                      ? snapshot.data!.name
                      : 'My Team';
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$teamName vs ${match.opponent}',
                          style: const TextStyle(fontSize: 20)),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectPlayersScreen(match: match)),
                  );
                },
                child: const Text('PLAY!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
