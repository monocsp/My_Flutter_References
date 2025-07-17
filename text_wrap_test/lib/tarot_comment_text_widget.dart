import 'dart:async';
import 'package:flutter/material.dart';
import 'package:text_wrap_test/text_pagenator.dart';

/// 페이지네이션 텍스트를 탭으로 순차 표시하는 위젯입니다.
/// - 빈 텍스트도 최소 높이로 렌더링합니다.
/// - 한 페이지당 최대 [maxLines]줄을 보장합니다.
/// - [[{{}}]]로 감싼 부분은 굵게 처리합니다.
/// - 텍스트를 페이지 단위로 분할(paginate)한 후 탭 시 [onPageTap] 호출
class TarotCommentTextWidget extends StatefulWidget {
  /// 한 페이지에 허용할 최대 줄 수
  final int maxLines;

  /// 전체 출력할 텍스트
  final String text;

  /// 페이지 변경 시(첫 렌더 포함) 호출되는 콜백
  final void Function(int index, bool isLast)? onPageChanged;

  /// 페이지 탭 시 호출되는 콜백
  final void Function(int index, bool isLast) onPageTap;

  /// 기본 텍스트 스타일
  final TextStyle textStyle;

  /// [[{{}}]] 굵게 처리 시 사용할 스타일
  final TextStyle? boldStyle;

  /// 탭 디바운스 시간
  final Duration debounceDuration;

  /// 화살표 표시 여부 (미사용 시 숨김)
  final bool isShowArrow;

  const TarotCommentTextWidget({
    super.key,
    this.maxLines = 4,
    required this.text,
    this.onPageChanged,
    required this.onPageTap,
    required this.textStyle,
    this.boldStyle,
    this.debounceDuration = const Duration(seconds: 1),
    this.isShowArrow = true,
  });

  @override
  State<TarotCommentTextWidget> createState() => _TarotCommentTextWidgetState();
}

class _TarotCommentTextWidgetState extends State<TarotCommentTextWidget> {
  late List<List<TextSpan>> _pages;
  late ValueNotifier<int> _currentIndex;
  DateTime? _lastTapTime;
  String _prevKey = '';
  bool _initialCalled = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = ValueNotifier(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lastTapTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _debouncedNextPage,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final key = widget.text + constraints.maxWidth.toString();
          if (_prevKey != key) {
            // 페이지별 TextSpan 리스트 생성
            _pages = TextPaginator.paginateTokens(
              widget.text.split(RegExp(r'\s+')),
              constraints.maxWidth,
              1.0, // slackRatio (예시로 1.0 사용)
              widget.maxLines,
              widget.textStyle,
            )
                .map((tokenList) => tokenList.map((t) {
                      if (widget.boldStyle != null &&
                          t.startsWith('[[') &&
                          t.endsWith(']]')) {
                        final content = t.substring(2, t.length - 2);
                        return TextSpan(text: content, style: widget.boldStyle);
                      }
                      return TextSpan(text: t, style: widget.textStyle);
                    }).toList())
                .toList();
            _prevKey = key;
            _initialCalled = false;
            _currentIndex.value = 0;
          }

          if (!_initialCalled) {
            widget.onPageChanged?.call(0, _pages.length <= 1);
            _initialCalled = true;
          }

          if (widget.text.isEmpty) {
            // 빈 텍스트일 때 최소 높이 유지
            final painter = TextPainter(
              text: TextSpan(text: ' ', style: widget.textStyle),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth - 40);
            final lineH = painter.computeLineMetrics().first.height;
            const padV = 28.0;
            final height = lineH + padV * 2;
            return Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth,
                height: height,
              ),
            );
          }

          // 현재 페이지 TextSpan과 높이 계산
          final spans = _pages[_currentIndex.value];
          final painter = TextPainter(
            text: TextSpan(children: spans),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth - 40);
          final txtH = painter.height;
          const padV = 28.0;
          final height = txtH + padV * 2;

          return AnimatedContainer(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            duration: const Duration(milliseconds: 300),
            width: constraints.maxWidth,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (_, idx, __) {
                return RichText(
                  text: TextSpan(children: _pages[idx]),
                  textDirection: TextDirection.ltr,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _debouncedNextPage() {
    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > widget.debounceDuration) {
      _nextPage();
      _lastTapTime = now;
    }
  }

  void _nextPage() {
    final nxt = _currentIndex.value + 1;
    if (nxt < _pages.length) {
      _currentIndex.value = nxt;
      widget.onPageTap(nxt, nxt == _pages.length - 1);
    } else {
      widget.onPageTap(_currentIndex.value, true);
    }
  }

  /// 다음 페이지로 이동합니다.
  /// 마지막 페이지 여부를 콜백에 전달합니다.
  void onTapNextButton() {
    _nextPage();
  }

  /// 이전 페이지로 이동합니다.
  /// 마지막 페이지 여부를 콜백에 전달합니다.
  void onTapBeforeButton() {
    final prev = _currentIndex.value - 1;
    if (prev >= 0) {
      _currentIndex.value = prev;
      widget.onPageTap(prev, prev == _pages.length - 1);
    } else {
      widget.onPageTap(0, _pages.length <= 1);
    }
  }

  /// 첫 페이지로 돌아갑니다.
  /// 마지막 페이지 여부를 콜백에 전달합니다.
  void goToFirstPage() {
    _currentIndex.value = 0;
    widget.onPageTap(0, _pages.length <= 1);
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }
}
