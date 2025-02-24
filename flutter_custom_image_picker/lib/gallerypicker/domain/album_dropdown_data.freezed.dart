// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_dropdown_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AlbumDropdownData {
  GalleryPhotoAlbumData<dynamic>? get selectedData =>
      throw _privateConstructorUsedError;
  List<GalleryPhotoAlbumData> get galleryPhotoAlbumDatas =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlbumDropdownDataCopyWith<AlbumDropdownData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumDropdownDataCopyWith<$Res> {
  factory $AlbumDropdownDataCopyWith(
          AlbumDropdownData value, $Res Function(AlbumDropdownData) then) =
      _$AlbumDropdownDataCopyWithImpl<$Res, AlbumDropdownData>;
  @useResult
  $Res call(
      {GalleryPhotoAlbumData<dynamic>? selectedData,
      List<GalleryPhotoAlbumData> galleryPhotoAlbumDatas});

  $GalleryPhotoAlbumDataCopyWith<dynamic, $Res>? get selectedData;
}

/// @nodoc
class _$AlbumDropdownDataCopyWithImpl<$Res, $Val extends AlbumDropdownData>
    implements $AlbumDropdownDataCopyWith<$Res> {
  _$AlbumDropdownDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedData = freezed,
    Object? galleryPhotoAlbumDatas = null,
  }) {
    return _then(_value.copyWith(
      selectedData: freezed == selectedData
          ? _value.selectedData
          : selectedData // ignore: cast_nullable_to_non_nullable
              as GalleryPhotoAlbumData<dynamic>?,
      galleryPhotoAlbumDatas: null == galleryPhotoAlbumDatas
          ? _value.galleryPhotoAlbumDatas
          : galleryPhotoAlbumDatas // ignore: cast_nullable_to_non_nullable
              as List<GalleryPhotoAlbumData>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GalleryPhotoAlbumDataCopyWith<dynamic, $Res>? get selectedData {
    if (_value.selectedData == null) {
      return null;
    }

    return $GalleryPhotoAlbumDataCopyWith<dynamic, $Res>(_value.selectedData!,
        (value) {
      return _then(_value.copyWith(selectedData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AlbumDropdownDataImplCopyWith<$Res>
    implements $AlbumDropdownDataCopyWith<$Res> {
  factory _$$AlbumDropdownDataImplCopyWith(_$AlbumDropdownDataImpl value,
          $Res Function(_$AlbumDropdownDataImpl) then) =
      __$$AlbumDropdownDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GalleryPhotoAlbumData<dynamic>? selectedData,
      List<GalleryPhotoAlbumData> galleryPhotoAlbumDatas});

  @override
  $GalleryPhotoAlbumDataCopyWith<dynamic, $Res>? get selectedData;
}

/// @nodoc
class __$$AlbumDropdownDataImplCopyWithImpl<$Res>
    extends _$AlbumDropdownDataCopyWithImpl<$Res, _$AlbumDropdownDataImpl>
    implements _$$AlbumDropdownDataImplCopyWith<$Res> {
  __$$AlbumDropdownDataImplCopyWithImpl(_$AlbumDropdownDataImpl _value,
      $Res Function(_$AlbumDropdownDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedData = freezed,
    Object? galleryPhotoAlbumDatas = null,
  }) {
    return _then(_$AlbumDropdownDataImpl(
      selectedData: freezed == selectedData
          ? _value.selectedData
          : selectedData // ignore: cast_nullable_to_non_nullable
              as GalleryPhotoAlbumData<dynamic>?,
      galleryPhotoAlbumDatas: null == galleryPhotoAlbumDatas
          ? _value._galleryPhotoAlbumDatas
          : galleryPhotoAlbumDatas // ignore: cast_nullable_to_non_nullable
              as List<GalleryPhotoAlbumData>,
    ));
  }
}

/// @nodoc

class _$AlbumDropdownDataImpl implements _AlbumDropdownData {
  const _$AlbumDropdownDataImpl(
      {this.selectedData,
      required final List<GalleryPhotoAlbumData> galleryPhotoAlbumDatas})
      : _galleryPhotoAlbumDatas = galleryPhotoAlbumDatas;

  @override
  final GalleryPhotoAlbumData<dynamic>? selectedData;
  final List<GalleryPhotoAlbumData> _galleryPhotoAlbumDatas;
  @override
  List<GalleryPhotoAlbumData> get galleryPhotoAlbumDatas {
    if (_galleryPhotoAlbumDatas is EqualUnmodifiableListView)
      return _galleryPhotoAlbumDatas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_galleryPhotoAlbumDatas);
  }

  @override
  String toString() {
    return 'AlbumDropdownData(selectedData: $selectedData, galleryPhotoAlbumDatas: $galleryPhotoAlbumDatas)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumDropdownDataImpl &&
            (identical(other.selectedData, selectedData) ||
                other.selectedData == selectedData) &&
            const DeepCollectionEquality().equals(
                other._galleryPhotoAlbumDatas, _galleryPhotoAlbumDatas));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedData,
      const DeepCollectionEquality().hash(_galleryPhotoAlbumDatas));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumDropdownDataImplCopyWith<_$AlbumDropdownDataImpl> get copyWith =>
      __$$AlbumDropdownDataImplCopyWithImpl<_$AlbumDropdownDataImpl>(
          this, _$identity);
}

abstract class _AlbumDropdownData implements AlbumDropdownData {
  const factory _AlbumDropdownData(
          {final GalleryPhotoAlbumData<dynamic>? selectedData,
          required final List<GalleryPhotoAlbumData> galleryPhotoAlbumDatas}) =
      _$AlbumDropdownDataImpl;

  @override
  GalleryPhotoAlbumData<dynamic>? get selectedData;
  @override
  List<GalleryPhotoAlbumData> get galleryPhotoAlbumDatas;
  @override
  @JsonKey(ignore: true)
  _$$AlbumDropdownDataImplCopyWith<_$AlbumDropdownDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
