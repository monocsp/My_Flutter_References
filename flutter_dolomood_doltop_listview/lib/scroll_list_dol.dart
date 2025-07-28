import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dolomood_doltop_listview/model/dol_model.dart';
import 'package:flutter_dolomood_doltop_listview/scroll_bg.dart';
import 'package:flutter_dolomood_doltop_listview/scroll_dol.dart';

/// ListView에서 단일 폴리곤 이미지를 위에서 떨어뜨리는 위젯입니다.
class DolScrollPage extends StatefulWidget {
  const DolScrollPage({Key? key}) : super(key: key);

  @override
  _DolScrollPageState createState() => _DolScrollPageState();
}

class _DolScrollPageState extends State<DolScrollPage> {
  /// 모핑할 SVG/이미지 에셋 경로 목록
  final List<String> polygonAssets = const [
    'assets/dol/img_dol_1_13.png',
    'assets/dol/img_dol_1_14.png',
    'assets/dol/img_dol_1_15.png',
    'assets/dol/img_dol_1_16.png',
    'assets/dol/img_dol_1_17.png',
    'assets/dol/img_dol_1_18.png',
    'assets/dol/img_dol_1_19.png',
    'assets/dol/img_dol_1_20.png',
    'assets/dol/img_dol_1_21.png',
    'assets/dol/img_dol_1_22.png',
    'assets/dol/img_dol_1_23.png',
    'assets/dol/img_dol_1_24.png',
    'assets/dol/img_dol_1_38.png',
  ];

  /// 돌 리스트 스크롤 컨트롤러
  final ScrollController dolController = ScrollController();

  /// 배경 리스트 스크롤 컨트롤러
  final ScrollController bgController = ScrollController();

  /// 돌 모델 리스트
  late final List<DolModel> _dolModels;

  /// 상단/하단 패딩
  static const double _topPadding = 1500;
  static const double _bottomPadding = 200;

  /// 최초 스크롤이 실행되었는지 여부
  bool _hasInitialScroll = false;

  @override
  void initState() {
    super.initState();
    _dolModels = generateDolModels(10);
    dolController.addListener(_syncScroll);
    _scheduleInitialScroll();
  }

  /// 화면 렌더링 직후, 스크롤 컨트롤러가 연결되면 한 번만 애니메이션 실행
  void _scheduleInitialScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dolController.hasClients &&
          dolController.position.maxScrollExtent > 0) {
        // dolController.jumpTo(_topPadding / 1.5);
        dolController.animateTo(
          // dolController.position.maxScrollExtent,
          _topPadding / 1.5,

          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInBack,
        );
        _hasInitialScroll = true;
      } else if (!_hasInitialScroll) {
        // 아직 연결되지 않았으면 다음 프레임에 재시도
        _scheduleInitialScroll();
      }
    });
  }

  /// 돌 리스트와 배경 스크롤을 동기화하는 메소드
  /// 돌 리스트가 바닥에 도달한 이후에는 배경이 더 이상 움직이지 않도록 처리합니다.
  void _syncScroll() {
    // 컨트롤러가 리스트뷰에 연결되어 있어야 동기화 수행
    if (!dolController.hasClients || !bgController.hasClients) return;

    // 돌 리스트 오프셋을 0에서 maxScrollExtent 사이로 제한
    final dolOffset =
        dolController.offset.clamp(0.0, dolController.position.maxScrollExtent);

    // 돌 리스트가 바닥(maxScrollExtent)에 도달했으면 배경 이동 중단
    if (dolOffset >= dolController.position.maxScrollExtent) return;

    // 전체 돌탑 높이 합산
    final totalHeight = _dolModels.fold<double>(
      0.0,
      (sum, m) => sum + m.height * m.scale,
    );

    // 배경 뷰포트에서 실제 보이는 돌 리스트 높이 계산
    final viewport = bgController.position.viewportDimension;
    final rawBgOffset =
        totalHeight - dolOffset - (viewport - _topPadding - _bottomPadding);

    // 계산된 배경 오프셋이 음수면 업데이트 생략
    if (rawBgOffset < 0) return;

    // 배경 스크롤 위치를 계산된 오프셋으로 이동
    bgController.jumpTo(rawBgOffset);
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    final totalHeight = _dolModels.fold<double>(
      0,
      (sum, m) => sum + m.height * m.scale,
    );
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: -safeBottom,
          left: 0,
          right: 0,
          child: ScrollBg(
            totalHeight: totalHeight,
            bottomPadding: _bottomPadding, // ← 여기에 safeBottom 추가

            topPadding: _topPadding,
            onInit: () {},
            scrollController: bgController,
          ),
        ),
        Positioned.fill(
          child: ScrollDol(
            dolModels: _dolModels,
            controller: dolController,
            topPadding: _topPadding,
            bottomPadding: _bottomPadding, // ← 여기에 safeBottom 추가

            onInit: () {},
          ),
        ),
      ],
    );
  }

  /// 테스트용 DolModel 리스트 생성 함수
  List<DolModel> generateDolModels(int count) {
    final random = Random();
    const heights = [120.0, 140.0, 160.0, 180.0, 200.0];
    return List.generate(count, (index) {
      final path = polygonAssets[random.nextInt(polygonAssets.length)];
      final height = heights[random.nextInt(heights.length)];
      final scale = 1.0 + random.nextDouble() * 0.6;
      return DolModel(
        dolImagePath: path,
        height: height,
        scale: scale,
      );
    });
  }
}
