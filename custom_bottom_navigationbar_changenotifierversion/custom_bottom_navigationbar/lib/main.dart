import 'package:custom_bottom_navigationbar/body_main.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  final  mainPage = <Widget>[
    const Page1(),
    const Page2(),
    const Page3(),

  ];


  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(title: const Text("Bottom NavigationBar"),),
      body: ,
    );
  }
}
