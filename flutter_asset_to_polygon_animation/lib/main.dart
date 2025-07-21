import 'package:flutter/material.dart';
import 'dart:math' show min;

import 'package:flutter_asset_to_polygon_animation/polygon/contour_extractor.dart';
import 'package:flutter_asset_to_polygon_animation/polygon/morph_sequence.dart';
import 'package:flutter_asset_to_polygon_animation/polygon/shape_contour_provider.dart';

void main() {
  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // // 모핑할 SVG/이미지 에셋 경로 목록
  // final List<String> polygonAssets = const [
  //   'assets/doltop_A.svg',
  //   'assets/doltop_B.svg',
  //   'assets/doltop_C.svg',
  //   'assets/doltop_D.svg',
  //   'assets/doltop_E.svg',
  // ];

  // 모핑할 SVG/이미지 에셋 경로 목록
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
              child: DecoratedBox(
                  decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 1.0],
              colors: [Color(0xFFFFFFFF), Color(0xFFD4FEFF), Color(0xFF85BEFF)],
            ),
          ))),

          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 화면에서 정사각형으로 사용할 최대 크기 계산
                final side = min(constraints.maxWidth, constraints.maxHeight);
                final targetSize = Size(side, side);

                // 1) ShapeContourProvider로 ContourData 리스트 로드
                return FutureBuilder<List<ContourData>>(
                  future: ShapeContourProvider(context)
                      .loadContours(polygonAssets, targetSize),
                  builder: (ctx, snap) {
                    if (snap.hasError) {
                      return Center(child: Text('오류: ${snap.error}'));
                    }
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final contours = snap.data!;

                    // 2) MorphingShapeView에 contours 넘겨서 모핑 애니메이션 실행
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(100.0),
                        child: MorphingShapeView(
                          contours: contours,
                          sampleCount: 500,
                          morphDuration: const Duration(seconds: 2),
                          delayDuration: const Duration(seconds: 1),
                          fillGradient: RadialGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withValues(alpha: 0.3)
                            ],
                          ),
                          // fillColor: Colors.red,
                          strokeColor: Colors.transparent,
                          strokeWidth: 0.0,
                          curve: Curves.easeInOutCirc,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
