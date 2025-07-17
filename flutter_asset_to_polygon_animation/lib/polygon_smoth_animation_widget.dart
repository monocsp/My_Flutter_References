// class MorphingPolygonPainter extends CustomPainter {
//   final double sides;
//   final int sampleCount;
//   MorphingPolygonPainter({required this.sides, this.sampleCount = 120});

//   // 정규 폴리 Path 생성
//   Path _makePolyPath(int n, Size size) {
//     final path = Path();
//     final center = Offset(size.width / 2, size.height / 2);
//     final r = size.width / 2;
//     for (int i = 0; i < n; i++) {
//       final theta = 2 * pi * i / n;
//       final p = Offset(center.dx + r * cos(theta), center.dy + r * sin(theta));
//       if (i == 0)
//         path.moveTo(p.dx, p.dy);
//       else
//         path.lineTo(p.dx, p.dy);
//     }
//     path.close();
//     return path;
//   }

//   // Path → sampleCount 개의 Offset 리스트
//   List<Offset> _samplePath(Path path) {
//     final pm = path.computeMetrics().first;
//     final L = pm.length;
//     return List.generate(sampleCount, (i) {
//       final pos = pm.getTangentForOffset(i * L / sampleCount)!.position;
//       return pos;
//     });
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     final int f = sides.floor();
//     final int c = sides.ceil();
//     final double t = sides - f;

//     final p1 = _makePolyPath(f, size);
//     final p2 = _makePolyPath(c, size);
//     final v1 = _samplePath(p1);
//     final v2 = _samplePath(p2);

//     // 보간된 점 리스트
//     final verts = List<Offset>.generate(
//       sampleCount,
//       (i) => Offset.lerp(v1[i], v2[i], t)!,
//     );

//     // path 재구성
//     final path = Path()..moveTo(verts[0].dx, verts[0].dy);
//     for (var v in verts.skip(1)) {
//       path.lineTo(v.dx, v.dy);
//     }
//     path.close();

//     // 그리기
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3;
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant MorphingPolygonPainter o) => o.sides != sides;
// }

// class Polygon extends CustomPainter {
//   final int sides;

//   Polygon({
//     required this.sides,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 3;

//     final path = Path();

//     final center = Offset(size.width / 2, size.height / 2);
//     final angle = (2 * pi) / sides;

//     final angles = List.generate(sides, (index) => index * angle);

//     final radius = size.width / 2;

//     /*
//     x = center.x + radius * cos(angle)
//     y = center.y + radius * sin(angle)
//     */

//     path.moveTo(
//       center.dx + radius * cos(0),
//       center.dy + radius * sin(0),
//     );

//     for (final angle in angles) {
//       path.lineTo(
//         center.dx + radius * cos(angle),
//         center.dy + radius * sin(angle),
//       );
//     }

//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) =>
//       oldDelegate is Polygon && oldDelegate.sides != sides;
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _sidesAnim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     )..repeat(reverse: true);

//     _sidesAnim = Tween<double>(begin: 3.0, end: 20.0)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _sidesAnim,
//           builder: (_, __) {
//             return CustomPaint(
//               size: Size(300, 300),
//               painter: MorphingPolygonPainter(
//                 sides: _sidesAnim.value,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
// }
