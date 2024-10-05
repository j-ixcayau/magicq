import 'package:magiq/model/user_point.dart';

class Medal {
  final String name; // Primary key, using String
  final String description;
  final int requiredPoints; // Changed to camelCase
  final List<UserPoints> userPoints;

  Medal({
    required this.name,
    required this.description,
    required this.requiredPoints,
    required this.userPoints,
  });

  // Custom fromJson method
  factory Medal.fromJson(Map<String, dynamic> json) {
    return Medal(
      name: json['name'] as String,
      description: json['description'] as String,
      requiredPoints: json['required_points'] as int,
      userPoints: (json['userPoints'] as List<dynamic>)
          .map((userPoint) =>
              UserPoints.fromJson(userPoint as Map<String, dynamic>))
          .toList(), // Assuming UserPoints class has fromJson method
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'required_points': requiredPoints,
      'userPoints': userPoints
          .map((userPoint) => userPoint.toJson())
          .toList(), // Assuming UserPoints class has toJson method
    };
  }
}
