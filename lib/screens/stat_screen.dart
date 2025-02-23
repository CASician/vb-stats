import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/stat.dart';
import '../db/database.dart';

class StatScreen extends StatefulWidget {
  final int matchId;
  StatScreen({required this.matchId});

  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  List<Player> players = [];
  List<Stat> stats = [];

  @override
  void initState() {
    super.initState();
    _initializePlayers();
    _loadStats();
  }

  Future<void> _initializePlayers() async {
    final existingPlayers = await DatabaseHelper.instance.getPlayers();
    if (existingPlayers.isEmpty) {
      await _askForPlayers();
    }
    setState(() {
      players = existingPlayers;
    });
  }

  Future<void> _askForPlayers() async {
    List<Player> newPlayers = List.generate(7, (index) => Player(name: "", number: 0, role: ""));
    List<TextEditingController> nameControllers = List.generate(7, (_) => TextEditingController());
    List<TextEditingController> numberControllers = List.generate(7, (_) => TextEditingController());
    List<TextEditingController> roleControllers = List.generate(7, (_) => TextEditingController());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Inserisci i Giocatori"),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(7, (index) {
                return Column(
                  children: [
                    TextField(
                      controller: nameControllers[index],
                      decoration: InputDecoration(labelText: "Nome Giocatore ${index + 1}"),
                    ),
                    TextField(
                      controller: numberControllers[index],
                      decoration: InputDecoration(labelText: "Numero Maglia"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: roleControllers[index],
                      decoration: InputDecoration(labelText: "Ruolo"),
                    ),
                  ],
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annulla"),
            ),
            TextButton(
              onPressed: () async {
                for (int i = 0; i < 7; i++) {
                  newPlayers[i].name = nameControllers[i].text;
                  newPlayers[i].number = int.tryParse(numberControllers[i].text) ?? 0;
                  newPlayers[i].role = roleControllers[i].text;
                  await DatabaseHelper.instance.insertPlayer(newPlayers[i]);
                }
                setState(() {
                  players = newPlayers;
                });
                Navigator.pop(context);
              },
              child: Text("Conferma"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadStats() async {
    final loadedStats = await DatabaseHelper.instance.getStatsForMatch(widget.matchId);
    setState(() {
      stats = loadedStats;
    });
  }

  void _addAction(Player player) async {
    String? action = await _showActionDialog();
    if (action != null) {
      Stat newStat = Stat(
          matchId: widget.matchId,
          playerId: player.id!,
          action: action
      );
      await DatabaseHelper.instance.insertStat(newStat);
      _loadStats();
    }
  }

  Future<String?> _showActionDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Seleziona un'azione"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["Attacco", "Muro", "Ace", "Errore", "Difesa", "Ricezione"].map((action) {
              return ListTile(
                title: Text(action),
                onTap: () => Navigator.pop(context, action),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _editPlayers() async {
    await _askForPlayers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistiche Partita')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
              ),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return GestureDetector(
                  onTap: () => _addAction(player),
                  child: CircleAvatar(
                    child: Text(player.number.toString()),
                    backgroundColor: index == 6 ? Colors.lightBlueAccent : Colors.blueAccent,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _editPlayers,
            child: Text('Modifica Giocatori'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final stat = stats[index];
                return ListTile(
                  title: Text("Giocatore ${stat.playerId}: ${stat.action}"),
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
          ),
        ],
      ),
    );
  }
}
