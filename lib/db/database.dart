import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/stat.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('volleyball_stats.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async { // FIXME: modify correctly for new version without role.
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        number INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE matches (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        opponent TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        match_id INTEGER,
        player_id INTEGER,
        action TEXT
        FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertPlayer(Player player) async {
    final db = await instance.database;
    return await db.insert('players', player.toMap());
  }

  Future<int> insertMatch(Match match) async {
    final db = await instance.database;
    return await db.insert('matches', match.toMap());
  }

  Future<int> insertStat(Stat stat) async {
    final db = await instance.database;
    return await db.insert('stats', stat.toMap());
  }

  Future<List<Player>> getPlayers() async {
    final db = await instance.database;
    final result = await db.query('players');
    return result.map((json) => Player.fromMap(json)).toList();
  }

  Future<List<Match>> getMatches() async {
    final db = await instance.database;
    final result = await db.query('matches');
    return result.map((json) => Match.fromMap(json)).toList();
  }

  Future<List<Stat>> getStatsForMatch(int matchId) async {
    final db = await instance.database;
    final result = await db.query('stats', where: 'match_id = ?', whereArgs: [matchId]);
    return result.map((json) => Stat.fromMap(json)).toList();
  }

  Future<int> updatePlayer(Player player) async {
    final db = await instance.database;
    return await db.update('players', player.toMap(), where: 'id = ?', whereArgs: [player.id]);
  }

  Future<int> updateMatch(Match match) async {
    final db = await instance.database;
    return await db.update('matches', match.toMap(), where: 'id = ?', whereArgs: [match.id]);
  }

  Future<int> updateStat(Stat stat) async {
    final db = await instance.database;
    return await db.update('stats', stat.toMap(), where: 'id = ?', whereArgs: [stat.id]);
  }

  Future<int> deletePlayer(int id) async {
    final db = await instance.database;
    return await db.delete('players', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMatch(int id) async {
    final db = await instance.database;
    return await db.delete('matches', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteStat(int id) async {
    final db = await instance.database;
    return await db.delete('stats', where: 'id = ?', whereArgs: [id]);
  }
}
