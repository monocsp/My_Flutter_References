import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("FutureBuilder"),
        ),
        body: Center(
            child: FutureBuilder(
          initialData: "INITIALDATA",
          //future부분에는 서버와 통신, 비동기함수를 넣으면 된다.
          future: serverConnectionDelay(),
          builder: (context, snapshot) {
            //server에서 데이터를 가져오는 것을 기다리는동안 다른화면을 보여줌
            if (snapshot.connectionState == ConnectionState.waiting) {
              log("snapshot Data : ${snapshot.data}");
              return const CupertinoActivityIndicator();
            }
            //가져온 데이터가 오류가 났을 경우.

            if (snapshot.hasError) {
              log("snapshot Data : ${snapshot.data}");
              return Column(
                children: const [Icon(Icons.error), Text("데이터 오류가 발생했습니다.")],
              );
            }
            //가져온 데이터가 없는 경우.
            if (!snapshot.hasData) {
              log("snapshot Data : ${snapshot.data}");
              return Column(
                children: const [Icon(Icons.cancel), Text("데이터가 존재하지 않습니다.")],
              );
            }
            //정상적으로 데이터를 가져온 경우.
            //가져온 데이터를 사용하는 경우에는 snapshot.data 를 사용하면 된다.
            log("snapshot Data : ${snapshot.data}");

            return const Text("데이터 가져오는데 성공했습니다.");
          },
        )));
  }

  Future serverConnectionDelay() async {
    await Future.delayed(const Duration(seconds: 1));
    // return Future.error("121");
    // return true;
  }
}
