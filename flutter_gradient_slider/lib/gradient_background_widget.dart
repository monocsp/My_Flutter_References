import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gradient_slider/gradient_selector_page.dart';

// 1) LinearGradient에 copyWith 기능 추가
extension GradientCopy on LinearGradient {
  /// 기존 속성은 그대로, 지정한 값만 덮어쓴 새 인스턴스 반환
  LinearGradient copyWith({
    Alignment? begin,
    Alignment? end,
    List<Color>? colors,
    List<double>? stops,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return LinearGradient(
      begin: begin ?? this.begin,
      end: end ?? this.end,
      colors: colors ?? this.colors,
      stops: stops ?? this.stops,
      tileMode: tileMode ?? this.tileMode,
      transform: transform ?? this.transform,
    );
  }
}

/// GradientBackgroundWidget에 파도처럼 일렁이는 원형 애니메이션을 추가한 위젯
/// index 값에 따라 배경과 중앙 영역 그라데이션을 보간하고,
/// 원형 위젯은 stops, 크기, 위치가 2초마다 랜덤으로 애니메이션됩니다.
class GradientBackgroundWidget extends StatefulWidget {
  /// 슬라이더의 raw 값 (1~maxIndex*100).
  final int index;

  /// 전체 화면에 적용할 수직 그라데이션 프리셋 목록.
  final List<LinearGradient> verticalGradients;

  /// 파동 A 레이어 그라데이션
  final LinearGradient circleGradientA;

  /// 파동 B 레이어 그라데이션
  final LinearGradient circleGradientB;

  /// 배경 그라데이션 애니메이션 지속 시간.
  final Duration duration;

  /// 파동 A 레이어의 opacity 범위 (start: min, end: max)
  final RangeValues opacityRangeA;

  /// 파동 B 레이어의 opacity 범위
  final RangeValues opacityRangeB;

  const GradientBackgroundWidget({
    super.key,
    required this.index,
    required this.verticalGradients,
    this.duration = const Duration(milliseconds: 300),
    required this.circleGradientA,
    required this.circleGradientB,
    this.opacityRangeA = const RangeValues(0.5, 0.8),
    this.opacityRangeB = const RangeValues(0.5, 0.8),
  });

  @override
  State<GradientBackgroundWidget> createState() =>
      _GradientBackgroundWidgetState();
}

class _GradientBackgroundWidgetState extends State<GradientBackgroundWidget> {
  final _leftA = ValueNotifier<double>(0);
  final _topA = ValueNotifier<double>(0);
  final _scaleA = ValueNotifier<double>(1);
  final _leftB = ValueNotifier<double>(0);
  final _topB = ValueNotifier<double>(0);
  final _scaleB = ValueNotifier<double>(1);
  // 기존 ValueNotifiers 외에 opacity용 Notifier 추가
  final _opacityA = ValueNotifier<double>(0.5);
  final _opacityB = ValueNotifier<double>(0.5);

  Timer? _timer;
  late double _screenW;
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenW = MediaQuery.of(context).size.width;
      _updateWaves();
      _timer =
          Timer.periodic(const Duration(seconds: 2), (_) => _updateWaves());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _leftA.dispose();
    _topA.dispose();
    _scaleA.dispose();
    _leftB.dispose();
    _topB.dispose();
    _scaleB.dispose();
    super.dispose();
  }

  /// A/B 레이어의 스케일, top, left를 랜덤 업데이트
  void _updateWaves() {
    const minScale = 0.5, maxScale = 1.0;

    // A가 커질 때 B는 작아지도록 반전
    final scaleA = minScale + _rnd.nextDouble() * (maxScale - minScale);
    final scaleB = minScale + maxScale - scaleA;
    _scaleA.value = scaleA;
    _scaleB.value = scaleB;

    // opacityRangeA/B 에서 랜덤
    _opacityA.value = widget.opacityRangeA.start +
        _rnd.nextDouble() *
            (widget.opacityRangeA.end - widget.opacityRangeA.start);
    _opacityB.value = widget.opacityRangeB.start +
        _rnd.nextDouble() *
            (widget.opacityRangeB.end - widget.opacityRangeB.start);

    // vertical (from top) max 230px
    _topA.value = _rnd.nextDouble() * 230;
    _topB.value = _rnd.nextDouble() * 230;

    // horizontal: 반전 플래그
    final flip = _rnd.nextBool();
    final sizeA = 800 * scaleA;
    final sizeB = 800 * scaleB;

    if (!flip) {
      // A는 왼쪽 절반, B는 오른쪽 절반
      _leftA.value = _rnd.nextDouble() * (_screenW / 2 - sizeA);
      _leftB.value = _screenW / 2 + _rnd.nextDouble() * (_screenW / 2 - sizeB);
    } else {
      // A는 오른쪽 절반, B는 왼쪽 절반
      _leftA.value = _screenW / 2 + _rnd.nextDouble() * (_screenW / 2 - sizeA);
      _leftB.value = _rnd.nextDouble() * (_screenW / 2 - sizeB);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 배경 수직 그라데이션 보간
    final rawMax = maxIndex * 100.0;
    final raw = widget.index.clamp(1, rawMax);
    final segment = rawMax / maxIndex;
    final pos = (raw - 1) / segment;
    final i0 = pos.floor().clamp(0, maxIndex - 1).toInt();
    final i1 = pos.ceil().clamp(0, maxIndex - 1).toInt();
    final t = (pos - i0).clamp(0.0, 1.0);

    return Stack(clipBehavior: Clip.none, children: [
      /// 전체 화면 수직 그라데이션
      AnimatedContainer(
        duration: widget.duration,
        decoration: BoxDecoration(gradient: widget.verticalGradients[i1]),
        child: const SizedBox.expand(),
      ),
      // 파동 A
      AnimatedBuilder(
        animation: Listenable.merge([_leftA, _topA, _scaleA, _opacityA]),
        builder: (context, _) {
          final size = 800 * _scaleA.value;
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.linear,
            bottom: 0,
            // bottom: _topA.value,
            left: _leftA.value,
            width: size,
            height: size,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 500, sigmaY: 500),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 3000),
                opacity: _opacityA.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.circleGradientA,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 50,
                        spreadRadius: 800,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

      // 파동 B
      AnimatedBuilder(
        animation: Listenable.merge([_leftB, _topB, _scaleB, _opacityB]),
        builder: (context, _) {
          final size = 800 * _scaleB.value;
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.linear,
            bottom: 0,
            // bottom: _topB.value,
            left: _leftB.value,
            width: size,
            height: size,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 500, sigmaY: 500),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 3000),
                opacity: _opacityB.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.circleGradientB,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 50,
                        spreadRadius: 800,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ]);
  }
}
