// import 'dart:ui';
// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'package:flame_svg/svg.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class GradientInnerShadowImageComponent extends PositionComponent
//     with HasGameReference<FlameGame> {
//   final double blur;
//   final Color shadowColor;
//   final Offset innerOffset;
//   final Gradient? gradient;
//   final String svgAssetPath;

//   late final Svg svg;

//   GradientInnerShadowImageComponent({
//     required this.blur,
//     required this.shadowColor,
//     required this.innerOffset,
//     this.gradient,
//     required this.svgAssetPath,
//     required Vector2 position,
//     required Vector2 size,
//     Anchor anchor = Anchor.center,
//     int priority = 0,
//   }) : super(
//             position: position, size: size, anchor: anchor, priority: priority);

//   @override
//   Future<void> onLoad() async {
//     // SVG 파일 로드
//     svg = await gameRef.loadSvg(svgAssetPath);
//     await super.onLoad();
//   }

//   @override
//   void render(Canvas canvas) {
//     final rect = toRect();
//     canvas.save();

//     // 1) Gradient 마스크 (ShaderMask 효과)
//     if (gradient != null) {
//       final paint = Paint()..shader = gradient!.createShader(rect);
//       // srcIn 으로 마스크
//       paint.blendMode = BlendMode.srcIn;
//       canvas.saveLayer(rect, paint);
//       svg.draw(canvas, rect);
//       canvas.restore();
//     } else {
//       svg.draw(canvas, rect);
//     }

//     // 2) Inner Shadow 레이어
//     final shadowPaint = Paint()
//       // blur + 투명도 조절
//       ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
//       ..colorFilter = ColorFilter.mode(shadowColor, BlendMode.srcOut)
//       ..blendMode = BlendMode.srcIn;
//     canvas.saveLayer(rect.shift(innerOffset), shadowPaint);
//     svg.draw(canvas, rect);
//     canvas.restore();

//     canvas.restore();
//   }
// }
