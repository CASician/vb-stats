class Stat {
  int? id;
  int matchId;
  int playerId;
  String action; // Nuovo campo per registrare l'azione (es. "Attacco", "Muro", ecc.)

  Stat({
    this.id,
    required this.matchId,
    required this.playerId,
    required this.action,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'matchId': matchId,
      'playerId': playerId,
      'action': action,
    };
  }

  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(
      id: map['id'],
      matchId: map['matchId'],
      playerId: map['playerId'],
      action: map['action'],
    );
  }
}
