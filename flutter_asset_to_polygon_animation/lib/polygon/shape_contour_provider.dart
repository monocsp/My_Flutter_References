import 'package:flutter/material.dart';
import 'package:flutter_asset_to_polygon_animation/polygon/contour_extractor.dart';

/// 에셋 경로 리스트를 받아 ContourData 리스트를 반환하는 Provider 클래스
class ShapeContourProvider {
  final BuildContext context;

  /// 생성자: BuildContext를 주입받아 SVG 랜더링에 사용
  ShapeContourProvider(this.context);

  /// 여러 에셋 경로를 주어진 크기로 로드 후 ContourData 리스트로 반환
  Future<List<ContourData>> loadContours(
    List<String> assetPaths,
    Size targetSize,
  ) async {
    final extractor = ContourExtractor(context);
    final List<ContourData> contours = [];
    // 각 경로별로 ContourData 생성
    for (final path in assetPaths) {
      final data = await extractor.loadAndExtract(
        path,
        targetSize.width.toInt(),
        targetSize.height.toInt(),
      );
      contours.add(data);
    }
    return contours;
  }

  /// 단일 에셋 경로에서 ContourData를 로드하는 편의 메소드
  Future<ContourData> loadContour(
    String assetPath,
    Size targetSize,
  ) async {
    final extractor = ContourExtractor(context);
    return extractor.loadAndExtract(
      assetPath,
      targetSize.width.toInt(),
      targetSize.height.toInt(),
    );
  }
}
