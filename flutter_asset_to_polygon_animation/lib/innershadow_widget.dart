import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Gradient와 Inner-Shadow를 동시에 적용하는 RenderObjectWidget
class InnerShadowImage extends SingleChildRenderObjectWidget {
  /// 블러 강도
  final double blur;

  /// 그림자 색상
  final Color shadowColor;

  /// 그림자 오프셋
  final Offset offset;

  const InnerShadowImage({
    super.key,
    required this.blur,
    required this.shadowColor,
    required this.offset,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInnerShadowImage(
      blur,
      shadowColor,
      offset,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderInnerShadowImage renderObject) {
    renderObject
      ..blur = blur
      ..shadowColor = shadowColor
      ..offset = offset;
  }
}

class _RenderInnerShadowImage extends RenderProxyBox {
  _RenderInnerShadowImage(
    this.blur,
    this.shadowColor,
    this.offset,
  );

  double blur;
  Color shadowColor;
  Offset offset;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    final canvas = context.canvas;
    final Rect bounds = offset & size;

    // 1) 레이어 하나만 만들고, 여기에 gradient → child → inner shadow 순서로 그린다
    canvas.saveLayer(bounds, Paint());

    context.paintChild(child!, offset);

    // // 1b) inner shadow (blur + color)
    final shadowPaint = Paint()
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(shadowColor, BlendMode.srcOut)
      ..blendMode = BlendMode.srcIn;
    canvas.saveLayer(bounds, shadowPaint);
    context.paintChild(child!, offset);
  }
}
