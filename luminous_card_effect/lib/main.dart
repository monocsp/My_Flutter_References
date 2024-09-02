import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final CurveTween curve = CurveTween(curve: Curves.easeInOutCubic);
  double delta = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Tween을 사용해 delta가 0에서 0.5로, 다시 0으로 이동하도록 설정
    _animation = Tween<double>(begin: 0, end: 0.125)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 애니메이션의 변화에 따라 delta 값을 업데이트
    _animation.addListener(() {
      setState(() {
        delta = _animation.value;
      });
    });

    // 애니메이션이 끝나면 reverse를 호출해 반대 방향으로 움직이도록 설정
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(delta * math.pi * 2), // 0에서 0.5로 변화할 때 부드럽게 회전
          child: Transform.rotate(
            angle: -math.pi / 12,
            child: Stack(
              children: [
                Container(
                    padding: const EdgeInsets.all(12.0),
                    width: 53.98 * 3,
                    height: 85.60 * 3,
                    decoration: BoxDecoration(
                      // color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/card.jpg',
                      fit: BoxFit.fill,
                    )),
                Container(
                  width: 53.98 * 3,
                  height: 85.60 * 3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    gradient: RadialGradient(
                      center: Alignment(
                        Tween(begin: -7.5 / 4, end: 6.0 / 4)
                            .chain(curve)
                            .evaluate(_controller),
                        Tween(begin: -1.5 / 4, end: 2.0 / 4)
                            .chain(curve)
                            .evaluate(_controller),
                      ),
                      radius: 1.75,
                      colors: [
                        /// 빛 반사 강함정도
                        Colors.white.withOpacity(.9),
                        Colors.black.withOpacity(.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
