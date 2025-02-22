import 'package:flutter/material.dart';
import '../models/match.dart';
import '../db/database.dart';

class SeasonScreen extends StatefulWidget {
  @override
  _SeasonScreenState createState() => _SeasonScreenState();
}

class _SeasonScreenState extends State<SeasonScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Andamento Stagione')),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return ListTile(
            title: Text(match.opponent),
            subtitle: Text(match.date.toString()),
            // trailing: Text('Risultato: ${match.result ?? "N/D"}'),
          );
        },
      ),
    );
  }
}
