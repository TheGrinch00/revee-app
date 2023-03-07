class Ward {
  final int id;
  final String name;

  Ward({required this.name, required this.id});

  ///Convert [json] from json map to Ward
  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      name: json['Ward'] as String,
      id: json['id'] as int,
    );
  }
}
