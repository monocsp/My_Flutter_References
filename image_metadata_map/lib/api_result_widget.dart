import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// ApiResultWidget: Dio로 API 호출하는 예시 위젯
class ApiResultWidget extends StatelessWidget {
  final List<String> params;
  const ApiResultWidget({Key? key, required this.params}) : super(key: key);

  Future<dynamic> fetchData(List<String> params) async {
    final dio = Dio();
    final response = await dio.post(
      'https://dev.dolomood-api.com/gpt/photo/tag',
      data: {'message': params.toString()},
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    log('param : $params');
    return FutureBuilder(
      future: fetchData(params),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return Column(
            children: [
              Text('message: ${params.toString()}'),
              Text('Result: ${snapshot.data.toString()}'),
            ],
          );
        } else {
          return const Center(child: Text('No Data'));
        }
      },
    );
  }
}
