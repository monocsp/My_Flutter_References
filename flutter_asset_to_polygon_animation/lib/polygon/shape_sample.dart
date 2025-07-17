import 'package:flutter/material.dart';

/// Path를 일정 개수의 Offset 리스트로 샘플링하는 유틸리티 클래스
class ShapeSampler {
  /// Path 내의 모든 서브패스를 합쳐서 길이를 구하고,
  /// sampleCount 개수만큼 균일하게 점을 뽑아냅니다.
  static List<Offset> samplePath(Path outline, int sampleCount) {
    // 1) 모든 PathMetric 수집
    final metrics = outline.computeMetrics().toList();
    // 2) 전체 길이 합산
    final totalLength = metrics.fold<double>(0, (sum, m) => sum + m.length);

    // 3) 균일 분할 거리마다 tangent 위치 계산
    return List.generate(sampleCount, (i) {
      final dist = i * totalLength / sampleCount;
      double acc = 0;
      for (final m in metrics) {
        if (dist <= acc + m.length) {
          return m.getTangentForOffset(dist - acc)!.position;
        }
        acc += m.length;
      }
      // 혹시 넘어갔으면 마지막 위치 반환
      final last = metrics.last;
      return last.getTangentForOffset(last.length)!.position;
    });
  }
}
