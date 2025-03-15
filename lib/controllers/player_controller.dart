import 'package:sqflite/sqflite.dart';
import '../models/player.dart';
import '../db/database.dart'; // Classe per ottenere il database

Future<List<Player>> getPlayersByTeamId(int teamId) async {
  final Database db = await DatabaseHelper.instance.database;

  final List<Map<String, dynamic>> maps = await db.query(
    'players', // Nome della tabella dei giocatori
    where: 'teamId = ?', // Filtro per l'ID della squadra
    whereArgs: [teamId],
  );

  // Convertiamo ogni mappa in un oggetto Player
  return List.generate(maps.length, (i) {
    return Player(
      id: maps[i]['id'],
      name: maps[i]['name'],
      number: maps[i]['number'],
      teamId: maps[i]['teamId'],
    );
  });
}
