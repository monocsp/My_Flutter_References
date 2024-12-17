// import 'dart:io';

// import 'package:exif/exif.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const ImagePickerWithExif(),
//     );
//   }
// }

// class ImagePickerWithExif extends StatefulWidget {
//   const ImagePickerWithExif({super.key});

//   @override
//   _ImagePickerWithExifState createState() => _ImagePickerWithExifState();
// }

// class _ImagePickerWithExifState extends State<ImagePickerWithExif> {
//   File? _selectedImage;
//   Map<String, IfdTag> _metadata = {};

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile == null) return;

//     setState(() {
//       _selectedImage = File(pickedFile.path);
//     });

//     // EXIF 메타데이터 읽기
//     final bytes = await pickedFile.readAsBytes();
//     final data = await readExifFromBytes(Uint8List.fromList(bytes));

//     if (data.isNotEmpty) {
//       setState(() {
//         _metadata = data;
//       });
//     } else {
//       setState(() {
//         _metadata = {};
//       });
//       print("No EXIF information found");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Picker & EXIF Metadata'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: _selectedImage == null
//                   ? const Text('이미지를 선택해주세요.')
//                   : Image.file(_selectedImage!),
//             ),
//           ),
//           ElevatedButton.icon(
//             onPressed: _pickImage,
//             icon: const Icon(Icons.add),
//             label: const Text('이미지 가져오기'),
//           ),
//           const SizedBox(height: 10),
//           if (_metadata.isNotEmpty)
//             Expanded(
//               child: ListView(
//                 children: _metadata.entries.map((entry) {
//                   return ListTile(
//                     title: Text(entry.key),
//                     subtitle: Text(entry.value.toString()),
//                   );
//                 }).toList(),
//               ),
//             ),
//           if (_metadata.isEmpty && _selectedImage != null)
//             const Text('메타데이터를 찾을 수 없습니다.'),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';

void main() {
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

  // 갤러리에서 이미지 가져오기
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _metadata = null; // 새로운 이미지 선택 시 메타데이터 초기화
      });
      _extractMetadata();
    }
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
        title: const Text('Image Metadata Viewer'),
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
}
