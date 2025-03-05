class Match {
  int? id;
  int team;
  String opponent;
  DateTime date;

  Match({this.id, required this.team, required this.opponent, required this.date});

  // Convertire in mappa per SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'team': team,
      'opponent': opponent,
      'date': date.toIso8601String(), // Convertire DateTime in stringa
    };
  }

  // Creare un oggetto Match da una mappa
  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'],
      team: map['team'],
      opponent: map['opponent'],
      date: DateTime.parse(map['date']),
    );
  }
}
