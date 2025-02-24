import 'package:async/async.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:photo_manager/photo_manager.dart';

class PhotoGridViewWidget extends StatefulWidget {
  final List<AssetEntity> images;
  final bool isImageCrop;
  const PhotoGridViewWidget({
    required this.images,
    super.key,
    required this.isImageCrop,
  });

  @override
  State<PhotoGridViewWidget> createState() => _PhotoGridViewWidgetState();
}

class _PhotoGridViewWidgetState extends State<PhotoGridViewWidget> {
  final ImagePicker picker = ImagePicker();

  onTapGridViewImage({File? file}) async {
    /// 선택된 File이 없다면 카메라로 촬영을 해서 가져온다.
    file ??= await getCameraImage();
    if (file == null) return;

    if (!mounted) return;

    if (!widget.isImageCrop) {
      noImageCrop(file);
      return;
    }

    // final result = await context.pushNamed('PhotoImageCrop', extra: file);
    // if (result is! File) return;

    // if (!mounted) return;

    // Navigator.pop(context, result);
  }

  noImageCrop(File file) {
    Navigator.pop(context, file);
  }

  ///카메라 실행하는 메소드
  Future<File?> getCameraImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 4, mainAxisSpacing: 4, crossAxisCount: 3),
        children: [
          GestureDetector(
            onTap: onTapGridViewImage,
            child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '카메라',
                  )
                ],
              ),
            ),
          ),
          ...widget.images.map((AssetEntity e) {
            // return
            // Future<File?>  imageFile = memoizer ;

            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FutureBuilder(
                  future: _getImageFileJustOnce(e.file),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CupertinoActivityIndicator();
                    }
                    if (snapshot.hasError) {}
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    File imageFile = snapshot.data as File;
                    // imageCache.evict(FileImage(imageFile));
                    return GestureDetector(
                      onTap: () => onTapGridViewImage(file: imageFile),
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
            );
          }),
        ]);
  }

  Future _getImageFileJustOnce(Future<File?> file) =>
      AsyncMemoizer().runOnce(() async => await file);
}
