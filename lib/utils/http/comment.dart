import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/comment.dart';
import 'package:magiq/utils/http/auth.dart';

class CommentService {
  static Future<List<Comment>> get(int pointId) async {
    try {
      final response = await Dio().get(
        '${AuthService.baseUrl}/comments',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AuthService.token}',
          },
        ),
      );

      if (response.statusCode != 200) {
        return [];
      }

      return (response.data as List)
          .map(
            (it) => Comment.fromJson(it),
          )
          .toList();
    } catch (e) {
      log(e.toString());
    }

    return [];
  }

  // Add a new comment
  static Future<bool> add(Comment comment) async {
    try {
      final response = await Dio().post(
        '${AuthService.baseUrl}/comments',
        data: comment.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AuthService.token}',
          },
        ),
      );

      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }

    return false;
  }
}
