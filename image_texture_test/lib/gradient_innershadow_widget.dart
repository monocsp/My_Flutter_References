import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

/// SVG나 Image 위젯에 그라디언트와 inner‐shadow를 동시에 적용합니다.
///
/// 서버에서 전달된 CSS-style 파라미터(filterBoxX/Y, offsetX/Y, blurRadius, spread 등)를 Flutter inner-shadow로 1:1 매핑하여 렌더링합니다.
class TestGradientTestInnerShadowImage extends StatelessWidget {
  /// 내부 그림자의 blur 반경
  final double blurRadius;

  /// 그림자 색상
  final Color shadowColor;

  /// 그림자 투명도
  final double shadowOpacity;

  /// 그림자 오프셋 (x, y)
  final Offset offset;

  /// 경계(bound)를 확장하는 값
  final double spread;

  /// 필터 영역의 x 오프셋 (0.0~1.0)
  final double filterBoxX;

  /// 필터 영역의 y 오프셋 (0.0~1.0)
  final double filterBoxY;

  /// 필터 영역의 너비 (0.0~1.0)
  final double filterBoxWidth;

  /// 필터 영역의 높이 (0.0~1.0)
  final double filterBoxHeight;

  /// inset 여부 (true면 내부 그림자)
  final bool inset;

  /// 그라디언트 (null이면 그라디언트 없이 렌더링)
  final Gradient? gradient;

  /// 실제 렌더링할 SVG나 Image 위젯
  final Widget imageChild;

  const TestGradientTestInnerShadowImage({
    super.key,
    this.blurRadius = 8.0,
    this.shadowColor = const Color(0xFF000000),
    this.shadowOpacity = 1.0,
    this.offset = Offset.zero,
    this.spread = 0.0,
    this.filterBoxX = 0.0,
    this.filterBoxY = 0.0,
    this.filterBoxWidth = 1.0,
    this.filterBoxHeight = 1.0,
    this.inset = true,
    this.gradient,
    required this.imageChild,
  });

  @override
  Widget build(BuildContext context) {
    // 부모 제약에 맞춰 크기를 결정합니다.
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return Stack(
          alignment: Alignment.center,
          children: [
            // 1) gradient를 먼저 적용하거나 원본 이미지를 렌더링
            if (gradient != null)
              ShaderMask(
                shaderCallback: (bounds) => gradient!.createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: SizedBox(width: w, height: h, child: imageChild),
              )
            else
              SizedBox(width: w, height: h, child: imageChild),

            // 2) inner-shadow 레이어를 덮어씌웁니다.
            TestInnerShadowImage(
              blurRadius: blurRadius,
              shadowColor: shadowColor.withOpacity(shadowOpacity),
              offset: offset,
              spread: spread,
              filterBoxX: filterBoxX,
              filterBoxY: filterBoxY,
              filterBoxWidth: filterBoxWidth,
              filterBoxHeight: filterBoxHeight,
              inset: inset,
              child: SizedBox(width: w, height: h, child: imageChild),
            ),
          ],
        );
      },
    );
  }
}

/// child의 투명 영역을 활용해 내부 그림자를 처리하는 RenderObjectWidget입니다.
class TestInnerShadowImage extends SingleChildRenderObjectWidget {
  /// blur 반경 (sigma)
  final double blurRadius;

  /// 그림자 색상
  final Color shadowColor;

  /// 그림자 오프셋
  final Offset offset;

  /// 경계(bound) 확장값
  final double spread;

  /// 필터 영역의 x 오프셋 (0.0~1.0)
  final double filterBoxX;

  /// 필터 영역의 y 오프셋 (0.0~1.0)
  final double filterBoxY;

  /// 필터 영역의 너비 (0.0~1.0)
  final double filterBoxWidth;

  /// 필터 영역의 높이 (0.0~1.0)
  final double filterBoxHeight;

  /// inset 여부
  final bool inset;

  const TestInnerShadowImage({
    super.key,
    required this.blurRadius,
    required this.shadowColor,
    required this.offset,
    required this.spread,
    required this.filterBoxX,
    required this.filterBoxY,
    required this.filterBoxWidth,
    required this.filterBoxHeight,
    this.inset = true,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _TestRenderTestInnerShadowImage(
        blurRadius,
        shadowColor,
        offset,
        spread,
        filterBoxX,
        filterBoxY,
        filterBoxWidth,
        filterBoxHeight,
        inset,
      );

  @override
  void updateRenderObject(BuildContext context,
      covariant _TestRenderTestInnerShadowImage renderObject) {
    renderObject
      ..blurRadius = blurRadius
      ..shadowColor = shadowColor
      ..offset = offset
      ..spread = spread
      ..filterBoxX = filterBoxX
      ..filterBoxY = filterBoxY
      ..filterBoxWidth = filterBoxWidth
      ..filterBoxHeight = filterBoxHeight
      ..inset = inset;
  }
}

class _TestRenderTestInnerShadowImage extends RenderProxyBox {
  double blurRadius;
  Color shadowColor;
  Offset offset;
  double spread;
  double filterBoxX;
  double filterBoxY;
  double filterBoxWidth;
  double filterBoxHeight;
  bool inset;

  _TestRenderTestInnerShadowImage(
    this.blurRadius,
    this.shadowColor,
    this.offset,
    this.spread,
    this.filterBoxX,
    this.filterBoxY,
    this.filterBoxWidth,
    this.filterBoxHeight,
    this.inset,
  );

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    final canvas = context.canvas;
    final Rect bounds = offset & size;
    // spread만큼 확장된 경계를 계산합니다.
    final Rect inflatedBounds = bounds.inflate(spread);

    // filterBox 값을 percent(0.0~1.0) 그대로 사용합니다.
    final double px = filterBoxX;
    final double py = filterBoxY;
    final double pw = filterBoxWidth;
    final double ph = filterBoxHeight;

    // filterBox로 사용할 Rect를 계산합니다.
    final Rect filterRect = Rect.fromLTWH(
      inflatedBounds.left + inflatedBounds.width * px,
      inflatedBounds.top + inflatedBounds.height * py,
      inflatedBounds.width * pw,
      inflatedBounds.height * ph,
    );

    // 1) 확장된 영역에 원본을 렌더링합니다.
    canvas.saveLayer(inflatedBounds, Paint());
    context.paintChild(child!, offset);

    // 2) inner-shadow용 Paint 설정
    final Paint shadowPaint = Paint()
      ..imageFilter = ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius)
      ..colorFilter = ColorFilter.mode(shadowColor, BlendMode.srcIn)
      ..blendMode = BlendMode.srcIn;

    // 3) filterRect 영역에 한정하여 blur+color 적용
    canvas.saveLayer(filterRect, shadowPaint);
    context.paintChild(child!, offset);
    canvas.restore(); // filterRect layer
    canvas.restore(); // inflatedBounds layer
  }

  // @override
  // void paint(PaintingContext context, Offset offset) {
  //   if (child == null) return;
  //   final canvas = context.canvas;
  //   final Rect bounds = offset & size;

  //   // 1) 레이어 하나만 만들고, 여기에 gradient → child → inner shadow 순서로 그린다
  //   canvas.saveLayer(bounds, Paint());

  //   context.paintChild(child!, offset);

  //   // // 1b) inner shadow (blur + color)
  //   final shadowPaint = Paint()
  //     ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
  //     ..colorFilter = ColorFilter.mode(shadowColor, BlendMode.srcOut)
  //     ..blendMode = BlendMode.srcIn;
  //   canvas.saveLayer(bounds, shadowPaint);
  //   context.paintChild(child!, offset);
  // }
}

/// SVG나 Image 위젯에 그라디언트와 inner‐shadow 를 함께 씌워주는 래퍼 위젯.
///
/// MoodDol의 돌탑과 같은 SVG 위젯에 그라디언트와 inner‐shadow 효과를 동시에 적용할 수 있습니다.
///
/// - [blur]: 내부 그림자에 적용할 블러 강도 (기본 8.0)
/// - [shadowColor]: 그림자 색상 (기본 흰색 55% 투명도)
/// - [offset]: 그림자 오프셋 (기본 Offset.zero) — 현재는 사용되지 않지만 향후 그림자 방향 지정에 사용 가능
/// - [gradient]: null 이면 그라디언트 없이, non‐null 이면 먼저 그라디언트를 srcIn 모드로 적용
/// - [imageChild]: SvgPicture.asset 이나 Image.asset 등, 실제 렌더링할 위젯
class GradientInnerShadowImage extends StatelessWidget {
  final double blur;
  final Color shadowColor;
  final Offset offset;
  final Gradient? gradient;
  final Widget imageChild;

  const GradientInnerShadowImage({
    super.key,
    this.blur = 8.0,
    this.shadowColor = const Color(0x8CFFFFFF), // white.withOpacity(0.55)
    this.offset = Offset.zero,
    this.gradient,
    required this.imageChild,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // 두 레이어 모두 같은 크기를 유지하도록MaxSize를 구해둡니다.
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;

      return Stack(
        alignment: Alignment.center,
        children: [
          // 1) Gradient 마스크 또는 원본 이미지를 먼저 그립니다.
          if (gradient != null)
            ShaderMask(
              shaderCallback: (bounds) => gradient!.createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: SizedBox(
                width: w,
                height: h,
                child: imageChild,
              ),
            )
          else
            SizedBox(
              width: w,
              height: h,
              child: imageChild,
            ),

          // 2) 같은 크기로 inner‐shadow 레이어를 덮어씌웁니다.
          InnerShadowImage(
            blur: blur,
            shadowColor: shadowColor,
            offset: offset,
            child: SizedBox(
              width: w,
              height: h,
              child: imageChild,
            ),
          ),
        ],
      );
    });
  }
}

/// 실제로 inner‐shadow 효과를 구현하는 RenderObjectWidget.
/// child 의 투명 영역을 활용해 테두리만 blur + color 로 처리합니다.

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
    canvas.restore();
    canvas.restore();
  }
}

/// https://gist.github.com/Chappie74/718bfc917196af03f87247731669bb14
class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    Key? key,
    this.shadows = const <Shadow>[],
    Widget? child,
  }) : super(key: key, child: child);

  final List<Shadow> shadows;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderInnerShadow renderObject) {
    renderObject.shadows = shadows;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  late List<Shadow> shadows;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    final bounds = offset & size;

    context.canvas.saveLayer(bounds, Paint());
    context.paintChild(child!, offset);

    for (final shadow in shadows) {
      final shadowRect = bounds.inflate(shadow.blurSigma);
      final shadowPaint = Paint()
        ..blendMode = BlendMode.srcATop
        ..colorFilter = ColorFilter.mode(shadow.color, BlendMode.srcOut)
        ..imageFilter = ImageFilter.blur(
            sigmaX: shadow.blurSigma, sigmaY: shadow.blurSigma);
      context.canvas
        ..saveLayer(shadowRect, shadowPaint)
        ..translate(shadow.offset.dx, shadow.offset.dy);
      context.paintChild(child!, offset);
      context.canvas.restore();
    }

    context.canvas.restore();
  }
}

/// CSS 스타일 JSON을 Flutter InnerShadow의 Shadow 리스트로 변환하여 적용하는 위젯입니다.
/// CSS 스타일을 Flutter InnerShadow의 Shadow 리스트로 매핑하여 적용하는 위젯
class CssInnerShadow extends StatelessWidget {
  /// 서버에서 전달된 CSS 스타일 파라미터
  final Map<String, dynamic> config;

  /// inner-shadow를 적용할 자식 위젯
  final Widget child;

  const CssInnerShadow({
    Key? key,
    required this.config,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1) JSON 파싱
    final offsetX = (config['offsetX'] as num).toDouble();
    final offsetY = (config['offsetY'] as num).toDouble();
    final blurRadius = (config['blurRadius'] as num).toDouble();
    final spread = (config['spread'] as num).toDouble();
    final rawColorHex = config['shadowColor'] as String;
    final shadowOpacity = (config['shadowOpacity'] as num).toDouble();

    // 2) Color 변환
    Color _hexToColor(String hex) {
      final buffer = StringBuffer();
      if (hex.length == 7 && hex[0] == '#') {
        buffer.write('ff');
        buffer.write(hex.substring(1));
      } else if (hex.length == 9 && hex[0] == '#') {
        buffer.write(hex.substring(1));
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    }

    final color = _hexToColor(rawColorHex).withOpacity(shadowOpacity);

    // 3) Shadow 객체 생성 (blurSigma 아님! blurRadius 로 넘겨주세요)
    final shadow = Shadow(
      offset: Offset(offsetX, offsetY),
      color: color,
      blurRadius: blurRadius, // ← 여기!
    );

    // 4) InnerShadow 위젯에 적용
    return InnerShadow(
      shadows: [shadow],
      child: child,
    );
  }
}
