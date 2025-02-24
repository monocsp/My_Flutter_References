import 'package:flutter_custom_image_picker/gallerypicker/domain/gallery_photo_album_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_dropdown_data.freezed.dart';

@freezed
class AlbumDropdownData with _$AlbumDropdownData {
  const factory AlbumDropdownData({
    GalleryPhotoAlbumData? selectedData,
    required List<GalleryPhotoAlbumData> galleryPhotoAlbumDatas,
  }) = _AlbumDropdownData;

  factory AlbumDropdownData.empty() =>
      const AlbumDropdownData(galleryPhotoAlbumDatas: []);
}
