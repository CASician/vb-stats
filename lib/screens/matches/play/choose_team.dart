import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vb_stats/models/match.dart';
import 'package:vb_stats/models/player.dart';
import 'package:vb_stats/screens/matches/play/setter_middles_choice_screen.dart';

import '../../../controllers/player_controller.dart';

class SelectPlayersScreen extends StatefulWidget {
  final Match match; // L'oggetto Match, dove match.team contiene l'ID della squadra

  const SelectPlayersScreen({Key? key, required this.match}) : super(key: key);

  @override
  _SelectPlayersScreenState createState() => _SelectPlayersScreenState();
}

class _SelectPlayersScreenState extends State<SelectPlayersScreen> {
  // Lista dei giocatori disponibili, caricati dal database tramite il controller
  List<Player> availablePlayers = [];
  // 6 slot per i giocatori in campo (null se vuoto)
  List<Player?> fieldPositions = List<Player?>.filled(6, null);
  // Slot per il libero (null se vuoto)
  Player? libero;

  @override
  void initState() {
    super.initState();
    // Forza l'orientamento in landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Carica i giocatori disponibili dalla squadra specificata
    _loadAvailablePlayers();
  }

  Future<void> _loadAvailablePlayers() async {
    final players = await getPlayersByTeamId(widget.match.team);
    print("Team ID: ${widget.match.team} -> ${players.length} giocatori trovati");
    if (!mounted) return;
    setState(() {
      availablePlayers = players;
    });
  }


  @override
  void dispose() {
    // Ripristina l'orientamento a portrait quando la schermata viene chiusa
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // Quando si tocca un giocatore dalla lista di sinistra, mostra un dialogo per selezionare la posizione
  void _selectPositionForPlayer(Player player) async {
    List<String> options = [];
    List<int> fieldIndices = [];
    for (int i = 0; i < fieldPositions.length; i++) {
      if (fieldPositions[i] == null) {
        options.add("Posizione ${i + 1}");
        fieldIndices.add(i);
      }
    }
    // Aggiungi l'opzione per il Libero se libero è vuoto
    if (libero == null) {
      options.add("Libero");
    }

    if (options.isEmpty) return;

    String? selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Seleziona posizione"),
          children: options
              .map((option) => SimpleDialogOption(
            onPressed: () => Navigator.pop(context, option),
            child: Text(option),
          ))
              .toList(),
        );
      },
    );

    if (selected != null) {
      setState(() {
        availablePlayers.remove(player);
        if (selected == "Libero") {
          libero = player;
        } else {
          int pos = int.parse(selected.split(" ").last) - 1;
          fieldPositions[pos] = player;
        }
      });
    }
  }

  // Rimuove un giocatore da uno slot (campo o libero) e lo riporta nella lista disponibile
  void _removePlayerFromSlot({required bool isLibero, int? index}) {
    setState(() {
      if (isLibero) {
        if (libero != null) {
          availablePlayers.add(libero!);
          libero = null;
        }
      } else if (index != null) {
        if (fieldPositions[index] != null) {
          availablePlayers.add(fieldPositions[index]!);
          fieldPositions[index] = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Layout in landscape: lista dei giocatori a sinistra e campo a destra
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleziona Giocatori in Campo"),
      ),
      body: Row(
        children: [
          // Lista dei giocatori disponibili (sinistra)
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: availablePlayers.length,
                itemBuilder: (context, index) {
                  final player = availablePlayers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(player.number.toString()),
                      ),
                      title: Text(player.name),
                      onTap: () => _selectPositionForPlayer(player),
                    ),
                  );
                },
              ),
            ),
          ),
          // Campo da pallavolo (destra)
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Griglia per le 6 posizioni sul campo
                  // Griglia per le 6 posizioni sul campo
                  Expanded(
                    child: GridView.builder(
                      itemCount: 6,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.6, // Ridotto per riquadri più piccoli
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final player = fieldPositions[index];
                        return GestureDetector(
                          onTap: () {
                            if (player != null) {
                              _removePlayerFromSlot(isLibero: false, index: index);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: player != null ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: player != null
                                      ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        player.number.toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      Text(
                                        player.name,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  )
                                      : const Text("Vuoto"),
                                ),
                                if (player != null)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removePlayerFromSlot(isLibero: false, index: index),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Box per il Libero
                  Row(
                    children: [
                      const Text("Libero: "),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (libero != null) {
                              _removePlayerFromSlot(isLibero: true);
                            }
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: libero != null ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: libero != null
                                  ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      libero!.number.toString(),
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    libero!.name,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              )
                                  : const Text("Vuoto"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottone per salvare la configurazione e andare alla pagina Play()
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (fieldPositions.every((p) => p != null) && libero != null) {
            // Crea la lista dei giocatori in campo
            List<Player> fieldPlayers = fieldPositions.map((p) => p!).toList();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectPositionsScreen(fieldPlayers: fieldPlayers),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Seleziona tutti i giocatori prima di continuare")),
            );
          }
        },
        child: const Icon(Icons.check),
        tooltip: "Salva configurazione e Play",
      ),

    );
  }
}
