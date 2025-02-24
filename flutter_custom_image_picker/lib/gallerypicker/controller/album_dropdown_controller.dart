import 'package:flutter_custom_image_picker/gallerypicker/domain/album_dropdown_data.dart';
import 'package:flutter_custom_image_picker/gallerypicker/domain/gallery_photo_album_data.dart';

import 'package:rxdart/rxdart.dart';

class AlbumDropdownController {
  AlbumDropdownData albumDropdownData;
  // GalleryPhotoAlbumData? galleryPhotoAlbumData;
  // final List<GalleryPhotoAlbumData> galleryPhotoAlbumDatas;
  late BehaviorSubject publishSubject;
  Function(AlbumDropdownData galleryPhotoAlbumData)? controllerListener;

  AlbumDropdownController({required this.albumDropdownData}) {
    _statusRx();
  }

  _statusRx() {
    publishSubject = BehaviorSubject.seeded(albumDropdownData);
  }

  updateData(AlbumDropdownData albumDropdownData) {
    this.albumDropdownData = albumDropdownData;
    publishSubject.sink.add(albumDropdownData);
  }

  Stream get stream => publishSubject.stream;

  GalleryPhotoAlbumData? get getSelectedData => albumDropdownData.selectedData;

  List<GalleryPhotoAlbumData> get getGalleryPhotoAlbumDatas =>
      albumDropdownData.galleryPhotoAlbumDatas;

  /// [galleryPhotoAlbumData] 변경될 때 마다 호출된다.
  /// [galleryPhotoAlbumData] 변경되지 않을때는 호출되지 않는다.
  addListener(Function(AlbumDropdownData? albumDropdownData) listener) =>
      controllerListener = listener;

  dispose() => publishSubject.close();
}
