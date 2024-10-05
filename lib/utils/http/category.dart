import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/category.dart';
import 'package:magiq/utils/http/auth.dart';

class CategoryService {
  static Future<List<Category>> get() async {
    try {
      final response = await Dio().get(
        '${AuthService.baseUrl}/categories',
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
