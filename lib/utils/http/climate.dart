import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClimateService {
  static Future<String?> get(LatLng location, String userName) async {
    try {
      final response = await Dio().post(
        'https://n8n.magiq.earth/webhook/openai-indicadoresclimaticos',
        data: {
          'longitude': location.longitude,
          'latitude': location.latitude,
          'name': userName,
        },
        options: Options(
          headers: {
            'Authorization': 'Basic bjhuX2FwaTomNzgzdVJ0Nzk4My4tODM3QA=='
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['content'].toString();
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}
