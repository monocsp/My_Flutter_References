import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

/// 완전히 고정된 배경 이미지를 렌더링하는 컴포넌트
class BackgroundImageComponent extends Component
    with HasGameReference<MyPhysicsGame> {
  final String assetPath;
  late final Sprite _sprite;

  BackgroundImageComponent(this.assetPath);

  @override
  Future<void> onLoad() async {
    // FlameGame.images 에 안전하게 접근
    await game.images.load(assetPath);
    _sprite = Sprite(game.images.fromCache(assetPath));
  }

  @override
  void render(Canvas canvas) {
    // 화면 크기에 맞춰 고정 배경 렌더링
    _sprite.render(canvas, size: game.size);
  }
}

/// 터치 드래그로 카메라를 위아래로 이동시키는 컴포넌트
class CameraDragComponent extends Component
    with HasGameReference<MyPhysicsGame>, VerticalDragDetector {
  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    final dy = info.delta.global.y;
    game.camera.moveBy(Vector2(0, -dy));
  }
}

/// 터치 드래그로 카메라 시점을 위아래로 이동시키는 컴포넌트.
/// - `VerticalDragDetector`를 믹인하여 세로 드래그만 처리합니다.
class CameraDragComponent extends Component
    with HasGameRef<MyPhysicsGame>, VerticalDragDetector {
  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    // 화면 픽셀 델타를 그대로 카메라 이동으로 사용
    final dy = info.delta.global.y;
    // 위로 드래그 → 배경은 아래로, 월드 컴포넌트는 위로 스크롤됩니다.
    gameRef.camera.moveBy(Vector2(0, -dy));
  }
}

/// 배경 고정 렌더링과 터치 드래그 카메라 이동을 결합한 게임 클래스.
class MyPhysicsGame extends Forge2DGame with HasDraggables {
  MyPhysicsGame()
      : super(
          gravity: Vector2.zero(),
          // 필요에 따라 FixedResolution 사용 가능:
          // camera: CameraComponent.withFixedResolution(width: 800, height: 600),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // // 1) 카메라 뒤에 고정 배경 이미지 추가
    // camera.backdrop.add(BackgroundImageComponent('home_bg_0.png'));

    // // 2) 월드(=Game)에 카메라 드래그 컨트롤 추가
    // add(CameraDragComponent());
  }
}


// /// 완전히 고정된 배경을 카메라 뒤에 두고,
// /// 월드 컴포넌트만 카메라 이동에 따라 스크롤되도록 분리한 예시
// class MyPhysicsGame extends Forge2DGame with VerticalDragDetector {
//   /// 총 배경 높이 (px)
//   final double totalHeight = 3000;

//   /// 한 타일 높이 (px)
//   late final double tileHeight;

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     // 1) 고정 배경을 camera.backdrop에 추가
//     camera.backdrop
//         .add(StaticBackground()); // :contentReference[oaicite:3]{index=3}

//     // 2) 스크롤될 타일 컴포넌트들을 world(=Game)의 children으로 추가
//     const assetPath = 'home_bg_0.png';
//     await images.load(assetPath);
//     final sprite = Sprite(images.fromCache(assetPath));
//     tileHeight = sprite.srcSize.y * size.x / sprite.srcSize.x;
//     final count = (totalHeight / tileHeight).ceil();
//     for (var i = 0; i < count; i++) {
//       add(SpriteComponent(
//         sprite: sprite,
//         size: Vector2(size.x, tileHeight),
//         position: Vector2(0, totalHeight - tileHeight * (i + 1)),
//         anchor: Anchor.topLeft,
//       ));
//     }

//     // 초기 카메라 위치 (맨 아래부터)
//     final startY = (totalHeight - size.y).clamp(0.0, totalHeight);
//     camera.moveTo(Vector2(0, startY));
//   }

//   @override
//   void onVerticalDragUpdate(DragUpdateInfo info) {
//     // 화면 터치 드래그로 월드만 세로 스크롤
//     final dy = info.delta.global.y;
//     camera.moveBy(Vector2(0, -dy));
//   }
// }

// /// 카메라 뒤에 고정되어 절대 움직이지 않는 배경 컴포넌트
// class StaticBackground extends Component with HasGameRef<MyPhysicsGame> {
//   late final Sprite sprite;
//   late final double tileHeight;

//   @override
//   Future<void> onLoad() async {
//     // 배경 이미지 로드
//     const assetPath = 'home_bg_0.png';
//     await gameRef.images.load(assetPath);
//     sprite = Sprite(gameRef.images.fromCache(assetPath));
//     tileHeight = sprite.srcSize.y * gameRef.size.x / sprite.srcSize.x;
//   }

//   @override
//   void render(Canvas canvas) {
//     // 전체 높이를 채우도록 반복 렌더링
//     for (double y = 0; y < gameRef.totalHeight; y += tileHeight) {
//       sprite.render(
//         canvas,
//         position: Vector2(0, y),
//         size: Vector2(gameRef.size.x, tileHeight),
//       );
//     }
//   }
// }

// /// 터치 드래그로 세로 스크롤만 되는 최소 구현 예시
// class MyPhysicsGame extends Forge2DGame with VerticalDragDetector {
//   /// 총 배경 높이 (px)
//   final double totalHeight = 3000;

//   /// 한 타일 높이 (px)
//   late final double tileHeight;

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
// // 예: 초기 카메라 중심 바로 위에 표시되도록
//     final initialCenter = camera.viewfinder.position.clone();
//     add(RectangleComponent(
//       position: Vector2(initialCenter.x, initialCenter.y),
//       size: Vector2(50, 50),
//       paint: Paint()..color = Colors.red,
//     ));

//     const assetPath = 'home_bg_0.png';
//     await images.load(assetPath);
//     final sprite = Sprite(images.fromCache(assetPath));

//     // 화면 폭(size.x)에 맞춘 타일 높이 계산
//     tileHeight = sprite.srcSize.y * size.x / sprite.srcSize.x;

//     // background 타일 쌓기
//     final count = (totalHeight / tileHeight).ceil();
//     for (int i = 0; i < count; i++) {
//       add(SpriteComponent(
//         sprite: sprite,
//         size: Vector2(size.x, tileHeight),
//         position: Vector2(0, totalHeight - tileHeight * (i + 1)),
//         anchor: Anchor.topLeft,
//       ));
//     }

//     // 초기 카메라 위치: 맨 아래부터
//     final startY = (totalHeight - size.y).clamp(0.0, totalHeight);
//     camera.moveTo(Vector2(0, startY));
//   }

//   // @override
//   // void onPanUpdate(DragUpdateInfo info) {
//   //   // info.delta.global.y는 뷰포트 적용된 픽셀 단위 이동량입니다.
//   //   final dy = info.delta.global.y;
//   //   // Y축 반전: 위로 드래그하면 배경이 위로 스크롤되도록 -dy
//   //   camera.moveBy(Vector2(0,
//   //       -dy)); // PanDetector + moveBy 사용 :contentReference[oaicite:0]{index=0}
//   // }

//   @override
//   void onVerticalDragUpdate(DragUpdateInfo info) {
//     final dy = info.delta.global.y;
//     // 드래그할 때마다 값이 찍히는지 확인
//     print('drag dy: $dy');
//     // 카메라 이동 전 위치
//     print('Camera center: ${camera.viewfinder.position}');

//     camera.moveBy(Vector2(0, -dy));
//     // 카메라 이동 후 위치
//     print(' after camera Y: ${camera.viewfinder.position}');
//   }
// }

// class MyPhysicsGame extends Forge2DGame with PanDetector, TapDetector {
//   /// 총 배경 높이 (px)
//   final double totalHeight = 3000;

//   /// 한 타일 높이 (px)
//   late final double tileHeight;

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     const assetPath = 'home_bg_0.png';
//     await images.load(assetPath);
//     final sprite = Sprite(images.fromCache(assetPath));

//     // 화면 폭(size.x)에 맞춰 비율 유지한 타일 높이 계산
//     tileHeight = sprite.srcSize.y * size.x / sprite.srcSize.x;

//     // totalHeight를 채우기 위해 필요한 타일 수
//     final count = (totalHeight / tileHeight).ceil();

//     // 맨 아래부터 위로 차곡차곡 쌓기
//     for (int i = 0; i < count; i++) {
//       add(SpriteComponent(
//         sprite: sprite,
//         size: Vector2(size.x, tileHeight),
//         position: Vector2(0, totalHeight - tileHeight * (i + 1)),
//         anchor: Anchor.topLeft,
//       ));
//     }

//     // 초기 카메라 위치를 맨 아래(바닥)부터 보이도록 설정
//     final startY = (totalHeight - size.y).clamp(0.0, totalHeight);
//     camera.moveTo(Vector2(0, startY));
//   }
// }

// class ScrollBgGame extends FlameGame with VerticalDragDetector {
//   SpriteComponent? bg;

//   @override
//   Future<void> onLoad() async {
//     final sprite = await Sprite.load('home_bg_0.png');
//     bg = SpriteComponent(
//       sprite: sprite,
//       size: Vector2(size.x, sprite.srcSize.y * size.x / sprite.srcSize.x),
//       position: Vector2(0, 0),
//       anchor: Anchor.topLeft,
//     );
//     add(bg!);
//   }

//   @override
//   void onVerticalDragUpdate(DragUpdateInfo info) {
//     // delta.global.y를 그대로 배경 컴포넌트 위치에 더해줌
//     bg!.position.add(Vector2(0, info.delta.global.y));
//   }
// }


