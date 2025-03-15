import 'package:flutter/material.dart';
import 'package:vb_stats/db/database.dart';
import '../../models/team.dart';
import '../../models/player.dart';

class TeamDetailScreen extends StatefulWidget {
  final Team team;
  const TeamDetailScreen({Key? key, required this.team}) : super(key: key);

  @override
  _TeamDetailScreenState createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  late Future<List<Player>> _playersFuture;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  void _loadPlayers() {
    // Assumiamo che widget.team abbia un id non nullo.
    _playersFuture = DatabaseHelper.instance.getPlayersByTeam(widget.team.id!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  // Dialogo per aggiungere un nuovo giocatore
  void _showAddPlayerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Aggiungi Giocatore'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Numero'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _numberController.clear();
                Navigator.pop(context);
              },
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                int number = int.tryParse(_numberController.text) ?? 0;
                if (name.isNotEmpty) {
                  // Crea il nuovo giocatore, passando l'intero oggetto team
                  Player newPlayer = Player(
                    number: number,
                    name: name,
                    teamId: widget.team.id as int,
                  );
                  await DatabaseHelper.instance.insertPlayer(newPlayer);
                  _nameController.clear();
                  _numberController.clear();
                  Navigator.pop(context);
                  setState(() {
                    _loadPlayers(); // Ricarica la lista dei giocatori
                  });
                }
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.team.name,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      body: FutureBuilder<List<Player>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final players = snapshot.data!;
            if (players.isEmpty) {
              return const Center(child: Text('Nessun giocatore trovato.'));
            }
            return ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(player.number.toString()),
                  ),
                  title: Text(player.name),
                );
              },
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlayerDialog,
        child: const Icon(Icons.add),
        tooltip: 'Aggiungi Giocatore',
      ),
    );
  }
}
