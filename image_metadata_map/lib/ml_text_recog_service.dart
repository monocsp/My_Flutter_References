import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MLTextRecognitionService {
  /// 이미지에서 텍스트를 분석하는 메서드
  Future<List<TextBlock>> processImage(File image) async {
    // InputImage 생성
    final InputImage inputImage = InputImage.fromFile(image);

    // 한국어 텍스트 인식을 위한 TextRecognizer 초기화
    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.korean);

    try {
      // 이미지에서 텍스트 인식
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // TextRecognizer 리소스 해제
      await textRecognizer.close();

      // 텍스트 블록 반환
      return recognizedText.blocks;
    } catch (e) {
      await textRecognizer.close();
      throw Exception('Failed to process text: $e');
    }
  }
}
