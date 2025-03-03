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

  @override
  void initState() {
    super.initState();
    // Assumiamo che il team abbia un id non nullo
    _playersFuture = DatabaseHelper.instance.getPlayersByTeam(widget.team.id!);
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
    );
  }
}