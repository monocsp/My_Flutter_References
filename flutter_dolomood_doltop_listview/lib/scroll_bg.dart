import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dolomood_doltop_listview/model/bg_image_model.dart';

/// 전체 콘텐츠 높이에 맞춘 배경 이미지를 반복 스크롤로 보여주는 위젯
class ScrollBg extends StatefulWidget {
  /// 표시할 전체 콘텐츠 높이 (px 단위)
  final double totalHeight;

  /// 최초 렌더링 후 호출할 초기화 콜백
  final VoidCallback onInit;

  /// 상단 패딩
  final double topPadding;

  /// 하단 패딩
  final double bottomPadding;

  /// 외부 스크롤 제어를 위한 ScrollController
  final ScrollController scrollController;

  const ScrollBg({
    Key? key,
    required this.totalHeight,
    required this.onInit,
    required this.scrollController,
    required this.topPadding,
    required this.bottomPadding,
  }) : super(key: key);

  @override
  State<ScrollBg> createState() => _ScrollBgState();
}

class _ScrollBgState extends State<ScrollBg> {
  /// 바운스 시 추가로 채워줄 버퍼 높이
  static final double _overscrollBuffer = 100.0;

  /// 배경 이미지 모델 리스트 Notifier
  final ValueNotifier<List<BgImageModel>?> _bgModels = ValueNotifier(null);

  /// 계산된 전체 배경 높이 (콘텐츠 + 패딩)
  late final double totalBackgroundHeight;

  /// 에셋 경로 리스트 (home_bg_0 ~ home_bg_6)
  static const List<String> _backgroundImageAssetList = [
    'assets/background/home_bg_0.png',
    'assets/background/home_bg_1.png',
    'assets/background/home_bg_2.png',
    'assets/background/home_bg_3.png',
    'assets/background/home_bg_4.png',
    'assets/background/home_bg_5.png',
    'assets/background/home_bg_6.png',
  ];

  @override
  void initState() {
    super.initState();
    totalBackgroundHeight =
        widget.totalHeight + widget.topPadding + widget.bottomPadding;

    // 최초 렌더링 후 콜백 및 모델 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit();
      _loadBgModels();
    });
  }

  /// 배경 이미지 모델 리스트를 비동기로 로드
  Future<void> _loadBgModels() async {
    final futures =
        _backgroundImageAssetList.asMap().entries.map((entry) async {
      final idx = entry.key;
      final path = entry.value;
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return BgImageModel(
        assetPath: path,
        originalWidth: frame.image.width.toDouble(),
        originalHeight: frame.image.height.toDouble(),
        isFloor: idx == 0,
      );
    });
    _bgModels.value = await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<BgImageModel>?>(
      valueListenable: _bgModels,
      builder: (_, models, __) {
        if (models == null) return const SizedBox();

        return LayoutBuilder(builder: (context, constraints) {
          final imageWidth = constraints.maxWidth;
          final first = models.first;
          final imageHeight =
              imageWidth * first.originalHeight / first.originalWidth;

          // 버퍼까지 포함한 전체 높이를 감안해 페이지 수 계산
          final pageCount =
              ((totalBackgroundHeight + _overscrollBuffer) / imageHeight)
                  .ceil();

          return ListView.builder(
            reverse: true,
            controller: widget.scrollController,
            physics: totalBackgroundHeight == 0
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            // : const BouncingScrollPhysics(),
            itemCount: pageCount,
            itemExtent: imageHeight,
            itemBuilder: (context, index) {
              final model = index == 0
                  ? models.first
                  : models[((index - 1) % (models.length - 1)) + 1];
              return SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Image.asset(
                  model.assetPath,
                  fit: BoxFit.fitWidth,
                ),
              );
            },
          );
        });
      },
    );
  }
}
