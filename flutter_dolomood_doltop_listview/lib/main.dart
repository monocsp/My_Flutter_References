import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dolomood_doltop_listview/scroll_list_dol.dart';

/// ListView에서 단일 폴리곤 이미지를 위에서 떨어뜨리는 위젯입니다.
class DropOneListView extends StatefulWidget {
  const DropOneListView({Key? key}) : super(key: key);

  @override
  _DropOneListViewState createState() => _DropOneListViewState();
}

class _DropOneListViewState extends State<DropOneListView> {
  /// 모핑할 SVG/이미지 에셋 경로 목록
  final List<String> polygonAssets = const [
    'assets/dol/img_dol_1_13.png',
    'assets/dol/img_dol_1_14.png',
    'assets/dol/img_dol_1_15.png',
    'assets/dol/img_dol_1_16.png',
    'assets/dol/img_dol_1_17.png',
    'assets/dol/img_dol_1_18.png',
    'assets/dol/img_dol_1_19.png',
    'assets/dol/img_dol_1_20.png',
    'assets/dol/img_dol_1_21.png',
    'assets/dol/img_dol_1_22.png',
    'assets/dol/img_dol_1_23.png',
    'assets/dol/img_dol_1_24.png',
    'assets/dol/img_dol_1_38.png',
  ];

  /// 선택된 에셋 경로
  late final String assetPath;

  /// 랜덤으로 결정된 폴리곤 이미지 높이
  late final double shapeHeight;

  @override
  void initState() {
    super.initState();
    // 랜덤 에셋과 높이를 초기화
    final random = Random();
    assetPath = polygonAssets[random.nextInt(polygonAssets.length)];
    shapeHeight = (80 + random.nextInt(71)).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    // 디바이스 화면 높이
    final deviceHeight = MediaQuery.of(context).size.height;

    return ListView(
      reverse: true,
      children: [
        // A와 C를 동시에 애니메이션하여 B가 위에서 떨어지도록 연출
        TweenAnimationBuilder<double>(
          tween: Tween(begin: deviceHeight, end: 0),
          duration: const Duration(seconds: 2),
          curve: const CustomBounce(),
          builder: (context, aHeight, child) {
            // C 높이 = deviceHeight - A 높이
            final cHeight = deviceHeight - aHeight;

            return SizedBox(
              // 전체 높이 = deviceHeight + 이미지 높이
              height: deviceHeight + shapeHeight,
              width: double.infinity,
              child: Column(
                children: [
                  /// C: A가 줄어들면 이 Spacer가 커집니다.
                  SizedBox(height: cHeight),

                  /// B: 랜덤 폴리곤 이미지
                  SizedBox(
                    height: shapeHeight,
                    width: double.infinity,
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                  /// A: deviceHeight에서 0으로 줄어드는 투명 박스
                  SizedBox(height: aHeight),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// void main() {
//   runApp(
//     const MaterialApp(
//       home: Scaffold(
//         body: DropOneListView(),
//       ),
//     ),
//   );
// }

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: DolScrollPage(),
      ),
    ),
  );
}

class CustomBounce extends Curve {
  const CustomBounce();

  @override
  double transform(double t) {
    print("t : $t");
    // 1) 첫 번째 바운스 (t < 1/2.75): 순수 7.5625*t^2
    if (t < 1 / 2.75) {
      return 7.5625 * t * t;
    }
    // 2) 두 번째 바운스 (1/2.75 <= t < 2/2.75): 오프셋 +0.75
    else if (t < 2 / 2.75) {
      t -= 1.5 / 2.75;
      return 7.5625 * t * t + 0.75;
    }
    // 3) 마지막 바운스 (그 외): 오프셋 +0.9
    else {
      t -= 2.25 / 2.75;
      return 7.5625 * t * t + 0.9;
    }
  }
}
