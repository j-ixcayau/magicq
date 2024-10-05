import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/point.dart';
import 'package:magiq/utils/http/auth.dart';

class PointService {
  static Future<List<Point>> get() async {
    try {
      final response = await Dio().get(
        '${AuthService.baseUrl}/points',
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
            (it) => Point.fromJson(it),
          )
          .toList();
    } catch (e) {
      log(e.toString());
    }

    return [];
  }
}
