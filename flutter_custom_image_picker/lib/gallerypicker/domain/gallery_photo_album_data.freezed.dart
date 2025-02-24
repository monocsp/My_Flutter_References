// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_photo_album_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GalleryPhotoAlbumData<T> {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  T? get firstImageAssetEntity => throw _privateConstructorUsedError;
  int? get imageCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GalleryPhotoAlbumDataCopyWith<T, GalleryPhotoAlbumData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryPhotoAlbumDataCopyWith<T, $Res> {
  factory $GalleryPhotoAlbumDataCopyWith(GalleryPhotoAlbumData<T> value,
          $Res Function(GalleryPhotoAlbumData<T>) then) =
      _$GalleryPhotoAlbumDataCopyWithImpl<T, $Res, GalleryPhotoAlbumData<T>>;
  @useResult
  $Res call(
      {String id, String name, T? firstImageAssetEntity, int? imageCount});
}

/// @nodoc
class _$GalleryPhotoAlbumDataCopyWithImpl<T, $Res,
        $Val extends GalleryPhotoAlbumData<T>>
    implements $GalleryPhotoAlbumDataCopyWith<T, $Res> {
  _$GalleryPhotoAlbumDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? firstImageAssetEntity = freezed,
    Object? imageCount = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      firstImageAssetEntity: freezed == firstImageAssetEntity
          ? _value.firstImageAssetEntity
          : firstImageAssetEntity // ignore: cast_nullable_to_non_nullable
              as T?,
      imageCount: freezed == imageCount
          ? _value.imageCount
          : imageCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GalleryPhotoAlbumDataImplCopyWith<T, $Res>
    implements $GalleryPhotoAlbumDataCopyWith<T, $Res> {
  factory _$$GalleryPhotoAlbumDataImplCopyWith(
          _$GalleryPhotoAlbumDataImpl<T> value,
          $Res Function(_$GalleryPhotoAlbumDataImpl<T>) then) =
      __$$GalleryPhotoAlbumDataImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {String id, String name, T? firstImageAssetEntity, int? imageCount});
}

/// @nodoc
class __$$GalleryPhotoAlbumDataImplCopyWithImpl<T, $Res>
    extends _$GalleryPhotoAlbumDataCopyWithImpl<T, $Res,
        _$GalleryPhotoAlbumDataImpl<T>>
    implements _$$GalleryPhotoAlbumDataImplCopyWith<T, $Res> {
  __$$GalleryPhotoAlbumDataImplCopyWithImpl(
      _$GalleryPhotoAlbumDataImpl<T> _value,
      $Res Function(_$GalleryPhotoAlbumDataImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? firstImageAssetEntity = freezed,
    Object? imageCount = freezed,
  }) {
    return _then(_$GalleryPhotoAlbumDataImpl<T>(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      firstImageAssetEntity: freezed == firstImageAssetEntity
          ? _value.firstImageAssetEntity
          : firstImageAssetEntity // ignore: cast_nullable_to_non_nullable
              as T?,
      imageCount: freezed == imageCount
          ? _value.imageCount
          : imageCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$GalleryPhotoAlbumDataImpl<T> implements _GalleryPhotoAlbumData<T> {
  const _$GalleryPhotoAlbumDataImpl(
      {required this.id,
      required this.name,
      this.firstImageAssetEntity,
      this.imageCount});

  @override
  final String id;
  @override
  final String name;
  @override
  final T? firstImageAssetEntity;
  @override
  final int? imageCount;

  @override
  String toString() {
    return 'GalleryPhotoAlbumData<$T>(id: $id, name: $name, firstImageAssetEntity: $firstImageAssetEntity, imageCount: $imageCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GalleryPhotoAlbumDataImpl<T> &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other.firstImageAssetEntity, firstImageAssetEntity) &&
            (identical(other.imageCount, imageCount) ||
                other.imageCount == imageCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(firstImageAssetEntity), imageCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GalleryPhotoAlbumDataImplCopyWith<T, _$GalleryPhotoAlbumDataImpl<T>>
      get copyWith => __$$GalleryPhotoAlbumDataImplCopyWithImpl<T,
          _$GalleryPhotoAlbumDataImpl<T>>(this, _$identity);
}

abstract class _GalleryPhotoAlbumData<T> implements GalleryPhotoAlbumData<T> {
  const factory _GalleryPhotoAlbumData(
      {required final String id,
      required final String name,
      final T? firstImageAssetEntity,
      final int? imageCount}) = _$GalleryPhotoAlbumDataImpl<T>;

  @override
  String get id;
  @override
  String get name;
  @override
  T? get firstImageAssetEntity;
  @override
  int? get imageCount;
  @override
  @JsonKey(ignore: true)
  _$$GalleryPhotoAlbumDataImplCopyWith<T, _$GalleryPhotoAlbumDataImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
