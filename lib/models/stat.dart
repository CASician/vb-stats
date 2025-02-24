class Stat {
  int? id;
  int matchId;
  int set;
  int playerId;
  String action;
  String val;

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
