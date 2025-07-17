import 'package:flame/game.dart';
import 'package:flame/components.dart';

/// InfiniteBgGame
///
/// 전체 높이(totalHeight), 이미지 한 장 높이(tileHeight),
/// 이미지 가로 너비(tileWidth)를 생성자로 받아서
/// 무한 스크롤 배경 구성에 사용할 수 있는 FlameGame입니다.
class InfiniteBgGame extends FlameGame {
  /// 배경이 커버해야 할 전체 높이(px)
  final double totalHeight;

  /// 타일 하나의 높이(px)
  final double tileHeight;

  /// 타일 하나의 가로 너비(px)
  final double tileWidth;

  InfiniteBgGame({
    required this.totalHeight,
    required this.tileHeight,
    required this.tileWidth,
  });

  @override
  Future<void> onLoad() async {}
}
