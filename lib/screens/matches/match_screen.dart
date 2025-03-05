import 'package:flutter/material.dart';
import 'package:vb_stats/db/database.dart';
import 'package:vb_stats/models/match.dart';
import 'package:vb_stats/screens/matches/single_match_stats_screen.dart';
import 'package:vb_stats/screens/matches/create_match_screen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  Future<List<Match>> _fetchMatches() {
    return DatabaseHelper.instance.getAllMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partite'),
      ),
      body: FutureBuilder<List<Match>>(
        future: _fetchMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final matches = snapshot.data!;
            if (matches.isEmpty) {
              // Nessuna partita registrata
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Nessuna partita registrata'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateMatchScreen()),
                        ).then((_) => setState(() {}));
                      },
                      child: const Text('Crea Partita'),
                    ),
                  ],
                ),
              );
            } else {
              // Lista delle partite con pulsante per eliminare e bottone in fondo per aggiungerne altre
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final match = matches[index];
                        return ListTile(
                          title: Text(match.opponent),
                          subtitle: Text(match.date.toIso8601String()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleMatchStatsScreen(match: match)),
                            ).then((_) => setState(() {}));
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              if (match.id != null) {
                                await DatabaseHelper.instance.deleteMatch(match.id!);
                                setState(() {}); // Aggiorna la lista dopo l'eliminazione
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateMatchScreen()),
                        ).then((_) => setState(() {}));
                      },
                      child: const Text('Crea Partita'),
                    ),
                  ),
                ],
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
