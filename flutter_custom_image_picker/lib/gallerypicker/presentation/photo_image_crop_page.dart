import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PhotoImageCropPage extends StatefulWidget {
  final File file;
  const PhotoImageCropPage({super.key, required this.file});

  @override
  State<PhotoImageCropPage> createState() => _PhotoImageCropPageState();
}

class _PhotoImageCropPageState extends State<PhotoImageCropPage> {
  final _cropController = CropController();

  late File _pickedFile;

  bool isTouchIgnore = false;

  late Future futureConvertedFileToUint8List;

  bool isImageCropLoading = false;

  @override
  void initState() {
    _pickedFile = widget.file;

    /// Future 단 한번만 돌기위해
    futureConvertedFileToUint8List = convertFileToUint8List(_pickedFile);

    super.initState();
  }

  Future<File> saveCroppedImageFile(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    File file =
        await File('${tempDir.path}/crop_${basename(_pickedFile.path)}.png')
            .create(exclusive: false, recursive: true);
    return file..writeAsBytesSync(data);
  }

  Future onCrop(BuildContext context, CropResult image) async {
    // File result = await saveCroppedImageFile(image);
    // if (!mounted) return;
    // context.pop(result);
  }

  onTapCompleteButton() async {
    if (isTouchIgnore) return;
    setState(() {
      isImageCropLoading = true;
    });
    _cropController.crop();
    setState(() {
      isTouchIgnore = true;
    });
  }

  Future convertFileToUint8List(File file) async => file.readAsBytes();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isImageCropLoading,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            actions: [
              TextButton(
                  onPressed: () => onTapCompleteButton(),
                  child: Text(
                    '완료',
                  ))
            ],
          ),
          body: FutureBuilder(
              future: futureConvertedFileToUint8List,
              builder: (context, snapshot) {
                bool isLoading = false;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  isLoading = true;
                } else {
                  isLoading = false;
                }
                return IgnorePointer(
                  ignoring: isLoading ? true : isTouchIgnore,
                  child: Stack(
                    children: [
                      Crop(
                          image: widget.file.readAsBytesSync(),
                          baseColor: Colors.black,
                          maskColor: Colors.black.withOpacity(0.7),
                          radius: 12,
                          cornerDotBuilder: (a, b) => const SizedBox.shrink(),
                          // fixArea: true,
                          aspectRatio: 320 / 215,
                          // initialSize: 1,
                          // initialAreaBuilder: (rect) => Rect.fromLTRB(
                          //     rect.left + 20.w,
                          //     rect.top + 250.h,
                          //     rect.right - 20.w,
                          //     rect.bottom - 250.h),
                          controller: _cropController,
                          interactive: true,
                          onCropped: (CropResult value) async =>
                              onCrop(context, value)),
                      Positioned(
                        top: 480,
                        width: 320,
                        left: 20,
                        child: Text(
                          '명함의 영역 안에 들어오도록\n이미지를 조절해주세요.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      isLoading || isImageCropLoading
                          ? Positioned(
                              // top: context.height,
                              width: 20,
                              height: 20,
                              // left: context.width,
                              child: Container(
                                alignment: Alignment.center,
                                // child: context.showLoadingWidget()
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                );
              })),
    );
  }
}
