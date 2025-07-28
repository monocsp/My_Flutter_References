/// 배경 이미지 정보를 담는 모델
class BgImageModel {
  /// 에셋 경로 (e.g. 'assets/background/home_bg_1.png')
  final String assetPath;

  /// 원본 이미지 너비
  final double originalWidth;

  /// 원본 이미지 높이
  final double originalHeight;

  /// 바닥(ground) 파일 여부 표시
  final bool isFloor;

  const BgImageModel({
    required this.assetPath,
    required this.originalWidth,
    required this.originalHeight,
    required this.isFloor,
  });
}
