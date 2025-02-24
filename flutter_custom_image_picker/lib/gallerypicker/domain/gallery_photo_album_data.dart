import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

part 'gallery_photo_album_data.freezed.dart';

@freezed
class GalleryPhotoAlbumData<T> with _$GalleryPhotoAlbumData {
  const factory GalleryPhotoAlbumData(
      {required String id,
      required String name,
      T? firstImageAssetEntity,
      int? imageCount}) = _GalleryPhotoAlbumData;

  factory GalleryPhotoAlbumData.empty() =>
      const GalleryPhotoAlbumData(id: '', name: '');
}
