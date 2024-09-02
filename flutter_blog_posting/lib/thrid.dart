import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Third Page"),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await Future.delayed(const Duration(seconds: 3));

            Navigator.of(context).pop();
          },
          child: Container(
            child: Text("HELLO"),
          ),
        ),
      ),
    );
  }
}
