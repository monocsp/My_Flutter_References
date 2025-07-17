import 'package:flutter/material.dart';

class MorphingPainter extends CustomPainter {
  final List<Offset> sampledPoints;
  final Color strokeColor;
  final double strokeWidth;

  MorphingPainter({
    required this.sampledPoints,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sampledPoints.length < 2) return;

    /// 1) Chaikin 스무딩 2회 적용
    List<Offset> smoothPts(List<Offset> pts, int iter) {
      var list = List<Offset>.from(pts);
      for (var k = 0; k < iter; k++) {
        final newPts = <Offset>[];
        for (var i = 0; i < list.length; i++) {
          final p0 = list[i];
          final p1 = list[(i + 1) % list.length];
          newPts.add(Offset(
            p0.dx * 0.75 + p1.dx * 0.25,
            p0.dy * 0.75 + p1.dy * 0.25,
          ));
          newPts.add(Offset(
            p0.dx * 0.25 + p1.dx * 0.75,
            p0.dy * 0.25 + p1.dy * 0.75,
          ));
        }
        list = newPts;
      }
      return list;
    }

    /// 2) Catmull–Rom 스플라인 보간 (세그먼트 3)
    List<Offset> catmullRom(List<Offset> pts, int segs) {
      if (pts.length < 4) return pts;
      final p = [
        pts[pts.length - 2],
        pts[pts.length - 1],
        ...pts,
        pts[0],
        pts[1],
      ];
      final out = <Offset>[];
      for (int i = 1; i < p.length - 2; i++) {
        final p0 = p[i - 1], p1 = p[i], p2 = p[i + 1], p3 = p[i + 2];
        for (int j = 0; j < segs; j++) {
          final t = j / segs, tt = t * t, ttt = tt * t;
          final x = 0.5 *
              ((2 * p1.dx) +
                  (-p0.dx + p2.dx) * t +
                  (2 * p0.dx - 5 * p1.dx + 4 * p2.dx - p3.dx) * tt +
                  (-p0.dx + 3 * p1.dx - 3 * p2.dx + p3.dx) * ttt);
          final y = 0.5 *
              ((2 * p1.dy) +
                  (-p0.dy + p2.dy) * t +
                  (2 * p0.dy - 5 * p1.dy + 4 * p2.dy - p3.dy) * tt +
                  (-p0.dy + 3 * p1.dy - 3 * p2.dy + p3.dy) * ttt);
          out.add(Offset(x, y));
        }
      }
      return out;
    }

    // ───────────────────────────────────────
    // 샘플링된 점 → 스무딩 → 스플라인
    final smoothed = smoothPts(sampledPoints, 2);
    final finalPts = catmullRom(smoothed, 3);

    // ───────────────────────────────────────

    /// 3) Path 재구성
    // final path = Path()..moveTo(finalPts[0].dx, finalPts[0].dy);

// 수정된 코드: addPolygon 한 줄만으로 완전한 폐회로(closed loop)를 만듭니다.
    final path = Path()..addPolygon(finalPts, true);

    for (final p in finalPts.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    path.close();

    /// 4) Path 바운딩 박스 계산
    final bounds = path.getBounds();

    /// 5) 스케일 및 중앙 정렬 계산
    final sx = size.width / bounds.width;
    final sy = size.height / bounds.height;
    final s = sx < sy ? sx : sy;
    final dx = (size.width - bounds.width * s) / 2 - bounds.left * s;
    final dy = (size.height - bounds.height * s) / 2 - bounds.top * s;

    canvas.save();
    // 6) 패딩 처리된 영역 안에서 중앙 정렬
    canvas.translate(dx, dy);
    // 7) 스케일 적용
    canvas.scale(s, s);

    /// 8) Path 그리기 (anti-alias + 라인 조인 둥글게)
    // 5) 항상 매끄럽게 이어지도록 StrokeJoin/RoundCap 적용
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.round // 선들이 만나는 곳을 부드럽게
      ..strokeCap = StrokeCap.round // 끝점도 둥글게
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / s
      ..color = strokeColor;

    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MorphingPainter old) =>
      old.sampledPoints != sampledPoints ||
      old.strokeColor != strokeColor ||
      old.strokeWidth != strokeWidth;
}

// /// 보간된 점 리스트를 받아 Path로 재구성하여 그려주는 CustomPainter
// class MorphingPainter extends CustomPainter {
//   /// 보간된 도형의 점 리스트
//   final List<Offset> sampledPoints;

//   /// 선 색상
//   final Color strokeColor;

//   /// 선 굵기
//   final double strokeWidth;

//   MorphingPainter({
//     required this.sampledPoints,
//     required this.strokeColor,
//     required this.strokeWidth,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (sampledPoints.isEmpty) return;

//     // 1) Path 재구성
//     final path = Path()..moveTo(sampledPoints[0].dx, sampledPoints[0].dy);
//     for (final p in sampledPoints.skip(1)) {
//       path.lineTo(p.dx, p.dy);
//     }
//     path.close();

//     // 2) Path 바운딩 박스 계산
//     final bounds = path.getBounds();

//     // 3) 스케일 값 계산 (padding이 제외된 size 기준)
//     final scale = (size.width / bounds.width).clamp(0.0, double.infinity);
//     final scaleY = (size.height / bounds.height).clamp(0.0, double.infinity);
//     final s = scale < scaleY ? scale : scaleY;

//     // 4) translate 먼저: 패딩 안쪽 좌상단에서
//     //    (bounds.left, bounds.top) 위치를 빼고,
//     //    남은 공간을 ½씩 나눠 중앙에 위치하도록 오프셋 계산
//     final dx = (size.width - bounds.width * s) / 2 - bounds.left * s;
//     final dy = (size.height - bounds.height * s) / 2 - bounds.top * s;

//     canvas.save();
//     // 5) 패딩 내에서 중앙으로 이동
//     canvas.translate(dx, dy);
//     // 6) 스케일 적용
//     canvas.scale(s, s);

//     // 7) Path 그리기 (strokeWidth도 스케일 보정)
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth / s
//       ..color = strokeColor;
//     canvas.drawPath(path, paint);

//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(covariant MorphingPainter old) =>
//       old.sampledPoints != sampledPoints ||
//       old.strokeColor != strokeColor ||
//       old.strokeWidth != strokeWidth;
// }
