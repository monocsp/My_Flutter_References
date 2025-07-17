import 'package:flutter/material.dart';
import 'package:flutter_gallery_gridview/gallery/image_picker_widget.dart';
import 'package:photo_manager/photo_manager.dart';

/// FutureBuilder를 통해 앨범(폴더) 목록을 로드하고,
/// 사진 접근 권한 확인 및 요청 후 권한이 없으면 안내 메시지를 보여주는 위젯
class GalleryImagePickerPage extends StatelessWidget {
  /// - 매개변수로 최대 선택 이미지 수(maxSelectableCount) 받는다.
  final int maxSelectableCount;

  /// 모든 선택 완료 시 callback하는 매소드
  final Function? resultImageList;

  const GalleryImagePickerPage(
      {super.key, required this.maxSelectableCount, this.resultImageList});

  /// PhotoManager를 이용해 모든 이미지 앨범(폴더)을 비동기로 가져오며,
  /// 사진 접근 권한이 없으면 권한 요청 후, 권한이 부여되지 않으면 예외를 발생시킵니다.
  Future<List<AssetPathEntity>> _fetchAlbums() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      // 권한이 부여되지 않았다면 예외 발생 -> FutureBuilder에서 에러 상태로 표시됩니다.
      throw Exception("사진 접근 권한이 부여되지 않았습니다.\n앱 설정에서 권한을 허용해주세요.");
    }
    return await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AssetPathEntity>>(
      future: _fetchAlbums(),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중일 때: 원하는 로딩 위젯(여기서는 CircularProgressIndicator)
          child = Container(
            key: const ValueKey("loading"),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // 에러 발생 시: 권한 안내 메시지를 포함하여 표시
          child = Container(
            key: const ValueKey("error"),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Text(
              "권한 설정이 필요합니다.\n${snapshot.error}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          // 성공 시: 앨범 목록을 하위 성공 위젯(ImagePickerPage)에 전달 (ImagePickerPage는 별도로 정의되어 있다고 가정)
          child = ImagePickerWidget(
            albums: snapshot.data!,
            maxSelectable: maxSelectableCount,
            resultSelectedImages: resultImageList,
          );
        } else {
          child = Container(key: const ValueKey("none"));
        }
        // AnimatedSwitcher를 사용해 150ms 동안 상태 전환 애니메이션(FadeTransition)
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: child,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    );
  }
}
