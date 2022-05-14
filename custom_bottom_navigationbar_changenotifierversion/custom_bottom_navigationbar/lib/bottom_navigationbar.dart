import 'package:custom_bottom_navigationbar/bottom_changenotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomIndexChangeNotifier(),
      child: const Test(),
    );
  }
}

class NavigationBar extends StatelessWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomIndexChangeNotifier>(
      builder: (context, value, child) {},
    );
  }
}

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => CartModel(),
//       child: const MyApp(),
//     ),
//   );
// }
