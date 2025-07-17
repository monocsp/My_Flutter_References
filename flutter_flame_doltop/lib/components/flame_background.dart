import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter_flame_doltop/components/flame_game.dart';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

// /// 전체 배경(바닥 + 순환 타일)을 화면 크기에 맞춰 렌더링하는 컴포넌트입니다.
// class BackgroundComponent extends Component
//     with HasGameReference<MyPhysicsGame> {
//   /// 돌탑 전체 높이 (world 단위)
//   final double totalHeight;

//   /// 바닥 이미지를 감싼 Sprite
//   final Sprite groundSprite;

//   /// 순환할 배경 스프라이트 6장
//   final List<Sprite> backgroundSprites;

//   BackgroundComponent({
//     required this.totalHeight,
//     required this.groundSprite,
//     required this.backgroundSprites,
//   });

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     _buildBackground();
//   }

//   /// 실제 캔버스 크기를 기준으로 배경(바닥 + 타일) 배치
//   void _buildBackground() {
//     // 1) 화면 크기
//     final width = game.size.x;
//     final height = game.size.y;

//     // 2) 바닥 높이 계산 (가로폭에 맞춰 비율 스케일)
//     final groundHeight =
//         groundSprite.srcSize.y * (width / groundSprite.srcSize.x);

//     // 3) 바닥 컴포넌트
//     add(
//       SpriteComponent(
//         sprite: groundSprite,
//         size: Vector2(width, groundHeight),
//         position: Vector2(0, height - groundHeight),
//         anchor: Anchor.topLeft,
//       ),
//     );

//     // 4) 타일 높이 계산
//     final tileHeight = backgroundSprites.first.srcSize.y *
//         (width / backgroundSprites.first.srcSize.x);

//     // 5) 총 몇 개 타일이 필요한지
//     final tileCount = ((totalHeight - groundHeight) / tileHeight).ceil();

//     // 6) 위로 쌓아올리기
//     for (var i = 0; i < tileCount; i++) {
//       final sprite = backgroundSprites[i % backgroundSprites.length];
//       add(
//         SpriteComponent(
//           sprite: sprite,
//           size: Vector2(width, tileHeight),
//           position: Vector2(0, height - groundHeight - (i + 1) * tileHeight),
//           anchor: Anchor.topLeft,
//         ),
//       );
//     }
//   }

//   @override
//   void onGameResize(Vector2 canvasSize) {
//     super.onGameResize(canvasSize);
//     // 리사이즈 때마다 다시 그려주기
//     // children.clear();
//     _buildBackground();
//   }
// }

class Background extends SpriteComponent with HasGameReference<MyPhysicsGame> {
  Background({required super.sprite})
      : super(anchor: Anchor.center, position: Vector2(0, 0));

  @override
  void onMount() {
    super.onMount();

    size = Vector2.all(
      max(
        game.camera.visibleWorldRect.width,
        game.camera.visibleWorldRect.height,
      ),
    );
  }
}
