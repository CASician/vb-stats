import 'package:flutter/material.dart';
import 'package:vb_stats/db/database.dart';
import 'package:vb_stats/screens/teams/create_team_screen.dart';
import 'package:vb_stats/screens/teams/team_detail_screen.dart';
import '../../models/team.dart';
import '../../widgets/navbar.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  Future<List<Team>> _fetchTeams() {
    return DatabaseHelper.instance.getAllTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Screen')),
      body: FutureBuilder<List<Team>>(
        future: _fetchTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final teams = snapshot.data!;
            if (teams.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Non hai ancora creato nessuna squadra.'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateTeamScreen()),
                        ).then((_) {
                          setState(() {}); // aggiorna la lista dopo la creazione
                        });
                      },
                      child: const Text("Crea squadra"),
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                body: ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return ListTile(
                      title: Text(team.name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TeamDetailScreen(team: team)),
                        ).then((_) {
                          setState(() {}); // aggiornamento alla chiusura della pagina dettaglio
                        });
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          if (team.id != null) {
                            await DatabaseHelper.instance.deleteTeam(team.id!);
                            setState(() {}); // aggiornamento dopo l'eliminazione
                          }
                        },
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateTeamScreen()),
                    ).then((_) => setState(() {})); // Aggiorna la lista al ritorno
                  },
                  child: const Icon(Icons.add),
                  tooltip: "Crea nuova squadra",
                ),
              );

            }
          }
          return Container();
        },
      ),
      bottomNavigationBar: const CustomNavbar(currentIndex: 1),
    );
  }
}
