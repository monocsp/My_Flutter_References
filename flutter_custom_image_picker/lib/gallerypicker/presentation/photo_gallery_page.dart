import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_image_picker/gallerypicker/controller/album_dropdown_controller.dart';
import 'package:flutter_custom_image_picker/gallerypicker/domain/album_dropdown_data.dart';
import 'package:flutter_custom_image_picker/gallerypicker/domain/gallery_photo_album_data.dart';
import 'package:flutter_custom_image_picker/gallerypicker/widgets/album_dropdown_widget.dart';
import 'package:flutter_custom_image_picker/gallerypicker/widgets/photo_gridview.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoGallerPage extends StatefulWidget {
  final bool isImageCrop;
  const PhotoGallerPage({
    super.key,
    required this.isImageCrop,
  });

  @override
  State<PhotoGallerPage> createState() => _PhotoGallerPageState();
}

class _PhotoGallerPageState extends State<PhotoGallerPage>
    with WidgetsBindingObserver {
  /// 직전까지 움직인 scroll 위치
  double justUpdateScrollPosition = 0.0;

  bool isDropdownOpen = false;

  AlbumDropdownController albumDropdownController =
      AlbumDropdownController(albumDropdownData: AlbumDropdownData.empty());

  /// Asset path 리스트
  List<AssetPathEntity>? _paths;

  List<AssetEntity> _images = [];
  int _currentPage = 0;

  /// Permission page 갔다왔을 때 한번 더 확인.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!isThereCurrentDialogShowing(context)) {
          checkPermission();
        }
        break;

      default:
        return;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> checkPermission() async {
    bool isGrant = Platform.isAndroid
        ? await checkAndroidPermission()
        : Platform.isIOS
            ? await checkIoSPermission()
            : false;
    if (isGrant) {
      await getGalleryPhotoAlbumData();
    } else {
      Permission.photos.request();

      // if (!mounted) return;
      // context.showAskAgainWhenPermissionDenied(
      //     text: '사진 및 이미지',
      //     goToSettingPage: () {
      //       context.pop(true);
      //       PhotoManager.openSetting();
      //     });

      // await PhotoManager.openSetting();
    }
  }

  /// 현재 route push가 된 게 있는지 확인하는 메소드
  isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  Future<void> getGalleryPhotoAlbumData() async {
    _paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );
    log("_path : ${_paths}");

    // List<GalleryPhotoAlbumData> results = await Future.wait([
    //   for (AssetPathEntity path in _paths!) getAlbumHeaderAssetEntity(path)
    // ]);
    List<GalleryPhotoAlbumData> results = await Future.wait([
      for (AssetPathEntity path in _paths!) getAlbumHeaderAssetEntity(path)
    ]);

    albumDropdownController = AlbumDropdownController(
        albumDropdownData: AlbumDropdownData(
            galleryPhotoAlbumDatas: results, selectedData: results[0]));

    // albumDropdownController = AlbumDropdownController(
    //     albumDropdownData: AlbumDropdownData(
    //         galleryPhotoAlbumDatas: results, selectedData: results[0]));

    await getPhotos(galleryPhotoAlbumDataChange: true);
  }

  // /// dropdown 헤더이미지 설정하는 메소드
  // Future<GalleryPhotoAlbumData> getAlbumHeaderAssetEntity(
  //   AssetPathEntity assetPathEntity,
  // ) async {
  //   if (assetPathEntity.isAll) {
  //     AssetEntity? assetEntity = (await _paths!.first.getAssetListPaged(
  //       page: _currentPage,
  //       size: 1,
  //     ))[0];
  //     return GalleryPhotoAlbumData(
  //         id: assetPathEntity.id,
  //         name: '모든사진',
  //         firstImageAssetEntity: await assetEntity.file,
  //         imageCount: await PhotoManager.getAssetCount());
  //   }

  Future<GalleryPhotoAlbumData> getAlbumHeaderAssetEntity(
    AssetPathEntity assetPathEntity,
  ) async {
    // 1) 해당 앨범에서 한 장만 가져오기
    final assetList = await assetPathEntity.getAssetListPaged(page: 0, size: 1);
    final count = await assetPathEntity.assetCountAsync;

    // 2) 앨범이 비어있으면 headerImage = null
    if (assetList.isEmpty) {
      return GalleryPhotoAlbumData(
        id: assetPathEntity.id,
        name: assetPathEntity.isAll ? '모든사진' : assetPathEntity.name,
        firstImageAssetEntity: null,
        imageCount: count,
      );
    }

    // 3) 비어있지 않으면 첫 번째 아이템 파일로 가져오기
    final File? headerImageFile = await assetList[0].file;

    return GalleryPhotoAlbumData(
      id: assetPathEntity.id,
      name: assetPathEntity.isAll ? '모든사진' : assetPathEntity.name,
      firstImageAssetEntity: headerImageFile,
      imageCount: count,
    );
  }

  /// dropdown 헤더이미지 설정하는 메소드
  // Future<GalleryPhotoAlbumData> getAlbumHeaderAssetEntity(
  //   AssetPathEntity assetPathEntity,
  // ) async {
  //   if (assetPathEntity.isAll) {
  //     final list = await _paths!.first.getAssetListPaged(
  //       page: _currentPage,
  //       size: 1,
  //     );

  //     if (list.isEmpty) {
  //       // 가져온 에셋이 하나도 없으면, 굳이 [0]에 접근해서 썸네일을 구할 수 없음
  //       return const GalleryPhotoAlbumData(
  //         id: '',
  //         name: '',
  //         firstImageAssetEntity: null,
  //         imageCount: 0,
  //       );
  //     }

  //     AssetEntity? assetEntity = list[0];
  //     return GalleryPhotoAlbumData(
  //       id: assetPathEntity.id,
  //       name: '모든사진',
  //       firstImageAssetEntity: await assetEntity.file,
  //       imageCount: await PhotoManager.getAssetCount(),
  //     );
  //   }

  //   final AssetPathEntity filttedAssetPathEntity =
  //       _paths!.singleWhere((element) => element.id == assetPathEntity.id);

  //   final Future<List<AssetEntity>> loadImagesFuture =
  //       filttedAssetPathEntity.getAssetListPaged(
  //     page: _currentPage,
  //     size: 1,
  //   );

  //   final Future<int> assetCountFuture = filttedAssetPathEntity.assetCountAsync;

  //   final List<dynamic> results =
  //       await Future.wait([loadImagesFuture, assetCountFuture]);

  //   final List<AssetEntity> loadImages = results[0];
  //   final int assetCount = results[1];

  //   File? headerImage = await loadImages[0].file;

  //   return GalleryPhotoAlbumData(
  //       id: assetPathEntity.id,
  //       name: assetPathEntity.name,
  //       firstImageAssetEntity: headerImage,
  //       imageCount: assetCount);
  // }

  Future<void> getPhotos({
    bool galleryPhotoAlbumDataChange = false,
  }) async {
    GalleryPhotoAlbumData galleryPhotoAlbumData =
        albumDropdownController.getSelectedData ??
            albumDropdownController.getGalleryPhotoAlbumDatas[0];
    galleryPhotoAlbumDataChange ? _currentPage = 0 : _currentPage++;
    if (galleryPhotoAlbumDataChange) {
      justUpdateScrollPosition = 0.0;
    }

    final loadImages = await _paths!
        .singleWhere((element) => element.id == galleryPhotoAlbumData.id)
        .getAssetListPaged(
          page: _currentPage,
          size: 20,
        );

    /// 기존 앨범에서 더이상 가져오지 않는다면 setState안한다.
    if (!galleryPhotoAlbumDataChange) {
      if (loadImages.isEmpty) return;
    }

    setState(() {
      if (galleryPhotoAlbumDataChange) {
        _images = loadImages;
      } else {
        _images.addAll(loadImages);
      }
    });
  }

  onTapAppBarLeadingIcon() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: AppbarLeadingIcon(
        //     onTap: onTapAppBarLeadingIcon,
        //     iconPath: 'assets/image/icons/close.svg'),
        title: Container(
            child: albumDropdownController.getGalleryPhotoAlbumDatas.isNotEmpty
                ? AlbumDropdownWidget(
                    controller: albumDropdownController,
                  )
                : const SizedBox()),
      ),
      body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            final scrollPixels =
                scroll.metrics.pixels / scroll.metrics.maxScrollExtent;

            /// 움직이지 않았다면, noti주지않는다.
            if (justUpdateScrollPosition == scroll.metrics.pixels) {
              return false;
            }
            if (scrollPixels > 0.9) {
              getPhotos();
              justUpdateScrollPosition = scroll.metrics.pixels;
            }

            return false;
          },
          child: SafeArea(
            child: _paths == null
                ? const Center(child: CircularProgressIndicator())
                : PhotoGridViewWidget(
                    isImageCrop: widget.isImageCrop,
                    images: _images,
                  ),
          )),
    );
  }

  Future<bool> checkAndroidPermission() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    int androidVersion = int.tryParse(androidInfo.version.release) ?? 11;
    bool isGrant = true;

    if (androidVersion > 12) {
      // bool isAudioGrant = await Permission.audio.isGranted;
      bool isVideosGrant = await Permission.videos.isGranted;
      bool isPhotosGrant = await Permission.photos.isGranted;

      isGrant = isGrant && isVideosGrant && isPhotosGrant;
    } else {
      isGrant = isGrant && await Permission.storage.isGranted;
    }
    return isGrant;
  }

  Future<bool> checkIoSPermission() async {
    IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;

    double iosVersion = double.tryParse(iosInfo.systemVersion) ?? 11.0;
    bool isGrant = true;
    isGrant = isGrant && await Permission.photos.isGranted;

    return isGrant;
  }
}
