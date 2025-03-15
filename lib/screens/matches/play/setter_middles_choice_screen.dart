import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vb_stats/models/player.dart';

class SelectPositionsScreen extends StatefulWidget {
  // I 6 giocatori già posizionati (in un ordine logico: [player1, player2, ..., player6])
  final List<Player> fieldPlayers;

  const SelectPositionsScreen({Key? key, required this.fieldPlayers}) : super(key: key);

  @override
  _SelectPositionsScreenState createState() => _SelectPositionsScreenState();
}

class _SelectPositionsScreenState extends State<SelectPositionsScreen> {
  // Indice (mappato) del giocatore selezionato come palleggiatore
  int? selectedSetterIndex;
  // Insieme degli indici evidenziati (secondo la logica: -1 e +2 rispetto al setter)
  final Set<int> highlightedIndices = {};

  @override
  void initState() {
    super.initState();
    // Forza l'orientamento landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    /*
    // Ripristina l'orientamento portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    */
    super.dispose();
  }

  /// La funzione di mapping restituisce l'indice nel vettore [player1,...,player6]
  /// in base all'indice lineare (0..5) nella griglia.
  /// La mappatura è definita in modo che:
  /// - Grid index 0 (top-left) mostra player4,
  /// - index 1 mostra player3,
  /// - index 2 mostra player2,
  /// - index 3 mostra player5,
  /// - index 4 mostra player6,
  /// - index 5 (bottom-right) mostra player1.
  int _mappedIndex(int index) {
    List<int> mapping = [3, 2, 1, 4, 5, 0];
    return mapping[index];
  }

  void updateHighlights() {
    highlightedIndices.clear();
    if (selectedSetterIndex != null) {
      int i = selectedSetterIndex!;
      // Evidenzia l'indice a distanza -1: se non esiste, evidenzia l'ultimo (5)
      if (i - 1 >= 0) {
        highlightedIndices.add(i - 1);
      } else {
        highlightedIndices.add(5);
      }
      // Evidenzia l'indice a distanza +2, usando modulo 6
      highlightedIndices.add((i + 2) % 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Due container affiancati: sinistro per la selezione del palleggiatore, destro per l'evidenziazione dei centrali.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleziona Ruoli'),
      ),
      body: Row(
        children: [
          // Container sinistro: "Chi è il palleggiatore?"
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Chi è il palleggiatore?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: widget.fieldPlayers.length,
                    itemBuilder: (context, index) {
                      int mapped = _mappedIndex(index);
                      final player = widget.fieldPlayers[mapped];
                      bool isSelected = (selectedSetterIndex != null && selectedSetterIndex == mapped);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSetterIndex = mapped;
                            updateHighlights();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              '${player.number}\n${player.name}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Container destro: "Con chi si cambierà il libero"
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Con chi si cambierà il libero',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: widget.fieldPlayers.length,
                    itemBuilder: (context, index) {
                      int mapped = _mappedIndex(index);
                      final player = widget.fieldPlayers[mapped];
                      bool isHighlighted = highlightedIndices.contains(mapped);
                      return Container(
                        decoration: BoxDecoration(
                          color: isHighlighted ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: Text(
                            '${player.number}\n${player.name}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottone per salvare la configurazione e passare alla schermata Play()
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedSetterIndex == null || highlightedIndices.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Seleziona il palleggiatore per evidenziare i centrali")),
            );
          } else {
            // Salva la configurazione se necessario e naviga alla schermata Play()
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Placeholder()),
            );
          }
        },
        child: const Icon(Icons.check),
        tooltip: "Salva configurazione e Play",
      ),
    );
  }
}
