import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/marker.dart';
import 'package:magiq/utils/http/auth.dart';

class MarkerService {
  // Fetch all markers
  static Future<List<Marker>> get() async {
    try {
      final response = await Dio().get(
        '${AuthService.baseUrl}/markers',
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
            (it) => Marker.fromJson(it),
          )
          .toList();
    } catch (e) {
      log(e.toString());
    }

    return [];
  }
}
