import 'package:opencv_dart/opencv.dart' as cv;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart' as svg;

/// 윤곽선 데이터(에셋 경로 + 경로(Path) + 원본 크기 + 꼭지점)를 담는 DTO
class ContourData {
  /// 원본 이미지 에셋 경로
  final String assetPath;

  /// 윤곽선 경로(Path)
  final Path outlinePath;

  /// 원본 이미지 크기
  final Size originalSize;

  /// 추출된 꼭지점 리스트
  final List<Offset> vertices;

  /// DTO 생성자
  ContourData({
    required this.assetPath,
    required this.outlinePath,
    required this.originalSize,
    required this.vertices,
  });
}

/// SVG/이미지 로드 및 윤곽선 추출 기능을 제공하는 클래스
class ContourExtractor {
  /// 빌드 컨텍스트 (SVG 렌더링용)
  final BuildContext context;

  /// 생성자
  ContourExtractor(this.context);

  /// 에셋 경로에서 OpenCV Mat을 로드합니다.
  /// SVG는 벡터 스케일→rasterize, PNG/JPG는 바이트 디코딩 후 리사이즈
  Future<cv.Mat> loadMatFromAsset(
    String assetPath,
    int targetWidth,
    int targetHeight,
  ) async {
    Uint8List bytes;
    if (assetPath.toLowerCase().endsWith('.svg')) {
      /// SVG 문자열 로드
      final svgString = await rootBundle.loadString(assetPath);

      /// PictureInfo 생성 (VectorGraphicUtilities)
      final picInfo = await svg.vg.loadPicture(
        svg.SvgStringLoader(svgString),
        context,
      );

      /// 원본 viewBox 크기
      final origSize = picInfo.size;

      /// PictureRecorder + Canvas 준비
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      );

      /// 스케일 적용
      final scaleX = targetWidth / origSize.width;
      final scaleY = targetHeight / origSize.height;
      canvas.scale(scaleX, scaleY);

      /// SVG 벡터 그리기
      canvas.drawPicture(picInfo.picture);
      picInfo.picture.dispose();

      /// rasterize 결과를 이미지로 변환
      final frame = recorder.endRecording();
      final svgImg = await frame.toImage(targetWidth, targetHeight);

      /// 이미지→PNG 바이트
      final bd = await svgImg.toByteData(format: ui.ImageByteFormat.png);
      if (bd == null) throw Exception('SVG to PNG byteData failed');
      bytes = bd.buffer.asUint8List();
    } else {
      /// PNG/JPG 바이트 로드
      final bd = await rootBundle.load(assetPath);
      bytes = bd.buffer.asUint8List();
    }

    /// OpenCV 디코딩 & 리사이즈
    cv.Mat mat = cv.imdecode(bytes, cv.IMREAD_COLOR);
    if (mat.cols != targetWidth || mat.rows != targetHeight) {
      mat = cv.resize(mat, (targetWidth, targetHeight));
    }
    return mat;
  }

  /// OpenCV Mat에서 윤곽선을 추출하여 ContourData로 반환합니다.
  /// 그레이스케일→이진화→모폴로지 클로징→블러→Canny→findContours 수행
  Future<ContourData> extractContours(
    cv.Mat src,
    String assetPath,
  ) async {
    /// 원본 크기 보관
    final originalSize = Size(src.cols.toDouble(), src.rows.toDouble());

    /// 그레이스케일 변환
    final gray = cv.cvtColor(src, cv.COLOR_BGR2GRAY);

    /// 이진화 (threshold 결과에서 Mat 추출)
    final threshRes = cv.threshold(gray, 128, 255, cv.THRESH_BINARY);
    cv.Mat bw = threshRes.$2;

    /// 모폴로지 클로징으로 틈 메우기
    final kernel = cv.getStructuringElement(cv.MORPH_RECT, (3, 3));
    bw = cv.morphologyEx(bw, cv.MORPH_CLOSE, kernel);

    /// 가우시안 블러
    final blurred = cv.gaussianBlur(bw, (3, 3), 0);

    /// Canny 엣지 검출
    final edges = cv.canny(blurred, 50, 150);

    /// contour 추출 (내부 윤곽 포함)
    final (contours, _) = cv.findContours(
      edges,
      cv.RETR_TREE,
      cv.CHAIN_APPROX_NONE,
    );

    /// 중간 Mat 해제
    src.dispose();
    gray.dispose();
    bw.dispose();
    blurred.dispose();
    edges.dispose();

    /// Path + vertices 구성
    final path = Path();
    final verts = <Offset>[];
    for (final contour in contours) {
      if (contour.isEmpty) continue;
      final first = contour.first;
      path.moveTo(first.x.toDouble(), first.y.toDouble());
      verts.add(Offset(first.x.toDouble(), first.y.toDouble()));
      for (int i = 1; i < contour.length; i++) {
        final pt = contour[i];
        path.lineTo(pt.x.toDouble(), pt.y.toDouble());
        verts.add(Offset(pt.x.toDouble(), pt.y.toDouble()));
      }
      path.close();
    }
    return ContourData(
      assetPath: assetPath,
      outlinePath: path,
      originalSize: originalSize,
      vertices: verts,
    );
  }

  /// loadMatFromAsset + extractContours를 순차 실행하는 편의 메소드
  Future<ContourData> loadAndExtract(
    String assetPath,
    int targetWidth,
    int targetHeight,
  ) async {
    final mat = await loadMatFromAsset(assetPath, targetWidth, targetHeight);
    return extractContours(mat, assetPath);
  }
}

/// ContourData를 화면에 렌더링하는 CustomPainter
class OutlinePainter extends CustomPainter {
  /// 윤곽선 데이터
  final ContourData contourData;

  /// 선 색상
  final Color strokeColor;

  /// 선 굵기
  final double strokeWidth;

  /// 생성자
  OutlinePainter(
    this.contourData, {
    this.strokeColor = Colors.red,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// 스케일 계산
    final scaleX = size.width / contourData.originalSize.width;
    final scaleY = size.height / contourData.originalSize.height;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    /// 윤곽선 그리기
    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / ((scaleX + scaleY) / 2)
      ..color = strokeColor;
    canvas.drawPath(contourData.outlinePath, paintStroke);

    /// 꼭지점 그리기
    final paintDot = Paint()
      ..style = PaintingStyle.fill
      ..color = strokeColor;
    for (final v in contourData.vertices) {
      canvas.drawCircle(v, strokeWidth, paintDot);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant OutlinePainter old) =>
      old.contourData != contourData ||
      old.strokeColor != strokeColor ||
      old.strokeWidth != strokeWidth;
}

/// 지정된 assetPath의 윤곽선을 비동기로 로드하여
/// 화면에 렌더링하는 위젯
class PolygonContourViewer extends StatelessWidget {
  /// 에셋 경로
  final String assetPath;

  /// target width
  final int targetWidth;

  /// target height
  final int targetHeight;

  /// 선 색상
  final Color borderColor;

  /// 선 굵기
  final double borderWidth;

  /// 생성자
  const PolygonContourViewer({
    Key? key,
    required this.assetPath,
    required this.targetWidth,
    required this.targetHeight,
    this.borderColor = Colors.red,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// ContourExtractor 인스턴스
    final extractor = ContourExtractor(context);
    return FutureBuilder<ContourData>(
      future: extractor.loadAndExtract(
        assetPath,
        targetWidth,
        targetHeight,
      ),
      builder: (ctx, snap) {
        if (snap.hasError) {
          return Center(child: Text('오류: ${snap.error}'));
        }
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final contourData = snap.data!;

        /// Fixed size 박스에 CustomPaint로 윤곽선 렌더
        return Center(
          child: SizedBox(
            width: targetWidth.toDouble(),
            height: targetHeight.toDouble(),
            child: CustomPaint(
              painter: OutlinePainter(
                contourData,
                strokeColor: borderColor,
                strokeWidth: borderWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

// /// SVG/이미지 경로에서 Mat을 생성하는 헬퍼 함수입니다.
// /// - SVG는 viewBox 기준으로 스케일→rasterize하여 원하는 크기로 꽉 채웁니다.
// /// - 그 외 PNG/JPG는 바이트로 바로 디코딩 후 리사이즈합니다.
// Future<cv.Mat> _loadMatFromAsset({
//   required String assetPath,
//   required BuildContext context,
//   required int targetWidth,
//   required int targetHeight,
// }) async {
//   Uint8List bytes;

//   if (assetPath.toLowerCase().endsWith('.svg')) {
//     /// 1) SVG 문자열 로드
//     final svgString = await rootBundle.loadString(assetPath);

//     /// 2) PictureInfo 생성
//     final picInfo = await svg.vg.loadPicture(
//       svg.SvgStringLoader(svgString),
//       context,
//     );

//     /// 3) 원본 viewBox 크기 추출
//     final origSize = picInfo.size; // ex: Size(24,24)

//     /// 4) PictureRecorder + Canvas 생성
//     final recorder = ui.PictureRecorder();
//     final canvas = Canvas(
//       recorder,
//       Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
//     );

//     /// 5) viewBox → target 크기 스케일 적용
//     final scaleX = targetWidth / origSize.width;
//     final scaleY = targetHeight / origSize.height;
//     canvas.scale(scaleX, scaleY);

//     /// 6) SVG 벡터 콘텐츠 그리기
//     canvas.drawPicture(picInfo.picture);
//     picInfo.picture.dispose();

//     /// 7) 스케일된 Picture → ui.Image
//     final scaledPic = recorder.endRecording();
//     final ui.Image svgImg = await scaledPic.toImage(
//       targetWidth,
//       targetHeight,
//     );

//     /// 8) ui.Image → PNG 바이트
//     final bd = await svgImg.toByteData(format: ui.ImageByteFormat.png);
//     if (bd == null) throw Exception('SVG → PNG byteData 변환 실패');
//     bytes = bd.buffer.asUint8List();
//   } else {
//     /// PNG/JPG: 에셋에서 바이트로 로드
//     final bd = await rootBundle.load(assetPath);
//     bytes = bd.buffer.asUint8List();
//   }

//   /// 9) OpenCV로 디코딩 & 리사이즈
//   cv.Mat mat = cv.imdecode(bytes, cv.IMREAD_COLOR);
//   if (mat.cols != targetWidth || mat.rows != targetHeight) {
//     mat = cv.resize(mat, (targetWidth, targetHeight));
//   }
//   return mat;
// }

// /// (3) 기존 윤곽선 추출 로직: Mat → Path, Size, vertices
// Future<(Path, Size, List<Offset>)> extractOutlinePathFromAsset({
//   required String assetSvgPath,
//   required BuildContext context,
//   required int targetWidth,
//   required int targetHeight,
// }) async {
//   // Mat 로드 (PNG로 변환된 SVG 포함)
//   cv.Mat src = await _loadMatFromAsset(
//     assetPath: assetSvgPath,
//     context: context,
//     targetWidth: targetWidth,
//     targetHeight: targetHeight,
//   );
//   // 2) 원본 이미지 크기 보관
//   final originalSize = Size(src.cols.toDouble(), src.rows.toDouble());

//   // 3) 그레이스케일 변환
//   cv.Mat gray = cv.cvtColor(src, cv.COLOR_BGR2GRAY);

//   // 4) 이진화 (threshold) - 반환된 record에서 Mat만 추출
//   final thresholdResult = cv.threshold(gray, 128, 255, cv.THRESH_BINARY);
//   cv.Mat bw = thresholdResult.$2;

//   // 5) 모폴로지 클로징으로 작은 틈 메우기
//   final kernel = cv.getStructuringElement(cv.MORPH_RECT, (3, 3));
//   bw = cv.morphologyEx(bw, cv.MORPH_CLOSE, kernel);

//   // 6) 약한 블러 적용 (3×3 커널)
//   cv.Mat blurred = cv.gaussianBlur(bw, (3, 3), 0);

//   // 7) Canny 엣지 검출 (low=50, high=150)
//   cv.Mat edges = cv.canny(blurred, 50, 150);

//   // 8) contours 추출 (RETR_TREE: 내부 윤곽 포함)
//   final (contours, _) = cv.findContours(
//     edges,
//     cv.RETR_TREE,
//     cv.CHAIN_APPROX_NONE,
//   );

//   // 9) 중간 Mat 객체 메모리 해제
//   src.dispose();
//   gray.dispose();
//   bw.dispose();
//   blurred.dispose();
//   edges.dispose();

//   // 10) Path 및 vertices 리스트 생성
//   final path = Path();
//   final verts = <Offset>[];
//   for (var contour in contours) {
//     if (contour.isEmpty) continue;
//     // 첫 점으로 경로 시작
//     final first = contour.first;
//     path.moveTo(first.x.toDouble(), first.y.toDouble());
//     verts.add(Offset(first.x.toDouble(), first.y.toDouble()));
//     // 이후 점들로 선 연결
//     for (int i = 1; i < contour.length; i++) {
//       final pt = contour[i];
//       path.lineTo(pt.x.toDouble(), pt.y.toDouble());
//       verts.add(Offset(pt.x.toDouble(), pt.y.toDouble()));
//     }
//     path.close();
//   }

//   return (path, originalSize, verts);
// }
