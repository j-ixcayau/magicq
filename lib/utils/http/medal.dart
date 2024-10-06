import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:magiq/model/medal.dart';
import 'package:magiq/utils/http/auth.dart';

class MedalService {
  static Future<(int, List<Medal>)> get(int userId) async {
    try {
      final response = await Dio().get(
        '${AuthService.baseUrl}/userPoints/user/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AuthService.token}',
          },
        ),
      );

      if (response.statusCode != 200) {
        return (0, <Medal>[]);
      }

      int totalPoints = 0;
      final medals = (response.data as List).map(
        (it) {
          totalPoints += (it['points'] as int);
          return Medal.fromJson(it['medal']);
        },
      ).toList();

      return (totalPoints, medals);
    } catch (e) {
      log(e.toString());
    }

    return (0, <Medal>[]);
  }
}
