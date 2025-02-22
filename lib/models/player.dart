class Player{
  int? id;
  String name;
  String role;
  int number;

  Player({this.id, required this.name, required this.role, required this.number});

  // Converti in mappa per salvarlo su SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'number': number,
    };
  }

  // Crea un oggetto Player da una mappa (tipo quando prendo i dati dal db)
  factory Player.fromMap(Map<String, dynamic> map){
   return Player(
     id: map['id'],
     name: map['name'],
     role: map['role'],
     number: map['number'],
   );
  }
}