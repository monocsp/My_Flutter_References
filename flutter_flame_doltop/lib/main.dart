import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_doltop/components/flame_game.dart';
import 'package:flutter_flame_doltop/model/background_image_info.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

void main() {
  // final game = MyPhysicsGame();
  runApp(GameWidget(game: MyPhysicsGame()));
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Future<List<BgImageInfo>> _bgImageInfosFuture;

//   @override
//   void initState() {
//     super.initState();
//     // 빌드 전에 Future 준비 (context 필요없으면 여기서 바로 호출 가능)
//     _bgImageInfosFuture = _createBgImageInfoList();
//   }

//   Future<List<BgImageInfo>> _createBgImageInfoList() async {
//     // 화면 가로 길이는 build 시점에만 알 수 있으므로, 여기서는 placeholder로 0
//     // 실제로는 LayoutBuilder 안의 constraints.maxWidth 를 파라미터로 넘기세요.
//     final double screenWidth = 0;

//     final paths = List.generate(7, (i) => 'assets/images/home_bg_$i.png');
//     final List<BgImageInfo> infos = [];

//     for (var i = 0; i < paths.length; i++) {
//       final ui.Image img = await _loadUiImage(paths[i]);
//       // 원본 너비·높이
//       final double origW = img.width.toDouble();
//       final double origH = img.height.toDouble();
//       // 화면 너비에 맞춘 출력 높이
//       final double displayH = screenWidth * origH / origW;

//       infos.add(BgImageInfo(
//         isBased: i == 0, // home_bg_0만 based
//         index: i, // 순환 인덱스
//         assetPath: paths[i],
//         originalWidth: screenWidth, // 화면 너비로 고정
//         originalHeight: displayH, // 비율 유지한 높이
//       ));
//     }
//     return infos;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Flutter Flame Test')),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final screenW = constraints.maxWidth;
//           return FutureBuilder<List<BgImageInfo>>(
//             future: _bgImageInfosFuture,
//             builder: (context, snap) {
//               if (!snap.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               // screenWidth 값을 넘겨서 다시 계산해도 되고,
//               // init 때 바로 전달해두면 이중 FutureBuilder 없이 사용 가능합니다.
//               final infos = snap.data!;
//               return ListView(
//                 children: infos.map((info) {
//                   return Image.asset(
//                     info.assetPath,
//                     width: info.originalWidth,
//                     height: info.originalHeight,
//                     fit: BoxFit.fill,
//                   );
//                 }).toList(),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   /// 에셋 이미지의 실제 크기(ui.Image)를 비동기로 로드합니다.
//   Future<ui.Image> _loadUiImage(String assetPath) async {
//     // 1) 바이트 로드
//     final ByteData data = await rootBundle.load(assetPath);
//     // 2) 디코딩
//     final ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//     );
//     final ui.FrameInfo fi = await codec.getNextFrame();
//     return fi.image;
//   }
// }
