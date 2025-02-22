class Stat {
  int? id;
  int matchId; // Riferimento alla partita
  int playerId; // Riferimento al giocatore
  int points; // Punti realizzati
  int aces; // Ace su servizio
  int errors; // Errori
  int attacks; // Attacchi effettuati
  int receptions; // Ricezioni

  Stat({
    this.id,
    required this.matchId,
    required this.playerId,
    this.points = 0,
    this.aces = 0,
    this.errors = 0,
    this.attacks = 0,
    this.receptions = 0,
  });

  // Convertire in mappa per SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'match_id': matchId,
      'player_id': playerId,
      'points': points,
      'aces': aces,
      'errors': errors,
      'attacks': attacks,
      'receptions': receptions,
    };
  }

  // Creare un oggetto Stat da una mappa
  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(
      id: map['id'],
      matchId: map['match_id'],
      playerId: map['player_id'],
      points: map['points'],
      aces: map['aces'],
      errors: map['errors'],
      attacks: map['attacks'],
      receptions: map['receptions'],
    );
  }
}
