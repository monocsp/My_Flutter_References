import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'dart:io';

class MLImageLabelingService {
  final ImageLabeler _imageLabeler;

  MLImageLabelingService({double confidenceThreshold = 0.5})
      : _imageLabeler = ImageLabeler(
          options:
              ImageLabelerOptions(confidenceThreshold: confidenceThreshold),
        );

  Future<List<ImageLabel>> processImage(File image) async {
    try {
      // InputImage 객체 생성
      final inputImage = InputImage.fromFile(image);

      // 이미지 라벨링 분석
      final labels = await _imageLabeler.processImage(inputImage);

      return labels;
    } catch (e) {
      print("Error during image labeling: $e");
      return [];
    }
  }

  void dispose() {
    _imageLabeler.close();
  }
}
