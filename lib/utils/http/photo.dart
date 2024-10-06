import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/photo.dart';
import 'package:magiq/utils/http/auth.dart';

class PhotoService {
  static Future<bool> create(Photo photo) async {
    try {
      final response = await Dio().post(
        '${AuthService.baseUrl}/photos',
        data: photo.toJson(),
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
