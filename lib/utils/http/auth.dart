import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/user.dart';

class AuthService {
  final Dio _dio = Dio();

  static const baseUrl = 'http://localhost:3000';

  static String token = '';

  Future<bool> auth(User user) async {
    try {
      final loginRespone = await _dio.post(
        '$baseUrl/users/login',
        data: user.toAuthJson(),
      );

      if (loginRespone.statusCode == 200) {
        token = loginRespone.data;
        return true;
      }

      final registerResponse = await _dio.post(
        '$baseUrl/users/login',
        data: user.toRegisterJson(),
      );

      if (registerResponse.statusCode == 200) {
        final loginRespone = await _dio.post(
          '$baseUrl/users/login',
          data: user.toAuthJson(),
        );

        if (loginRespone.statusCode == 200) {
          token = loginRespone.data;
          return true;
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return false;
  }
}
