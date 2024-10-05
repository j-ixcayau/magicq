class Comment {
  final int id;
  final String content;
  final DateTime createdAt;
  final String userId;
  final String pointId;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.pointId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['userId'] as String,
      pointId: json['pointId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'created_at': createdAt.toIso8601String(), // Convert DateTime to string
      'userId': userId,
      'pointId': pointId,
    };
  }
}
