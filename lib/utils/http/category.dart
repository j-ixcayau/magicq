import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/category.dart';
import 'package:magiq/model/user.dart';
import 'package:magiq/utils/http/auth.dart';

class CategoryService {
  final Dio _dio = Dio();

  Future<List<Category>> auth(User user) async {
    try {
      final response = await _dio.get(
        'http://localhost:3000/categories',
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
          .map((it) => Category.fromJson(it))
          .toList();
    } catch (e) {
      log(e.toString());
    }

    return [];
  }
}
