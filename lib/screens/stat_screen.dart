import 'package:flutter/material.dart';
import '../models/stat.dart';
import '../db/database.dart';

class StatScreen extends StatefulWidget {
  final int matchId;
  StatScreen({required this.matchId});

  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  List<Stat> stats = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final loadedStats = await DatabaseHelper.instance.getStatsForMatch(widget.matchId);
    setState(() {
      stats = loadedStats;
    });
  }

  void _addStat() async {
    final newStat = Stat(matchId: widget.matchId, playerId: 1, action: 'Punto');
    await DatabaseHelper.instance.insertStat(newStat);
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistiche Partita')),
      body: ListView.builder(
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final stat = stats[index];
          return ListTile(
            title: Text('Giocatore: ${stat.playerId} - Azione: ${stat.action}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deleteStat(stat.id!);
                _loadStats();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStat,
        child: Icon(Icons.add),
      ),
    );
  }
}
