import 'dart:developer';

import 'package:custom_bottomnavigationbar/CustomNavigationbar/rx_index_controller.dart';
import 'package:custom_bottomnavigationbar/home1.dart';
import 'package:custom_bottomnavigationbar/home2.dart';
import 'package:custom_bottomnavigationbar/home3.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late RxIndexController rxIndexController;

  @override
  void initState() {
    rxIndexController = RxIndexController(addListener: () {
      log("Add Listener");
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //index화면 위젯
  final bodyList = [
    const Home1(),
    const Home2(),
    const Home3(),
  ];

  //index 아이콘 및 타이틀
  final bottomDesign = [
    BottomNavigationData(
        iconData: Icons.home,
        defaultColor: Colors.grey,
        selectedColor: Colors.red,
        title: "HOME"),
    BottomNavigationData(
        iconData: Icons.business,
        defaultColor: Colors.grey,
        selectedColor: Colors.orange,
        title: "BUSINESS"),
    BottomNavigationData(
        iconData: Icons.school,
        defaultColor: Colors.grey,
        selectedColor: Colors.blue,
        title: "SCHOOL")
  ];

  //BottomNavigationBar의 index 클릭 시 호출되는 함수
  indexChanged(int index) => rxIndexController.jumpToIndex(index);

  @override
  Widget build(BuildContext context) {
    //StreamBuilder의 type이 Object이므로,
    //dynamic으로 변경하여 rxIndexController에 맞게 type을 dynamic으로바꾼다.
    return StreamBuilder<dynamic>(
      //rxcontroller stream선언
      stream: rxIndexController.stream,

      //streambuilder를 첫 로드할때 사용되는 초기값.
      initialData: rxIndexController.bottomIndex,
      builder: (context, snapshot) {
        //snapshot.data는 subject의 현재 값을 나타낸다. 따라서 currentIndex가 된다.
        int currentIndex = snapshot.data;
        return Scaffold(
          //각각에 해당되는 Widget
          body: bodyList[currentIndex],
          bottomNavigationBar: SizedBox(

              //BottomNavigationBar의 높이
              height: 50,

              //핸드폰 너비
              width: MediaQuery.of(context).size.width,
              child: Container(
                //가운데 정렬
                alignment: Alignment.center,

                //scaffold의 body부분과 구분되는 선
                //const로 rebuild되지않게하여 효율을 높인다.
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xffdddddd)))),

                child: Row(
                  //Row의 Children에 있는 Widget들 간의 간격이 일정하게 배치한다.
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...bottomDesign.asMap().entries.map((e) {
                      int index = e.key;
                      BottomNavigationData data = e.value;
                      return GestureDetector(
                        onTap: () => indexChanged(index),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                data.iconData,

                                //만약 현재index와 wiget의 index와 같다면
                                color: currentIndex == index
                                    ? data.selectedColor
                                    : data.defaultColor,
                              ),
                              Text(
                                data.title,
                                style: TextStyle(
                                    color: currentIndex == index
                                        ? data.selectedColor
                                        : data.defaultColor,
                                    fontSize: 10),
                              )
                            ]),
                      );
                    }).toList()
                  ],
                ),
              )),
        );
      },
    );
  }
}

class BottomNavigationData {
  final IconData iconData;
  final String title;
  final Color selectedColor;
  final Color defaultColor;

  BottomNavigationData(
      {required this.iconData,
      required this.defaultColor,
      required this.selectedColor,
      required this.title});
}
