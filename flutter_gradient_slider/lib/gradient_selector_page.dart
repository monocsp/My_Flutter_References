import 'package:flutter/material.dart';
import 'package:flutter_gradient_slider/gradient_background_widget.dart';
import 'package:flutter_gradient_slider/gradient_slider_widget.dart';

const int maxIndex = 5;

/// GradientBackgroundWidget + GradientSliderWidget을 결합한 페이지
class GradientSelectorPage extends StatefulWidget {
  const GradientSelectorPage({Key? key}) : super(key: key);

  @override
  _GradientSelectorPageState createState() => _GradientSelectorPageState();
}

class _GradientSelectorPageState extends State<GradientSelectorPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(400);
  late final AnimationController _snapController;
  late Animation<int> _snapAnimation;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _snapAnimation = IntTween(
      begin: currentIndex.value,
      end: currentIndex.value,
    ).animate(_snapController)
      ..addListener(() {
        currentIndex.value = _snapAnimation.value;
      });
  }

  @override
  void dispose() {
    _snapController.dispose();
    currentIndex.dispose();
    super.dispose();
  }

  void _handleChangeStart(double _) {
    if (_snapController.isAnimating) _snapController.stop();
  }

  void _handleChanged(double v) {
    currentIndex.value = v.round();
  }

  void _handleChangeEnd(double v) {
    final rawMax = maxIndex * 100;
    final raw = v.round().clamp(0, rawMax);
    final segmentSize = (rawMax / maxIndex).round();
    final target = ((raw / segmentSize).round() * segmentSize).clamp(0, rawMax);
    _snapAnimation = IntTween(begin: currentIndex.value, end: target).animate(
        CurvedAnimation(parent: _snapController, curve: Curves.easeOut))
      ..addListener(() => currentIndex.value = _snapAnimation.value);
    _snapController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    // 사용자 요청: 5가지 수직 그라데이션 값
    final verticalPresets = [
      const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.3, 1.0],
        colors: [Color(0xFFFFFFFF), Color(0xFFD4FEFF), Color(0xFF85BEFF)],
      ),
      const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.3],
        colors: [Color(0xFFFFFFFF), Color(0xFF98FFDA)],
      ),
      const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.3],
        colors: [Color(0xFFFFFFFF), Color(0xFFFFFEB7)],
      ),
      const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.3],
        colors: [Color(0xFFFFFFFF), Color(0xFFFFD0B7)],
      ),
      const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.3],
        colors: [Color(0xFFFFFFFF), Color(0xFFFFBAB7)],
      ),
    ];

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder<int>(
                valueListenable: currentIndex,
                builder: (context, idx, child) {
                  return GradientBackgroundWidget(
                    index: idx,
                    verticalGradients: verticalPresets,
                    circleGradientB: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color(0xFFA6F9FF),
                        Color(0xFFA6F9FF),
                      ],
                    ),
                    opacityRangeB: RangeValues(0.3, 0.8),
                    opacityRangeA: RangeValues(1.0, 1.0),
                    circleGradientA: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Color(0xFF5197FF), Color(0xFF5197FF)],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: currentIndex,
                  builder: (context, idx, child) {
                    return GradientSliderWidget(
                      value: idx,
                      onChangeStart: _handleChangeStart,
                      onChanged: (v) => _handleChanged(v.toDouble()),
                      onChangeEnd: _handleChangeEnd,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
