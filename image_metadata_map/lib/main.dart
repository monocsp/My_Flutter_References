import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_metadata_map/%08ml_text_recog_service.dart';
import 'package:image_metadata_map/api_result_widget.dart';
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
  // 기본 이미지 및 분석 결과 변수들
  File? _image;
  Map<String, IfdTag>? _metadata;
  List<ImageLabel>? _labels;
  List<TextBlock>? _textBlocks;
  int? _labelProcessingTime;

  // 객체 감지를 위한 변수들
  String? _selectedImagePath;
  ui.Image? _uiImage;
  List<DetectedObject>? _detectedObjects;

  // ML 서비스 인스턴스 (각 서비스는 별도로 구현되어 있다고 가정)
  final MLImageLabelingService _mlService = MLImageLabelingService();
  final MLTextRecognitionService _textService = MLTextRecognitionService();

  /// 갤러리에서 이미지를 선택하고, 메타데이터, 라벨, 텍스트, 객체 감지를 병렬로 처리
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // 새로운 이미지 선택 시 모든 변수 초기화
      setState(() {
        _image = File(pickedImage.path);
        _metadata = null;
        _labels = null;
        _textBlocks = null;
        _labelProcessingTime = null;
        _selectedImagePath = null;
        _uiImage = null;
        _detectedObjects = null;
      });
      // 네 가지 작업을 병렬 처리
      await Future.wait([
        _extractMetadata(),
        _analyzeImage(),
        _analyzeText(),
        detectObjects(),
      ]);
    }
  }

  /// 이미지 라벨 분석 (처리 시간 측정 포함)
  Future<void> _analyzeImage() async {
    if (_image == null) return;
    try {
      final stopwatch = Stopwatch()..start();
      final labels = await _mlService.processImage(_image!);
      stopwatch.stop();
      setState(() {
        _labels = labels;
        _labelProcessingTime = stopwatch.elapsedMilliseconds;
      });
    } catch (e) {
      print('Error analyzing image: $e');
    }
  }

  /// 텍스트 인식 처리
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

  /// EXIF 메타데이터 추출
  Future<void> _extractMetadata() async {
    if (_image == null) return;
    try {
      final bytes = await _image!.readAsBytes();
      final Map<String, IfdTag> exifData =
          await readExifFromBytes(Uint8List.fromList(bytes));
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

  /// Google ML Kit를 이용한 객체 감지
  Future<void> detectObjects() async {
    final inputImage = InputImage.fromFilePath(_image!.path);
    final objectDetector = ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true,
      ),
    );
    final List<DetectedObject> objects =
        await objectDetector.processImage(inputImage);

    // CustomPainter에 사용할 ui.Image로 디코딩
    final data = await File(_image!.path).readAsBytes();
    final uiImage = await decodeImageFromList(data);

    setState(() {
      _detectedObjects = objects;
      _uiImage = uiImage;
    });
  }

  /// 라벨 결과 출력 위젯 (처리 시간도 표시)
  Widget _buildLabelsList() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                const TextSpan(text: 'milisec: '),
                TextSpan(
                  text: _labelProcessingTime?.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        if (_labels == null || _labels!.isEmpty)
          const Center(
            child: Text(
              'No labels detected',
              style: TextStyle(fontSize: 16),
            ),
          )
        else
          ..._labels!.map((label) {
            return ListTile(
              title: Text(label.label),
              subtitle:
                  Text('Confidence: ${label.confidence.toStringAsFixed(2)}'),
            );
          }).toList(),
      ],
    );
  }

  /// 텍스트 인식 결과 출력 위젯
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
      children: _textBlocks!.map((block) => Text(block.text)).toList(),
    );
  }

  /// 메타데이터 출력 위젯
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

  Widget buildObjectDetectionList() {
    if (_detectedObjects == null || _detectedObjects!.isEmpty) {
      return const Center(child: Text('No objects detected in image'));
    }

    return ListView(
      children: _detectedObjects!.map((detectedObj) {
        if (detectedObj.labels.isEmpty) {
          return const SizedBox();
        }
        // 각 객체에서 confidence가 가장 높은 label 선택
        final bestLabel = detectedObj.labels.reduce(
          (a, b) => a.confidence > b.confidence ? a : b,
        );
        return ListTile(
          title: Text(
              '${bestLabel.confidence.toStringAsFixed(2)} ${bestLabel.text}'),
        );
      }).toList(),
    );
  }

  // /// 객체 감지 결과를 CustomPainter로 표시하는 위젯
  // Widget buildObjectDetectionWidget() {
  //   if (_selectedImagePath == null ||
  //       _uiImage == null ||
  //       _detectedObjects == null) {
  //     return const Center(child: Text('No object detected in image'));
  //   }
  //   return FittedBox(
  //     child: SizedBox(
  //       width: _uiImage!.width.toDouble(),
  //       height: _uiImage!.height.toDouble(),
  //       child: CustomPaint(
  //         painter: ObjectPainter(_uiImage!, _detectedObjects!),
  //       ),
  //     ),
  //   );
  // }

  /// GPS 메타데이터를 좌표 문자열로 변환 (예: "경도,위도")
  String convertGPSDataToXY(Map<String, dynamic> metadata) {
    try {
      final IfdTag gpsLatitude = metadata['GPS GPSLatitude'];
      final IfdTag gpsLatitudeRef = metadata['GPS GPSLatitudeRef'];
      final IfdTag gpsLongitude = metadata['GPS GPSLongitude'];
      final IfdTag gpsLongitudeRef = metadata['GPS GPSLongitudeRef'];
      if (gpsLatitude != null &&
          gpsLongitude != null &&
          gpsLatitudeRef != null &&
          gpsLongitudeRef != null) {
        return convertGPSIfdTagToXY(
          gpsLatitude,
          gpsLatitudeRef.printable,
          gpsLongitude,
          gpsLongitudeRef.printable,
        );
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
      double latitude = _convertDMSToDecimal(latitudeTag.values, latitudeRef);
      double longitude =
          _convertDMSToDecimal(longitudeTag.values, longitudeRef);
      return "${longitude.toStringAsFixed(6)},${latitude.toStringAsFixed(6)}";
    } catch (e) {
      return "Error parsing GPS data: $e";
    }
  }

  double _convertDMSToDecimal(IfdValues dmsIfdValues, String ref) {
    List<dynamic> dms = dmsIfdValues.toList();
    double degrees = dms[0].numerator / dms[0].denominator;
    double minutes = dms[1].numerator / dms[1].denominator;
    double seconds = dms[2].numerator / dms[2].denominator;
    double decimal = degrees + (minutes / 60) + (seconds / 3600);
    if (ref == 'S' || ref == 'W') {
      decimal = -decimal;
    }
    return decimal;
  }

  /// getCombinedData()
  /// 1. EXIF 메타데이터에서 생성일자
  /// 2. 이미지 라벨링 결과 상위 2개 (2개 미만이면 전부)
  /// 3. 객체 감지 결과에서 각 객체의 최고 신뢰도 라벨의 text
  List<String> getCombinedData() {
    List<String> result = [];

    // 1. EXIF 메타데이터에서 생성일자 추출
    if (_metadata != null && _metadata!.isNotEmpty) {
      String? dateTaken;
      // 우선 EXIF DateTimeOriginal (태그 36867)를 시도
      if (_metadata!.containsKey('EXIF DateTimeOriginal')) {
        // IfdTag는 보통 printable 프로퍼티를 제공하므로 이를 사용하거나 toString()
        dateTaken = _metadata!['EXIF DateTimeOriginal']?.printable ??
            _metadata!['EXIF DateTimeOriginal'].toString();
      } else if (_metadata!.containsKey('DateTime')) {
        // 없으면 기본 DateTime 키 사용 (태그 306)
        dateTaken = _metadata!['DateTime']?.printable ??
            _metadata!['DateTime'].toString();
      }
      if (dateTaken != null && dateTaken.isNotEmpty) {
        result.add(dateTaken);
      }
    }

    // 2. 이미지 라벨링 결과에서 상위 2개의 라벨 추출
    if (_labels != null && _labels!.isNotEmpty) {
      // 신뢰도를 기준으로 내림차순 정렬
      List<ImageLabel> sortedLabels = List.from(_labels!);
      sortedLabels.sort((a, b) => b.confidence.compareTo(a.confidence));
      int count = sortedLabels.length >= 2 ? 2 : sortedLabels.length;
      for (int i = 0; i < count; i++) {
        result.add(sortedLabels[i].label);
      }
    }

    // 3. 객체 감지 결과에서 각 객체의 최고 신뢰도 라벨 텍스트 추출
    if (_detectedObjects != null && _detectedObjects!.isNotEmpty) {
      for (DetectedObject obj in _detectedObjects!) {
        if (obj.labels.isNotEmpty) {
          // 각 객체에서 confidence가 가장 높은 라벨 선택
          Label bestLabel =
              obj.labels.reduce((a, b) => a.confidence > b.confidence ? a : b);
          result.add(bestLabel.text);
        }
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Metadata & Label Viewer'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          // height: MediaQuery.sizeOf(context).height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 선택된 이미지 표시 영역
                SizedBox(
                  height: 200,
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : const Placeholder(
                          fallbackHeight: 200, color: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: _getImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Choose Image'),
                ),
                const SizedBox(height: 8),
                // 라벨 결과 출력 영역
                const Text('Labels:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 200, child: _buildLabelsList()),
                const Divider(),
                // 텍스트 인식 결과 출력 영역
                const Text('Text Recognition:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 200, child: _buildTextList()),
                const Divider(),
                // 주소지 (메타데이터 기반)
                Column(
                  children: [
                    const Text("주소지 : "),
                    if (_metadata != null)
                      FutureBuilder(
                        future: AddressService.getAddress(
                            convertGPSDataToXY(_metadata!)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const SizedBox();
                          }
                          if (!snapshot.hasData || snapshot.hasError)
                            return const SizedBox();
                          return Text(snapshot.data ?? "");
                        },
                      ),
                  ],
                ),
                const Text('Metadata:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 200, child: _buildMetadataList()),
                Divider(),
                const Text('Image Object Detection:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 200, child: buildObjectDetectionList()),

                // 이미지가 선택된 경우에만 ApiResultWidget 노출
                if (_image != null)
                  SizedBox(
                      height: 200,
                      child: ApiResultWidget(params: getCombinedData())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
