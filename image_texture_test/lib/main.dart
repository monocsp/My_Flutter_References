import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_texture_test/gradient_innershadow_widget.dart';
import 'package:image_texture_test/noise_mask_img.dart';
import 'package:image_texture_test/stacking_containers_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<bool> startNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar를 body 위로 겹치도록 설정

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("기존"),
          SizedBox(
            height: 300,
            width: 300,
            child: GradientInnerShadowImage(
              shadowColor: Colors.black,
              blur: 300 * 0.05,

              // filterBoxX: -0.5,
              // filterBoxY: -0.5,
              // filterBoxHeight: 2.0,
              // filterBoxWidth: 2.0,
              // spread: 0,
              // shadowColor: Colors.white.withValues(alpha: 0.7),
              offset: Offset.zero,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFCCF0FF),
                  Color(0xFF6ECFFF),
                ],
                stops: const [0.0, 1.0],
              ),

              imageChild: SvgPicture.asset(
                'assets/download-1752655613562.svg',
                colorFilter: ColorFilter.mode(
                  Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          // SizedBox(
          //   height: 300,
          //   child: TestGradientTestInnerShadowImage(
          //     shadowColor: Colors.white,
          //     blurRadius: 24.0,
          //     // filterBoxX: -0.5,
          //     // filterBoxY: -0.5,
          //     // filterBoxHeight: 2.0,
          //     // filterBoxWidth: 2.0,
          //     // spread: 0,
          //     // shadowColor: Colors.white.withValues(alpha: 0.7),
          //     offset: Offset.zero,
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Color(0xFFCCF0FF),
          //         Color(0xFF6ECFFF),
          //       ],
          //       stops: const [0.0, 1.0],
          //     ),

          //     imageChild: SvgPicture.asset(
          //       'assets/download-1752655613562.svg',
          //       fit: BoxFit.fitHeight,
          //       colorFilter: ColorFilter.mode(
          //         Color(0xFFFFFFFF),
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //   ),
          // ),

          SizedBox(
            height: 300,
            width: 300,
            child: InnerShadow(
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 300 * 0.05,
                  offset: Offset(0, 0),
                )
              ],
              child: SvgPicture.asset(
                'assets/download-1752655613562.svg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          // Positioned.fill(
          //   child: DecoratedBox(
          //       decoration: BoxDecoration(
          //           gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     stops: const [0.0, 1.0],
          //     colors: [
          //       Color(0xFFFFEAEA), // top 위치 (0%)
          //       Color(0xFFFFFFFF), // bottom 위치 (100%)
          //     ],
          //   ))),
          // ),
          // // Positioned(
          // //   width: 1195,
          // //   height: 1174,
          // //   child: DecoratedBox(
          // //       decoration: BoxDecoration(
          // //           gradient: RadialGradient(
          // //     center: Alignment.center,
          // //     stops: const [0.0, 0.55, 1.0],
          // //     colors: [
          // //       Color(0xFFFF5B5B).withValues(alpha: 0.3), // 0%
          // //       Color(0xFFFFCDCD).withValues(alpha: 0.3), // 55%
          // //       Color(0xFFFFFFFF).withValues(alpha: 0.0), // 100%, 투명
          // //     ],
          // //   ))),
          // // ),

          // Positioned(
          //   // 화면 위로 33dp 올라가게
          //   top: (-33),

          //   left: ((375 - 777) / 2).w,
          //   child: Container(
          //     width: 777.w,
          //     height: 974.h,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(
          //         // 정확한 가로·세로 비율의 타원
          //         Radius.elliptical(777.w, 974.h),
          //       ),
          //       gradient: RadialGradient(
          //         // 그라디언트 중심을 위쪽 중앙으로
          //         center: Alignment.center,
          //         stops: const [0.0, 1.0],
          //         colors: [
          //           Color(0xFFFFE3E3), // 0%
          //           Color(0xFFFFFFFF).withValues(alpha: 0.0), // 100%, 투명
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // StackingDemoSteps10(
          //   startTrigger: startNotifier,
          // ),
        ],
      ),
    );
  }
}

class DolWidget extends StatelessWidget {
  const DolWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.62, 1.0],
              colors: const [
                Color(0xFF9CCEF3), // top 위치 (0%)
                Color(0xFF9CCEF3), // 중간 위치 (62%)
                Color(0xFF40A2EA), // bottom 위치 (100%)
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Image.asset('assets/dol_color_white.png'),
        ),
        BlendMask(
          opacity: 0.7,
          blendMode: BlendMode.softLight,
          child: Image.asset('assets/texture.png'),
        ),
      ],
    );
  }
}

class WhiteNoisePainter extends CustomPainter {
  final int width;
  final int height;
  final Random rnd;

  WhiteNoisePainter({
    required this.width,
    required this.height,
    required this.rnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // 실제 그려질 수 있는 Canvas의 크기와
    // 우리가 그리려는 노이즈의 해상도(width, height)가 다를 수 있으므로
    // 일단은 'pixel 1개 = 1x1 사이즈'라고 가정하고 직접 반복문
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // 노이즈 생성: 50% 확률로 흰색, 50% 확률로 검정
        bool isWhite = rnd.nextDouble() > 0.5;
        paint.color = isWhite ? Colors.white : Colors.black;

        // (x, y) 위치에 1x1 크기로 칠하기
        canvas.drawRect(
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
