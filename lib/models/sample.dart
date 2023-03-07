enum AllowedTypes {
  BOOL,
  NUMBER,
}

extension DescribedTypes on AllowedTypes {
  String get value {
    switch (this) {
      case AllowedTypes.BOOL:
        return "bool";
      case AllowedTypes.NUMBER:
        return "number";
    }
  }
}

class Sample {
  final int id;
  final String name;
  final AllowedTypes type;

  const Sample({
    required this.id,
    required this.name,
    required this.type,
  });

  static Sample? fromJson(Map<String, dynamic> jsonData) {
    final id = jsonData['id'] as int?;
    final name = jsonData['name'] as String?;
    final typeString = jsonData['type'] as String?;

    if (id == null || name == null || typeString == null) {
      return null;
    }

    // Array with string values of types enum
    final allowedTypes =
        AllowedTypes.values.map((allowedType) => allowedType.value);

    if (!allowedTypes.contains(typeString)) {
      return null;
    }

    final type = AllowedTypes.values
        .firstWhere((allowedType) => allowedType.value == typeString);

    return Sample(
      id: id,
      name: name,
      type: type,
    );
  }
}
