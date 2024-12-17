import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddressService {
  static const String _apiUrl =
      "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc";
  static const String _orders = "legalcode";
  static const String _output = "json";

  static Future<String?> getAddress(String position) async {
    final Dio dio = Dio();

    String apiKeyId = dotenv.env['NAVERCLIENTID'] ?? ''; // 네이버 API 키 ID

    String apiKeySecret =
        dotenv.env['NAVERCLIENTSECRET'] ?? ''; // 네이버 API 시크릿 키

    try {
      final response = await dio.get(
        _apiUrl,
        queryParameters: {
          "coords": position,
          "orders": _orders,
          "output": _output,
        },
        options: Options(
          headers: {
            "X-NCP-APIGW-API-KEY-ID": apiKeyId,
            "X-NCP-APIGW-API-KEY": apiKeySecret,
          },
        ),
      );

      if (response.statusCode == 200) {
        // JSON 응답 파싱
        final Map<String, dynamic> data = json.decode(response.toString());
        debugPrint("Response Data: $data");

        return extractAddress(data);
      } else {
        // 요청 실패 처리
        debugPrint("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error during API call: $e");
    }
    return null;
  }

  static String extractAddress(Map<String, dynamic> responseData) {
    try {
      // 'results' 키에서 첫 번째 항목 추출
      final results = responseData['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final region = results[0]['region'] as Map<String, dynamic>;

        // 지역 정보 추출
        final area1 = region['area1']['name']; // 서울특별시
        final area2 = region['area2']['name']; // 서초구
        final area3 = region['area3']['name']; // 서초동

        // 완성된 주소 반환
        return "$area1 $area2 $area3";
      } else {
        return "No results found";
      }
    } catch (e) {
      // 예외 처리
      return "Error parsing address: $e";
    }
  }
}
