import 'package:flutter/material.dart';
import 'package:flutter_dolomood_doltop_listview/model/dol_model.dart';

/// 화면 중앙에 보이는 돌의 인덱스를 계산하여 출력하는 ListView 위젯

/// 화면 중앙 돌 강조 확대 애니메이션이 적용된 ListView 위젯
class ScrollDol extends StatefulWidget {
  /// 표시할 돌 모델 리스트
  final List<DolModel> dolModels;

  /// 스크롤 제어용 컨트롤러
  final ScrollController controller;

  /// 리스트 상단 패딩
  final double topPadding;

  /// 리스트 하단 패딩
  final double bottomPadding;

  /// 최초 렌더링 후 호출되는 콜백
  final VoidCallback? onInit;

  const ScrollDol({
    Key? key,
    required this.dolModels,
    required this.controller,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.onInit,
  }) : super(key: key);

  @override
  _ScrollDolState createState() => _ScrollDolState();
}

class _ScrollDolState extends State<ScrollDol> {
  /// 중앙 아이템 인덱스를 저장하는 노티파이어
  final ValueNotifier<int> centerIndexNotifier = ValueNotifier<int>(-1);

  /// 중앙 강조 시 사용할 최대 스케일
  static const double _maxScale = 1.25;

  /// 애니메이션 지속 시간
  static const Duration _animDuration = Duration(milliseconds: 200);

  /// 애니메이션 커브
  static const Curve _animCurve = Curves.easeOut;

  @override
  void initState() {
    super.initState();
    // 렌더링 후 뷰포트 높이 계산 및 초기 콜백 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit?.call();
    });
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    centerIndexNotifier.dispose();
    super.dispose();
  }

  /// 스크롤 시 화면 중앙 위치의 모델 인덱스를 계산
  void _onScroll() {
    final offset = widget.controller.offset;
    final centerPos =
        offset + (MediaQuery.of(context).size.height / 2) - widget.topPadding;
    double cumulative = 0;
    int foundIndex = 0;
    for (int i = 0; i < widget.dolModels.length; i++) {
      final model = widget.dolModels[i];
      final itemHeight = model.height * model.scale;
      if (cumulative + itemHeight >= centerPos) {
        foundIndex = i;
        break;
      }
      cumulative += itemHeight;
    }
    if (centerIndexNotifier.value != foundIndex) {
      centerIndexNotifier.value = foundIndex;
      print('Center index: $foundIndex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: centerIndexNotifier,
      builder: (context, centerIndex, child) {
        return ListView.builder(
          controller: widget.controller,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: widget.topPadding,
            bottom: widget.bottomPadding,
          ),
          itemCount: widget.dolModels.length,
          itemBuilder: (context, index) {
            final model = widget.dolModels[index];
            // 디바이스 크기
            final screenSize = MediaQuery.of(context).size;
            // 기본 아이템 높이
            final baseHeight = model.height * model.scale;
            // 중앙 아이템일 때만 확대
            final scale = (index == centerIndex) ? _maxScale : 1.0;
            // 최종 컨테이너 높이 (화면 높이를 넘어가지 않도록 제한)
            final itemHeight = (baseHeight * scale).clamp(
              0.0,
              screenSize.height,
            );
            // 최종 컨테이너 너비 (화면 너비를 넘어가지 않도록 제한)
            final itemWidth = screenSize.width;

            return AnimatedContainer(
              duration: _animDuration,
              curve: _animCurve,
              height: itemHeight,
              width: itemWidth,
              child: Image.asset(
                model.dolImagePath,
                fit: BoxFit.fitHeight,
                alignment: Alignment.bottomCenter,
              ),
            );
          },
        );
      },
    );
  }
}
