import 'actions.dart';


class Stat {
  int? id;
  int matchId;
  int playerId;
  int game;
  ActionType actionType;
  ActionValue? val;

  Stat({
    this.id,
    required this.matchId,
    required this.playerId,
    required this.actionType,
    this.val,
    required this.game,
  });

  // Converti l'oggetto in mappa per SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'matchId': matchId,
      'playerId': playerId,
      'actionType': actionType.toString(), // salviamo come stringa
      'val': val?.toString(),               // salviamo come stringa (se non null)
      'game': game,
    };
  }

  // Crea un oggetto Stat a partire da una mappa
  factory Stat.fromMap(Map<String, dynamic> map) {
    // Converti la stringa dell'enum in valore enum
    final String actionTypeStr = map['actionType'];
    ActionType parsedActionType = ActionType.values.firstWhere(
          (e) => e.toString() == actionTypeStr,
      orElse: () => ActionType.other, // fallback se non corrisponde
    );

    // Converti la stringa dell'enum per val, se presente
    ActionValue? parsedVal;
    if (map['val'] != null) {
      final valStr = map['val'] as String;
      parsedVal = ActionValue.values.firstWhere(
            (e) => e.toString() == valStr,
        orElse: () => ActionValue.mistake, // fallback
      );
    }

    return Stat(
      id: map['id'],
      matchId: map['matchId'],
      playerId: map['playerId'],
      game: map['game'],
      actionType: parsedActionType,
      val: parsedVal,
    );
  }
}
