import 'package:flutter/material.dart';
import 'stat_screen.dart';
import '../models/match.dart';
import '../db/database.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<Match> matches = [];

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final loadedMatches = await DatabaseHelper.instance.getMatches();
    setState(() {
      matches = loadedMatches;
    });
  }

  void _addMatch() async {
    final newMatch = Match(opponent: 'Nuova Squadra', date: DateTime.now());
    await DatabaseHelper.instance.insertMatch(newMatch);
    _loadMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestisci Partite')),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return ListTile(
            title: Text(match.opponent),
            subtitle: Text(match.date.toString()),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatScreen(matchId: match.id!)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMatch,
        child: Icon(Icons.add),
      ),
    );
  }
}
