class FacilityType {
  final int id;
  final String name;

  FacilityType({
    required this.name,
    required this.id,
  });

  ///Convert [json] from json map to FacilityType
  factory FacilityType.fromJson(Map<String, dynamic> json) {
    return FacilityType(
      name: json['Type'] as String,
      id: json['id'] as int,
    );
  }
}
