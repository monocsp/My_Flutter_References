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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController _fadeController; // Fade-in 애니메이션 컨트롤러
  late final AnimationController _controller; // 카드 움직임 애니메이션 컨트롤러
  late final Animation<double> _fadeAnimation; // Fade-in 애니메이션
  late final Animation<double> _cardAnimation; // 카드 움직임 애니메이션
  final CurveTween curve = CurveTween(curve: Curves.easeInOutCubic);
  double delta = 0;

  @override
  void initState() {
    super.initState();

    // Fade-in 애니메이션 설정
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // 카드 움직임 애니메이션 설정
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _cardAnimation = Tween<double>(begin: 0, end: 0.125)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _cardAnimation.addListener(() {
      setState(() {
        delta = _cardAnimation.value;
      });
    });

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
    _fadeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _fadeController.forward().then((_) {
      _controller.forward(); // fade-in 후 카드 움직임 애니메이션 시작
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation, // fade-in 애니메이션 적용
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(delta * math.pi * 2),
                child: Transform.rotate(
                  angle: -math.pi / 12,
                  child: Stack(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(12.0),
                          width: 53.98 * 3,
                          height: 85.60 * 3,
                          decoration: BoxDecoration(
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startAnimation, // 버튼 클릭 시 애니메이션 시작
              child: Text('Start Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
