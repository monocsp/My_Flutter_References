import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetXPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GetX Page"),

        ///이전화면으로 돌아가는 버튼
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: GestureDetector(
          onTap: () async {
            log('ModalRoute.of(context).settings.name : ${ModalRoute.of(context)!.settings.name}');

            ///서버와 어떠한 통신이 일어나면
            // await Future.delayed(const Duration(seconds: 3));

            ///현재 buildContext가 mount되어있는 상태가 아니라면 종료

            ///이전페이지로 이동한다.
            // Navigator.of(context).pop();
          },
          child: const Center(child: Text("Press HERE!!!!"))),
    );
  }
}
