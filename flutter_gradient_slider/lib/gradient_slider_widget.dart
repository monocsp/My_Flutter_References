import 'package:flutter/material.dart';
import 'package:flutter_gradient_slider/gradient_selector_page.dart';

/// 0~maxIndex*100 raw 값을 갖는 슬라이더 위젯.
/// 터치 종료 시 segmentSize 단위로 스냅 기능 유지
class GradientSliderWidget extends StatelessWidget {
  /// 현재 값 (0~maxIndex*100).
  final int value;

  /// 값 변경 시 호출.
  final ValueChanged<int> onChanged;

  /// 터치 시작 시 호출.
  final ValueChanged<double>? onChangeStart;

  /// 터치 종료 시 호출.
  final ValueChanged<double>? onChangeEnd;

  const GradientSliderWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rawMax = maxIndex * 100;
    return Slider(
      value: value.toDouble(),
      min: 0,
      max: rawMax.toDouble(),
      divisions: rawMax,
      onChangeStart: onChangeStart,
      onChanged: (v) => onChanged(v.round()),
      onChangeEnd: onChangeEnd,
    );
  }
}
