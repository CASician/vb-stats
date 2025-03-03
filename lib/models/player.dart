import 'team.dart';

class Player{
  int? id;
  String name;
  int number;
  int teamId;

  Player({this.id, required this.name, required this.number, required this.teamId});

  // Converti in mappa per salvarlo su SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'teamId': teamId,
    };
  }

  // Crea un oggetto Player da una mappa (tipo quando prendo i dati dal db)
  factory Player.fromMap(Map<String, dynamic> map){
   return Player(
     id: map['id'],
     name: map['name'],
     number: map['number'],
     teamId: map['teamId'],
   );
  }
}