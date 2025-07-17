import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// STEP 1~10: A~E 순서 애니메이션
/// `startTrigger` 가 true가 되면 애니메이션을 실행합니다.
class StackingDemoSteps10 extends StatefulWidget {
  const StackingDemoSteps10({
    Key? key,
    required this.startTrigger,
  }) : super(key: key);

  final ValueNotifier<bool> startTrigger;

  @override
  _StackingDemoSteps10State createState() => _StackingDemoSteps10State();
}

class _StackingDemoSteps10State extends State<StackingDemoSteps10> {
  // A~E 상태 Notifier 선언
  final ValueNotifier<double> sizeA = ValueNotifier(300);
  final ValueNotifier<double> topA = ValueNotifier((812 - 150) / 2);
  final ValueNotifier<double> opacityA = ValueNotifier(0);
  final ValueNotifier<Duration> durationA =
      ValueNotifier(const Duration(milliseconds: 800));

  final ValueNotifier<double> topB = ValueNotifier(227);
  final ValueNotifier<double> opacityB = ValueNotifier(0);

  final ValueNotifier<double> topC = ValueNotifier(198);
  final ValueNotifier<double> opacityC = ValueNotifier(0);

  final ValueNotifier<double> topD = ValueNotifier(204);
  final ValueNotifier<double> opacityD = ValueNotifier(0);

  final ValueNotifier<double> topE = ValueNotifier(152);
  final ValueNotifier<double> opacityE = ValueNotifier(0);

  bool _started = false;

  @override
  void initState() {
    super.initState();
    // startTrigger가 true로 변경될 때 애니메이션 실행
    widget.startTrigger.addListener(() {
      if (widget.startTrigger.value && !_started) {
        _started = true;
        _runSequence();
      }
    });
  }

  /// helper: startNotifier 아래 위젯들을 5px 간격으로 배치
  void _stackFrom(
      ValueNotifier<double> start, List<ValueNotifier<double>> below) {
    double current = start.value + 120;
    for (var notifier in below) {
      current += 5;
      notifier.value = current;
      current += 120;
    }
  }

  Future<void> _runSequence() async {
    // STEP1: A fade-in + shrink to 120
    opacityA.value = 1;
    await Future.delayed(const Duration(milliseconds: 50));
    sizeA.value = 120;

    // STEP2: A drop
    await Future.delayed(const Duration(milliseconds: 800));
    durationA.value = const Duration(milliseconds: 500);
    topA.value = 514.13;

    // // STEP3: B fade-in
    // await Future.delayed(const Duration(milliseconds: 500));

    // STEP4: B drop + adjust A
    await Future.delayed(const Duration(milliseconds: 500));
    opacityB.value = 1;
    topB.value = 448;
    durationA.value = const Duration(milliseconds: 150);
    _stackFrom(topB, [topA]);

    // // STEP5: C fade-in
    // await Future.delayed(const Duration(milliseconds: 150));

    // STEP6: C drop + adjust B/A
    await Future.delayed(const Duration(milliseconds: 300));
    opacityC.value = 1;
    topC.value = 403;
    durationA.value = const Duration(milliseconds: 300);
    _stackFrom(topC, [topB, topA]);

    // STEP7: D fade-in
    // await Future.delayed(const Duration(milliseconds: 300));

    // STEP8: D drop + adjust C/B/A
    await Future.delayed(const Duration(milliseconds: 300));
    opacityD.value = 1;
    topD.value = 318;
    durationA.value = const Duration(milliseconds: 300);
    _stackFrom(topD, [topC, topB, topA]);

    // STEP9: E fade-in
    // await Future.delayed(const Duration(milliseconds: 500));

    // STEP10: E drop + adjust D/C/B/A
    await Future.delayed(const Duration(milliseconds: 500));
    opacityE.value = 1;
    topE.value = 295;
    durationA.value = const Duration(milliseconds: 300);
    _stackFrom(topE, [topD, topC, topB, topA]);

    // STEP10 완료: 여기에 후속 애니메이션 트리거를 추가하세요.
  }

  @override
  void dispose() {
    sizeA.dispose();
    topA.dispose();
    opacityA.dispose();
    durationA.dispose();
    topB.dispose();
    opacityB.dispose();
    topC.dispose();
    opacityC.dispose();
    topD.dispose();
    opacityD.dispose();
    topE.dispose();
    opacityE.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // A Container
        ValueListenableBuilder<double>(
          valueListenable: topA,
          builder: (_, t, __) => ValueListenableBuilder<double>(
            valueListenable: sizeA,
            builder: (_, s, __) => ValueListenableBuilder<Duration>(
              valueListenable: durationA,
              builder: (_, d, __) => AnimatedPositioned(
                curve: Curves.fastOutSlowIn,
                key: const ValueKey('A_pos'),
                duration: d,
                top: t.h,
                left: ((375 - s) / 2).w,
                width: s.w,
                height: s.h,
                child: ValueListenableBuilder<double>(
                  valueListenable: opacityA,
                  builder: (_, o, __) => AnimatedOpacity(
                    curve: Curves.easeOut,
                    key: const ValueKey('A_op'),
                    duration: const Duration(milliseconds: 300),
                    opacity: o,
                    child: SvgPicture.asset('assets/dol1.svg'),
                  ),
                ),
              ),
            ),
          ),
        ),
        // B Container
        ValueListenableBuilder<double>(
          valueListenable: topB,
          builder: (_, t, __) => AnimatedPositioned(
            key: const ValueKey('B_pos'),
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            top: t.h,
            left: ((375 - 120) / 2).w,
            width: 120.w,
            height: 120.h,
            child: ValueListenableBuilder<double>(
              valueListenable: opacityB,
              builder: (_, o, __) => AnimatedOpacity(
                curve: Curves.easeOut,
                key: const ValueKey('B_op'),
                duration: const Duration(milliseconds: 300),
                opacity: o,
                child: Container(color: Colors.black),
              ),
            ),
          ),
        ),
        // C Container
        ValueListenableBuilder<double>(
          valueListenable: topC,
          builder: (_, t, __) => AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            key: const ValueKey('C_pos'),
            duration: const Duration(milliseconds: 300),
            top: t.h,
            left: ((375 - 120) / 2).w,
            width: 120.w,
            height: 120.h,
            child: ValueListenableBuilder<double>(
              valueListenable: opacityC,
              builder: (_, o, __) => AnimatedOpacity(
                curve: Curves.easeOut,
                key: const ValueKey('C_op'),
                duration: const Duration(milliseconds: 300),
                opacity: o,
                child: Container(color: Colors.black),
              ),
            ),
          ),
        ),
        // D Container
        ValueListenableBuilder<double>(
          valueListenable: topD,
          builder: (_, t, __) => AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            key: const ValueKey('D_pos'),
            duration: const Duration(milliseconds: 300),
            top: t.h,
            left: ((375 - 120) / 2).w,
            width: 120.w,
            height: 120.h,
            child: ValueListenableBuilder<double>(
              valueListenable: opacityD,
              builder: (_, o, __) => AnimatedOpacity(
                curve: Curves.easeOut,
                key: const ValueKey('D_op'),
                duration: const Duration(milliseconds: 300),
                opacity: o,
                child: Container(color: Colors.black),
              ),
            ),
          ),
        ),
        // E Container
        ValueListenableBuilder<double>(
          valueListenable: topE,
          builder: (_, t, __) => AnimatedPositioned(
            key: const ValueKey('E_pos'),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            top: t.h,
            left: ((375 - 120) / 2).w,
            width: 120.w,
            height: 120.h,
            child: ValueListenableBuilder<double>(
              valueListenable: opacityE,
              builder: (_, o, __) => AnimatedOpacity(
                curve: Curves.easeOut,
                key: const ValueKey('E_op'),
                duration: const Duration(milliseconds: 300),
                opacity: o,
                child: Container(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
