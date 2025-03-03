import 'package:flutter/material.dart';
import 'package:vb_stats/db/database.dart';
import 'package:vb_stats/models/team.dart';
import 'package:vb_stats/models/player.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({Key? key}) : super(key: key);

  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();

  // Lista di mappe per i controller dei giocatori, dove ogni mappa contiene un controller per "name" e uno per "number"
  final List<Map<String, TextEditingController>> _playerControllers = [];

  @override
  void initState() {
    super.initState();
    // Iniziamo con un form per il primo giocatore
    _addPlayerForm();
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    for (var controllers in _playerControllers) {
      controllers['name']!.dispose();
      controllers['number']!.dispose();
    }
    super.dispose();
  }

  // Aggiunge una nuova coppia di controller per un nuovo giocatore
  void _addPlayerForm() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    _playerControllers.add({
      'name': nameController,
      'number': numberController,
    });
    setState(() {});
  }

  // Salva il team e i giocatori nel database
  void _saveTeam() async {
    if (_formKey.currentState!.validate()) {
      // Crea il team e salvalo per ottenere l'id
      final teamName = _teamNameController.text;
      Team team = Team(name: teamName);
      int teamId = await DatabaseHelper.instance.insertTeam(team);
      // Aggiorna l'oggetto team con l'id assegnato dal database
      team.id = teamId;

      // Salva i giocatori, assegnando il team (con id) ad ogni giocatore
      for (var controllers in _playerControllers) {
        final playerName = controllers['name']!.text;
        final playerNumber = int.tryParse(controllers['number']!.text) ?? 0;
        // Salviamo solo i giocatori con nome non vuoto
        if (playerName.isNotEmpty) {
          Player player = Player(
            number: playerNumber,
            name: playerName,
            teamId: teamId,
          );
          await DatabaseHelper.instance.insertPlayer(player);
        }
      }

      // Dopo il salvataggio, torniamo alla schermata dei team
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea Squadra'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo per il nome della squadra
                TextFormField(
                  controller: _teamNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Squadra',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il nome della squadra';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Lista dei form per i giocatori
                Column(
                  children: List.generate(_playerControllers.length, (index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Giocatore ${index + 1}'),
                            TextFormField(
                              controller: _playerControllers[index]['name'],
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                              ),
                              validator: (value) {
                                // Può essere opzionale oppure obbligatorio
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _playerControllers[index]['number'],
                              decoration: const InputDecoration(
                                labelText: 'Numero',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci il numero';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Inserisci un numero valido';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // Bottone per aggiungere un nuovo giocatore (nuovo mini-form)
                ElevatedButton(
                  onPressed: _addPlayerForm,
                  child: const Text('Aggiungi giocatore'),
                ),
                const SizedBox(height: 20),
                // Bottone per salvare il team
                ElevatedButton(
                  onPressed: _saveTeam,
                  child: const Text('Salva Squadra'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
