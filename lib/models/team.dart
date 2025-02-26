class Team {
  int? id;
  String name;

  Team({
    this.id,
    required this.name,
  });

  // Converti l’oggetto in Mappa (per SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Crei l’oggetto da una Mappa
  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
    );
  }
}
