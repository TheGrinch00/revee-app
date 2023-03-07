class Employment {
  const Employment({required this.employmentName, required this.id});

  final String employmentName;
  final int id;

  factory Employment.fromJson(Map<String, dynamic> json) {
    return Employment(
      employmentName: json['Employment'] as String,
      id: json['id'] as int,
    );
  }
}
