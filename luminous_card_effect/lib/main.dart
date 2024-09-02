import 'dart:developer' as dev;
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
  late final Animation _animation;
  final CurveTween curve = CurveTween(curve: Curves.easeInOutCubic);
  double delta = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);

    _animation.addListener(() {
      setState(() {
        delta = _controller.value;
      });
    });
  }

  void panUpdate(double dx) {
    setState(() => {
          delta += (dx / 100),
          if (delta > .5) delta = .5,
          if (delta < -.5) delta = -.5,
        });

    _controller.value = delta;
    dev.log("delta : $delta");
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
            ..rotateY(delta),
          child: GestureDetector(
            onPanDown: (_) => _controller.stop(),
            onPanUpdate: (_) => panUpdate(-_.delta.dx),
            onPanEnd: (_) => _controller.reverse(),
            child: Transform.rotate(
              angle: -math.pi / 12,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    width: 53.98 * 3,
                    height: 85.60 * 3,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 96),
                            Container(
                              height: 32,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(2.5),
                                  bottomLeft: Radius.circular(2.5),
                                ),
                              ),
                            ),
                            const SizedBox(width: .5),
                            Container(
                                height: 32, width: 8, color: Colors.white),
                            const SizedBox(width: .5),
                            Container(
                              height: 32,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(2.5),
                                  bottomRight: Radius.circular(2.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 64),
                        const Text(
                          'TEST TEXT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 64),
                        Text(
                          'toss bank',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.3),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          Colors.white.withOpacity(.32),
                          Colors.black.withOpacity(.24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
