import 'package:intl/intl.dart';

class Comment {
  final int id;
  final String content;
  final int pointId;
  final int userId;
  final String userName;
  final DateTime? created;

  Comment({
    required this.id,
    required this.content,
    required this.userId,
    required this.pointId,
    required this.userName,
    required this.created,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final created = json['created_at'] as String;

    return Comment(
        id: json['id'] as int,
        content: json['content'] as String,
        pointId: json['point']['id'] as int,
        userId: json['user']['id'] as int,
        userName: json['user']['username'] as String,
        created: DateTime.parse(created));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'pointId': pointId,
    };
  }

  String get formattedDate => (created == null)
      ? ''
      : DateFormat('MMMM d, y h:mm a').format(created!.toLocal());
}
