class Division {
  final String name;
  final String acronym;
  final int id;
  final int zoneId;
  int clientCount = 0;

  Division({
    required this.name,
    required this.acronym,
    required this.id,
    required this.zoneId,
  });

  ///Convert [json] from json map to Division
  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      name: json['DivisionName'] as String,
      acronym: json['DivisionAcronym'] as String,
      id: json['id'] as int,
      zoneId: json['ZoneId'] as int,
    );
  }
}
