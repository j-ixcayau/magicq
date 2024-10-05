import 'package:magiq/model/point.dart';

class Category {
  final int id;
  final String name;
  final List<Point> points;

  Category({
    required this.id,
    required this.name,
    required this.points,
  });

  // Custom fromJson method
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      points: (json['points'] as List<dynamic>)
          .map((point) => Point.fromJson(point as Map<String, dynamic>))
          .toList(),
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'points': points.map((point) => point.toJson()).toList(),
    };
  }
}
