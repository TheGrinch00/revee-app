class Category {
  final String name;
  final int regularity;
  final int id;

  Category({
    required this.id,
    required this.name,
    required this.regularity,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['Category'] as String,
      regularity: json['Regularity'] as int,
    );
  }
}
