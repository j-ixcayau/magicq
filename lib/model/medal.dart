class Medal {
  final String name;
  final String description;
  final int requiredPoints;

  Medal({
    required this.name,
    required this.description,
    required this.requiredPoints,
  });

  // Custom fromJson method
  factory Medal.fromJson(Map<String, dynamic> json) {
    return Medal(
      name: json['name'] as String,
      description: json['description'] as String,
      requiredPoints: json['required_points'] as int,
    );
  }
}
