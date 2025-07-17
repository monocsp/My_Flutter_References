import 'package:flutter/material.dart';
import 'package:flutter_asset_to_polygon_animation/polygon/contour_extractor.dart';
import 'package:flutter_asset_to_polygon_animation/polygon/morphing_painter.dart';
import 'package:flutter_asset_to_polygon_animation/polygon/shape_sample.dart';

/// 여러 도형의 샘플 리스트를 받아 모핑 시퀀스를 제어하는 컨트롤러
class MorphSequenceController {
  /// 현재 morph 시작 인덱스 (0 ~ shapes.length-1)
  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  /// morph 보간값 (0.0 ~ 1.0)
  late final Animation<double> t;
  final AnimationController _ctrl;

  final Curve curve;

  /// 생성자:
  /// [vsync]: TickerProvider, [itemCount]: 모핑할 도형 개수
  /// [morphDuration]: morph 애니메이션 시간
  /// [delayDuration]: morph 간 지연 시간
  MorphSequenceController({
    required TickerProvider vsync,
    required int itemCount,
    required Duration morphDuration,
    required Duration delayDuration,
    required this.curve,
  }) : _ctrl = AnimationController(vsync: vsync, duration: morphDuration) {
    // easeOut 커브로 보간
    t = CurvedAnimation(parent: _ctrl, curve: curve);
    // 애니메이션 완료 시 다음 인덱스로 변경 후 지연 후 재시작
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(delayDuration, () {
          final next = (currentIndex.value + 1) % itemCount;
          currentIndex.value = next;
          _ctrl.forward(from: 0.0);
        });
      }
    });
    // 첫 morph 시작
    _ctrl.forward();
  }

  /// 리소스 해제
  void dispose() {
    _ctrl.dispose();
    currentIndex.dispose();
  }
}

/// 여러 도형을 샘플링·모핑하여 화면에 렌더링하는 위젯
class MorphingShapeView extends StatefulWidget {
  /// 윤곽선 데이터 리스트
  final List<ContourData> contours;

  /// Path 샘플 개수
  /// 샘플링된 도형의 점 개수
  /// 이 값이 높을수록 더 부드러운 모핑이 가능하지만 성능에 영향을 줄 수 있습니다.
  final int sampleCount;

  /// morph 애니메이션 시간
  final Duration morphDuration;

  /// morph 간 지연 시간
  final Duration delayDuration;

  /// 선 색상
  final Color strokeColor;

  /// 선 굵기
  final double strokeWidth;

  /// 커브 타입 (기본: easeOut)
  /// 이 커브는 모핑 애니메이션의 속도 변화를 조절합니다.
  final Curve curve;

  const MorphingShapeView({
    super.key,
    required this.contours,
    this.sampleCount = 120,
    this.morphDuration = const Duration(seconds: 3),
    this.delayDuration = const Duration(seconds: 2),
    this.strokeColor = Colors.red,
    this.strokeWidth = 1.0,
    this.curve = Curves.easeOut,
  });

  @override
  State<MorphingShapeView> createState() => _MorphingShapeViewState();
}

class _MorphingShapeViewState extends State<MorphingShapeView>
    with SingleTickerProviderStateMixin {
  late final MorphSequenceController _seqCtrl;
  late final List<List<Offset>> _shapes;

  @override
  void initState() {
    super.initState();
    // ContourData 리스트를 Path 샘플 리스트로 변환
    _shapes = widget.contours
        .map((c) => ShapeSampler.samplePath(c.outlinePath, widget.sampleCount))
        .toList();
    // 모핑 컨트롤러 초기화
    _seqCtrl = MorphSequenceController(
      vsync: this,
      itemCount: _shapes.length,
      curve: widget.curve,
      morphDuration: widget.morphDuration,
      delayDuration: widget.delayDuration,
    );
  }

  @override
  void dispose() {
    _seqCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<int>(
        valueListenable: _seqCtrl.currentIndex,
        builder: (context, idx, _) {
          // 다음 인덱스 계산
          final next = (idx + 1) % _shapes.length;
          return AnimatedBuilder(
            animation: _seqCtrl.t,
            builder: (context, _) {
              final t = _seqCtrl.t.value;
              final shapeA = _shapes[idx];
              final shapeB = _shapes[next];
              // 두 도형 간 보간된 점 리스트 생성
              final lerped = List<Offset>.generate(
                shapeA.length,
                (i) => Offset.lerp(shapeA[i], shapeB[i], t)!,
              );
              // 모핑 페인터로 렌더링
              return SizedBox.expand(
                child: CustomPaint(
                  painter: MorphingPainter(
                    sampledPoints: lerped,
                    strokeColor: widget.strokeColor,
                    strokeWidth: widget.strokeWidth,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
