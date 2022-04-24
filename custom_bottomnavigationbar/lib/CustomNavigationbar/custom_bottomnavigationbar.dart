import 'dart:developer';

import 'package:custom_bottomnavigationbar/CustomNavigationbar/rx_index_controller.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Scaffold scaffold;

  const CustomBottomNavigationBar({Key? key, required this.scaffold})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late RxIndexController rxIndexController;
  late Scaffold scaffold;

  @override
  void initState() {
    rxIndexController = RxIndexController(
      addListener: () {
        log("ADD Listener");
      },
    );
    scaffold = widget.scaffold;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(builder: ((context, snapshot) {
      return scaffold;
    }));
  }
}

  //  bottomNavigationBar: Container(
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                         border: Border(
  //                             top: BorderSide(color: Color(0xffdddddd)))),
  //                     height: 50.h,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: customBottomNavigator(index),
  //                     ),