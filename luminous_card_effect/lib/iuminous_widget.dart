import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientOverlay extends StatefulWidget {
  final Widget child;

  const GradientOverlay({Key? key, required this.child}) : super(key: key);

  @override
  _GradientOverlayState createState() => _GradientOverlayState();
}

class _GradientOverlayState extends State<GradientOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final CurveTween curve = CurveTween(curve: Curves.easeInOutCubic);

  @override
  void initState() {
    super.initState();

    // 빛의 움직임을 조절할 애니메이션 컨트롤러 설정
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 기본 위젯 (이미지나 다른 콘텐츠가 될 수 있음)
        widget.child,

        // Radial Gradient 빛 효과
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      Tween(begin: -7.5 / 4, end: 6.0 / 4)
                          .chain(curve)
                          .evaluate(_controller),
                      Tween(begin: -1.5 / 4, end: 2.0 / 4)
                          .chain(curve)
                          .evaluate(_controller),
                    ),
                    radius: 1.75,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
