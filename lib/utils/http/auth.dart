import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/user.dart';

class AuthService {
  final Dio _dio = Dio();

  static const baseUrl = 'http://35.245.198.235:3000';

  static String token = '';

  Future<bool> auth(User user) async {
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

    return false;
  }

  Future<bool> _attemptLogin(User user) async {
    final loginResponse = await _dio.post(
      '$baseUrl/users/login',
      data: user.toAuthJson(),
    );

    if (loginResponse.statusCode == 200) {
      token = loginResponse.data['token'];
      return true;
    }
    return false;
  }

  Future<bool> _registerAndLogin(User user) async {
    try {
      final registerResponse = await _dio.post(
        '$baseUrl/users',
        data: user.toRegisterJson(),
      );

      if (registerResponse.statusCode == 201) {
        log('Registration successful: Attempting to log in again');
        return await _attemptLogin(user);
      }
    } on DioException catch (e) {
      log('Registration Error: ${e.message}');
    }

    return false;
  }

  bool _isUnauthorized(DioException error) {
    return error.response?.statusCode == 401;
  }
}
