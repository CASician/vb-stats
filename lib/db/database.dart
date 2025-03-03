import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/stat.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vb_stats.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 22,
      onConfigure: (db) async {
        // Abilita le foreign key
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1) TEAMS
    await db.execute('''
      CREATE TABLE teams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // 2) PLAYERS
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        number INTEGER NOT NULL,
        name TEXT NOT NULL,
        teamId INTEGER,
        FOREIGN KEY(teamId) REFERENCES teams(id) ON DELETE CASCADE
      )
    ''');

    // 3) MATCHES
    await db.execute('''
      CREATE TABLE matches (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        opponent TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // 4) STATS
    await db.execute('''
      CREATE TABLE stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        matchId INTEGER NOT NULL,
        playerId INTEGER NOT NULL,
        actionType TEXT NOT NULL,
        val TEXT,
        game INTEGER NOT NULL,
        FOREIGN KEY(matchId) REFERENCES matches(id) ON DELETE CASCADE,
        FOREIGN KEY(playerId) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');
  }

  // ------------------- CRUD per TEAMS -------------------
  Future<int> insertTeam(Team team) async {
    final db = await database;
    return await db.insert('teams', team.toMap());
  }

  Future<List<Team>> getAllTeams() async {
    final db = await database;
    final result = await db.query('teams');
    return result.map((map) => Team.fromMap(map)).toList();
  }

  Future<int> updateTeam(Team team) async {
    final db = await database;
    return await db.update(
      'teams',
      team.toMap(),
      where: 'id = ?',
      whereArgs: [team.id],
    );
  }

  Future<int> deleteTeam(int id) async {
    final db = await database;
    return await db.delete('teams', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------- CRUD per PLAYERS -------------------
  Future<int> insertPlayer(Player player) async {
    final db = await database;
    return await db.insert('players', player.toMap());
  }

  Future<List<Player>> getAllPlayers() async {
    final db = await database;
    final result = await db.query('players');
    return result.map((map) => Player.fromMap(map)).toList();
  }

  Future<List<Player>> getPlayersByTeam(int teamId) async {
    final db = await database;
    final result = await db.query('players', where: 'teamId = ?', whereArgs: [teamId]);
    return result.map((map) => Player.fromMap(map)).toList();
  }

  Future<int> updatePlayer(Player player) async {
    final db = await database;
    return await db.update(
      'players',
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id],
    );
  }

  Future<int> deletePlayer(int id) async {
    final db = await database;
    return await db.delete('players', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------- CRUD per MATCHES -------------------
  Future<int> insertMatch(Match match) async {
    final db = await database;
    return await db.insert('matches', match.toMap());
  }

  Future<List<Match>> getAllMatches() async {
    final db = await database;
    final result = await db.query('matches');
    return result.map((map) => Match.fromMap(map)).toList();
  }

  Future<int> updateMatch(Match match) async {
    final db = await database;
    return await db.update(
      'matches',
      match.toMap(),
      where: 'id = ?',
      whereArgs: [match.id],
    );
  }

  Future<int> deleteMatch(int id) async {
    final db = await database;
    return await db.delete('matches', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------- CRUD per STATS -------------------
  Future<int> insertStat(Stat stat) async {
    final db = await database;
    return await db.insert('stats', stat.toMap());
  }

  Future<List<Stat>> getStatsForMatch(int matchId) async {
    final db = await database;
    final result = await db.query('stats', where: 'matchId = ?', whereArgs: [matchId]);
    return result.map((map) => Stat.fromMap(map)).toList();
  }

  Future<int> updateStat(Stat stat) async {
    final db = await database;
    return await db.update(
      'stats',
      stat.toMap(),
      where: 'id = ?',
      whereArgs: [stat.id],
    );
  }

  Future<int> deleteStat(int id) async {
    final db = await database;
    return await db.delete('stats', where: 'id = ?', whereArgs: [id]);
  }
}
