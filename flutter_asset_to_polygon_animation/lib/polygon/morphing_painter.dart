import 'dart:math';

import 'package:flutter/material.dart';

/// 점 리스트를 받아 도형 내부 채우기 및 윤곽선 그리기를 수행하는 CustomPainter
class MorphingPainter extends CustomPainter {
  /// 모핑된 도형을 구성할 점 리스트 (폐회로로 연결됨)
  final List<Offset> sampledPoints;

  /// 도형 윤곽선을 그릴 색상
  final Color strokeColor;

  /// 도형 윤곽선의 굵기 (px 단위)
  final double strokeWidth;

  /// 도형 내부를 단색으로 채울 때 사용할 색상 (null 시 기본색 적용)
  final Color? fillColor;

  /// 도형 내부를 그라데이션으로 채울 때 사용할 Gradient
  final Gradient? fillGradient;

  /// 생성자: 필수 필드를 주입받아 생성합니다.
  const MorphingPainter({
    required this.sampledPoints,
    required this.strokeColor,
    required this.strokeWidth,
    this.fillColor,
    this.fillGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 그릴 점이 없으면 바로 종료
    if (sampledPoints.isEmpty) return;

    // 1) 중심점 계산: 도형 채움 순서 결정용으로 사용
    final cx = sampledPoints.map((p) => p.dx).reduce((a, b) => a + b) /
        sampledPoints.length;
    final cy = sampledPoints.map((p) => p.dy).reduce((a, b) => a + b) /
        sampledPoints.length;

    // 2) 중심 기준 각도 계산 후 점들을 시계방향으로 정렬
    final ordered = List<Offset>.from(sampledPoints)
      ..sort((a, b) {
        final angA = atan2(a.dy - cy, a.dx - cx);
        final angB = atan2(b.dy - cy, b.dx - cx);
        return angA.compareTo(angB);
      });

    // 3) 정렬된 점들로 폐회로 Path 생성
    final path = Path()..addPolygon(ordered, true);

    // 4) 중앙 정렬 및 스케일 계산
    final bounds = path.getBounds();
    final sx = size.width / bounds.width;
    final sy = size.height / bounds.height;
    final scale = sx < sy ? sx : sy;
    final dx = (size.width - bounds.width * scale) / 2 - bounds.left * scale;
    final dy = (size.height - bounds.height * scale) / 2 - bounds.top * scale;

    // 변환 적용 전 상태 저장
    canvas.save();
    // 5) 캔버스 이동 및 스케일 적용
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    // 6) 내부 채우기: 단색 또는 그라데이션 적용
    final paintFill = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    if (fillGradient != null) {
      paintFill.shader = fillGradient!.createShader(Offset.zero & size);
    } else {
      paintFill.color = fillColor ?? Colors.red;
    }
    canvas.drawPath(path, paintFill);

    // 7) 윤곽선 그리기: stroke 스타일 적용
    final paintStroke = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = strokeColor;
    canvas.drawPath(path, paintStroke);

    // 변환 전 상태 복원
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MorphingPainter old) {
    // 입력값이 변경될 때만 다시 그리기
    return old.sampledPoints != sampledPoints ||
        old.strokeColor != strokeColor ||
        old.strokeWidth != strokeWidth ||
        old.fillColor != fillColor ||
        old.fillGradient != fillGradient;
  }
}
