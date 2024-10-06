import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/user.dart';

class AuthService {
  final Dio _dio = Dio();

  static const baseUrl = 'https://api.magiq.earth';

  static String token = '';

  Future<int?> auth(User user) async {
    try {
      return await _attemptLogin(user);
    } on DioException catch (e) {
      if (_isUnauthorized(e)) {
        log('Unauthorized: Trying to register the user');
        return await _registerAndLogin(user);
      } else {
        log('Login Error: ${e.message}');
      }
    }

    return null;
  }

  Future<int?> _attemptLogin(User user) async {
    final response = await _dio.post(
      '$baseUrl/users/login',
      data: user.toAuthJson(),
    );

    if (response.statusCode == 200) {
      token = response.data['token'];
      return response.data['userId'] as int;
    }
    return null;
  }

  Future<int?> _registerAndLogin(User user) async {
    try {
      final response = await _dio.post(
        '$baseUrl/users',
        data: user.toRegisterJson(),
      );

      if (response.statusCode == 201) {
        log('Registration successful: Attempting to log in again');
        return await _attemptLogin(user);
      }
    } on DioException catch (e) {
      log('Registration Error: ${e.message}');
    }

    return null;
  }

  bool _isUnauthorized(DioException error) {
    return error.response?.statusCode == 401;
  }
}
