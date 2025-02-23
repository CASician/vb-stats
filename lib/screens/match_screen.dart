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
    String? matchName = await _showMatchNameDialog();
    if (matchName != null && matchName.isNotEmpty) {
      final newMatch = Match(opponent: matchName, date: DateTime.now());
      await DatabaseHelper.instance.insertMatch(newMatch);
      _loadMatches();
    }
  }

  Future<String?> _showMatchNameDialog() async {
    String matchName = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nome della Partita'),
          content: TextField(
            onChanged: (value) {
              matchName = value;
            },
            decoration: InputDecoration(hintText: 'Inserisci il nome della partita'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, matchName),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMatch(int id) async {
    await DatabaseHelper.instance.deleteMatch(id);
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatScreen(matchId: match.id!)),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteMatch(match.id!),
            ),
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
