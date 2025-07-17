/// BgImageInfo 클래스는 배경 이미지의 에셋 경로와
/// 원본 가로/세로 크기를 담아두는 데이터 모델입니다.
/// LayoutBuilder에서 화면 제약(constraints.maxWidth)과
/// 이 원본 크기를 이용해 한 장당 출력 높이를 계산할 때 사용합니다.
class BgImageInfo {
  /// 에셋 이미지 경로 (예: 'assets/images/home_bg_0.png')
  final String assetPath;

  /// 원본 이미지의 가로 너비 (px)
  final double originalWidth;

  /// 원본 이미지의 세로 높이 (px)
  final double originalHeight;

  /// 이미지 순서를 나타내는 인덱스 (0부터 시작)
  /// 리스트에서 반복적으로 출력될 때 이 순서에 따라 배경이 순환됩니다.
  final int index;

  /// 바닥(Based) 이미지 여부를 나타내는 플래그
  /// 바닥 이미지는 무한 반복되지 않으며, 리스트에서 단 하나만 true가 됩니다.
  final bool isBased;

  const BgImageInfo({
    required this.isBased,
    required this.index,
    required this.assetPath,
    required this.originalWidth,
    required this.originalHeight,
  });
}
