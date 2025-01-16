import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_metadata_map/%08ml_text_recog_service.dart';
import 'package:image_metadata_map/ml_image_labeling_service.dart';
import 'package:image_metadata_map/naver_api_fetch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    home: ImageMetadataScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class ImageMetadataScreen extends StatefulWidget {
  @override
  _ImageMetadataScreenState createState() => _ImageMetadataScreenState();
}

class _ImageMetadataScreenState extends State<ImageMetadataScreen> {
  File? _image; // 선택된 이미지
  Map<String, IfdTag>? _metadata; // 메타데이터 저장
  List<ImageLabel>? _labels; // 이미지 라벨링 결과 저장
  List<TextBlock>? _textBlocks; // 텍스트 블록 저장
  final MLImageLabelingService _mlService = MLImageLabelingService();
  final MLTextRecognitionService _textService =
      MLTextRecognitionService(); // 텍스트 인식 서비스

  // 갤러리에서 이미지 가져오기
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _metadata = null; // 새로운 이미지 선택 시 메타데이터 초기화
        _labels = null; // 새로운 이미지 선택 시 라벨 초기화
      });
      _extractMetadata();
      _analyzeImage(); // 이미지 분석 추가
      _analyzeText(); // 텍스트 분석 추가
    }
  }

  // 이미지 라벨 분석
  Future<void> _analyzeImage() async {
    if (_image == null) return;

    try {
      final labels = await _mlService.processImage(_image!);
      setState(() {
        _labels = labels;
      });
    } catch (e) {
      print('Error analyzing image: $e');
    }
  }

  Future<void> _analyzeText() async {
    if (_image == null) return;

    try {
      final textBlocks = await _textService.processImage(_image!);
      setState(() {
        _textBlocks = textBlocks;
      });
    } catch (e) {
      print('Error recognizing text: $e');
    }
  }

  Widget _buildTextList() {
    if (_textBlocks == null || _textBlocks!.isEmpty) {
      return const Center(
        child: Text(
          'No text recognized',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView(
      children: _textBlocks!.map((block) {
        return Text(block.text
            // subtitle: Text('Bounding Box: ${block.boundingBox.toString()}'),
            );
      }).toList(),
    );
  }

  // 메타데이터 추출
  Future<void> _extractMetadata() async {
    try {
      final bytes = await _image!.readAsBytes();
      final exifData = await readExifFromBytes(Uint8List.fromList(bytes));

      if (exifData.isNotEmpty) {
        setState(() {
          _metadata = exifData;
        });
      } else {
        print("No EXIF metadata found.");
      }
    } catch (e) {
      print('Error extracting metadata: $e');
    }
  }

  // 라벨 출력 위젯
  Widget _buildLabelsList() {
    if (_labels == null || _labels!.isEmpty) {
      return const Center(
        child: Text(
          'No labels detected',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView(
      children: _labels!.map((label) {
        return ListTile(
          title: Text(label.label),
          subtitle: Text('Confidence: ${label.confidence.toStringAsFixed(2)}'),
        );
      }).toList(),
    );
  }

  // 메타데이터 출력 위젯
  Widget _buildMetadataList() {
    if (_metadata == null || _metadata!.isEmpty) {
      return const Center(
        child: Text(
          'No metadata available',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView(
      children: _metadata!.entries.map((entry) {
        return ListTile(
          title: Text(entry.key),
          subtitle: Text(entry.value.toString()),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Metadata & Label Viewer'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _image != null
                ? Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  )
                : const Placeholder(
                    fallbackHeight: 200,
                    color: Colors.grey,
                  ),
          ),
          ElevatedButton.icon(
            onPressed: _getImage,
            icon: const Icon(Icons.image),
            label: const Text('Choose Image'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Labels:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildLabelsList(),
            ),
          ),
          const Divider(),
          const Text(
            'Text Recognition:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTextList(),
            ),
          ),
          const Divider(),
          Column(
            children: [
              Text("주소지 : "),
              if (_metadata != null)
                FutureBuilder(
                  future:
                      AddressService.getAddress(convertGPSDataToXY(_metadata!)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return SizedBox();
                    }
                    if (!snapshot.hasData) return SizedBox();
                    if (snapshot.hasError) return SizedBox();
                    return Text(snapshot.data ?? "");
                  },
                ),
            ],
          ),
          const Text(
            'Metadata:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMetadataList(),
            ),
          ),
        ],
      ),
    );
  }

  String convertGPSDataToXY(Map<String, dynamic> metadata) {
    try {
      // 메타데이터에서 GPSLatitude, GPSLongitude, Ref 정보 가져오기
      final IfdTag gpsLatitude = metadata['GPS GPSLatitude'];
      final IfdTag gpsLatitudeRef = metadata['GPS GPSLatitudeRef'];
      final IfdTag gpsLongitude = metadata['GPS GPSLongitude'];
      final IfdTag gpsLongitudeRef = metadata['GPS GPSLongitudeRef'];

      if (gpsLatitude != null &&
          gpsLongitude != null &&
          gpsLatitudeRef != null &&
          gpsLongitudeRef != null) {
        // 위도와 경도를 소수점 형태로 변환
        return convertGPSIfdTagToXY(gpsLatitude, gpsLatitudeRef.printable,
            gpsLongitude, gpsLongitudeRef.printable);
      } else {
        return "";
      }
    } catch (e) {
      log("ERROR : $e");
      return "";
    }
  }

  String convertGPSIfdTagToXY(IfdTag latitudeTag, String latitudeRef,
      IfdTag longitudeTag, String longitudeRef) {
    try {
      // IfdTag에서 values를 추출해 변환
      double latitude = _convertDMSToDecimal(latitudeTag.values, latitudeRef);
      double longitude =
          _convertDMSToDecimal(longitudeTag.values, longitudeRef);

      // "경도,위도" 문자열로 반환
      return "${longitude.toStringAsFixed(6)},${latitude.toStringAsFixed(6)}";
    } catch (e) {
      return "Error parsing GPS data: $e";
    }
  }

  double _convertDMSToDecimal(IfdValues dmsIfdValues, String ref) {
    List<dynamic> dms = dmsIfdValues.toList();
    // IfdRatios 리스트에서 값을 추출하여 degrees, minutes, seconds 계산
    double degrees = dms[0].numerator / dms[0].denominator;
    double minutes = dms[1].numerator / dms[1].denominator;
    double seconds = dms[2].numerator / dms[2].denominator;

    // DMS를 소수점(decimal)으로 변환
    double decimal = degrees + (minutes / 60) + (seconds / 3600);

    // Ref가 S 또는 W인 경우 음수 처리
    if (ref == 'S' || ref == 'W') {
      decimal = -decimal;
    }
    return decimal;
  }
}
