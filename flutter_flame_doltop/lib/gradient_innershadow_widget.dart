// import 'dart:ui';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';

// /// SVG나 Image 위젯에 그라디언트와 inner‐shadow 를 함께 씌워주는 래퍼 위젯.
// ///
// /// MoodDol의 돌탑과 같은 SVG 위젯에 그라디언트와 inner‐shadow 효과를 동시에 적용할 수 있습니다.
// ///
// /// - [blur]: 내부 그림자에 적용할 블러 강도 (기본 8.0)
// /// - [shadowColor]: 그림자 색상 (기본 흰색 55% 투명도)
// /// - [offset]: 그림자 오프셋 (기본 Offset.zero) — 현재는 사용되지 않지만 향후 그림자 방향 지정에 사용 가능
// /// - [gradient]: null 이면 그라디언트 없이, non‐null 이면 먼저 그라디언트를 srcIn 모드로 적용
// /// - [imageChild]: SvgPicture.asset 이나 Image.asset 등, 실제 렌더링할 위젯
// class GradientInnerShadowImage extends StatelessWidget {
//   final double blur;
//   final Color shadowColor;
//   final Offset offset;
//   final Gradient? gradient;
//   final Widget imageChild;

//   const GradientInnerShadowImage({
//     super.key,
//     this.blur = 8.0,
//     this.shadowColor = const Color(0x8CFFFFFF), // white.withOpacity(0.55)
//     this.offset = Offset.zero,
//     this.gradient,
//     required this.imageChild,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       // 두 레이어 모두 같은 크기를 유지하도록MaxSize를 구해둡니다.
//       final w = constraints.maxWidth;
//       final h = constraints.maxHeight;

//       return Stack(
//         alignment: Alignment.center,
//         children: [
//           // 1) Gradient 마스크 또는 원본 이미지를 먼저 그립니다.
//           if (gradient != null)
//             ShaderMask(
//               shaderCallback: (bounds) => gradient!.createShader(bounds),
//               blendMode: BlendMode.srcIn,
//               child: SizedBox(
//                 width: w,
//                 height: h,
//                 child: imageChild,
//               ),
//             )
//           else
//             SizedBox(
//               width: w,
//               height: h,
//               child: imageChild,
//             ),

//           // 2) 같은 크기로 inner‐shadow 레이어를 덮어씌웁니다.
//           InnerShadowImage(
//             blur: blur,
//             shadowColor: shadowColor,
//             offset: offset,
//             child: SizedBox(
//               width: w,
//               height: h,
//               child: imageChild,
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

// /// 실제로 inner‐shadow 효과를 구현하는 RenderObjectWidget.
// /// child 의 투명 영역을 활용해 테두리만 blur + color 로 처리합니다.

// /// Gradient와 Inner-Shadow를 동시에 적용하는 RenderObjectWidget
// class InnerShadowImage extends SingleChildRenderObjectWidget {
//   /// 블러 강도
//   final double blur;

//   /// 그림자 색상
//   final Color shadowColor;

//   /// 그림자 오프셋
//   final Offset offset;

//   const InnerShadowImage({
//     super.key,
//     required this.blur,
//     required this.shadowColor,
//     required this.offset,
//     super.child,
//   });

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return _RenderInnerShadowImage(
//       blur,
//       shadowColor,
//       offset,
//     );
//   }

//   @override
//   void updateRenderObject(
//       BuildContext context, covariant _RenderInnerShadowImage renderObject) {
//     renderObject
//       ..blur = blur
//       ..shadowColor = shadowColor
//       ..offset = offset;
//   }
// }

// class _RenderInnerShadowImage extends RenderProxyBox {
//   _RenderInnerShadowImage(
//     this.blur,
//     this.shadowColor,
//     this.offset,
//   );

//   double blur;
//   Color shadowColor;
//   Offset offset;

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     if (child == null) return;
//     final canvas = context.canvas;
//     final Rect bounds = offset & size;

//     // 1) 레이어 하나만 만들고, 여기에 gradient → child → inner shadow 순서로 그린다
//     canvas.saveLayer(bounds, Paint());

//     context.paintChild(child!, offset);

//     // // 1b) inner shadow (blur + color)
//     final shadowPaint = Paint()
//       ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
//       ..colorFilter = ColorFilter.mode(shadowColor, BlendMode.srcOut)
//       ..blendMode = BlendMode.srcIn;
//     canvas.saveLayer(bounds, shadowPaint);
//     context.paintChild(child!, offset);
//   }
// }
//        GradientInnerShadowImage(
//                           gradient: gradient,
//                           blur: 8.0,
//                           shadowColor: Colors.white.withValues(alpha: 0.55),
//                           offset: Offset.zero,
//                           imageChild: SvgPicture.asset(
//                             dolSvgPath,
//                             height: h,
//                             fit: BoxFit.fitHeight,
//                           ),
//                         ),
