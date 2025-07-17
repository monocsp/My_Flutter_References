import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// GalleryFolderListWidget – 폴더(앨범) 리스트를 표시하는 오버레이 위젯.
/// onFolderSelected 콜백의 album 값이 null이면 "최근 항목" (전체 이미지)을 의미합니다.
class GalleryFolderListWidget extends StatefulWidget {
  final List<AssetPathEntity> albums;
  final void Function(AssetPathEntity? album) onFolderSelected;

  const GalleryFolderListWidget({
    super.key,
    required this.albums,
    required this.onFolderSelected,
  });

  @override
  State<GalleryFolderListWidget> createState() =>
      _GalleryFolderListWidgetState();
}

class _GalleryFolderListWidgetState extends State<GalleryFolderListWidget> {
  // 캐시 Future 저장용 Map: 앨범 id와 첫 번째 이미지 Future
  late final Map<String, Future<List<AssetEntity>>> _thumbnailFutures;
  // 캐시 Future 저장용 Map: 앨범 id와 이미지 개수 Future
  late final Map<String, Future<int>> _countFutures;

  /// "최근 항목"에 사용할 전체 사진(최근 항목) 앨범
  late final AssetPathEntity? _recentAlbum;

  @override
  void initState() {
    super.initState();

    // _recentAlbum: widget.albums에서 album.isAll == true 인 앨범
    _recentAlbum = widget.albums.firstWhere((album) => album.isAll);

    // 캐싱용 Future Map 초기화
    _thumbnailFutures = {};
    _countFutures = {};

    // 모든 앨범에 대해, _thumbnailFutures와 _countFutures에 Future를 미리 할당한다.
    for (final album in widget.albums) {
      _thumbnailFutures[album.id] = album.getAssetListPaged(page: 0, size: 1);
      _countFutures[album.id] = album.assetCountAsync;
    }
  }

  /// 각 앨범의 첫 번째 이미지를 불러와 위젯으로 구성합니다.
  Widget _buildAlbumThumbnail(AssetPathEntity album) {
    final future = _thumbnailFutures[album.id]!;
    return FutureBuilder<List<AssetEntity>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final asset = snapshot.data!.first;
          return ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: AssetEntityImageProvider(
                asset,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize(60, 60),
              ),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: 60,
              height: 60,
              color: const Color(0xFFD9D9D9),
            ),
          );
        }
      },
    );
  }

  /// _buildAlbumCount: 각 앨범의 이미지 개수를 Future<int>로 받아 AnimatedSwitcher로 부드럽게 전환된 위젯을 반환합니다.
  Widget _buildAlbumCount(Future<int> future) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: snapshot.hasData
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${snapshot.data} items",
                    textAlign: TextAlign.start,
                    key: ValueKey(snapshot.data),
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              : const SizedBox(key: ValueKey("empty")),
        );
      },
    );
  }

  /// "최근 항목" ListTile: 전체 사진 앨범을 이용하여 썸네일과 전체 이미지 수를 표시합니다.
  Widget _buildRecentTile(BuildContext context) {
    Widget leadingWidget = _buildAlbumThumbnail(_recentAlbum!);
    Widget subtitleWidget = _buildAlbumCount(_countFutures[_recentAlbum!.id]!);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: leadingWidget,
      title: const Text("최근 항목", style: TextStyle(fontSize: 16)),
      subtitle: subtitleWidget,
      onTap: () {
        widget.onFolderSelected(null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // "최근 항목" 옵션과 그 외의 폴더 목록 생성 (전체, 즐겨찾기 제외)
    final List<AssetPathEntity> folderAlbums = widget.albums.where((album) {
      if (album.isAll) return false;
      String name = album.name.toLowerCase();
      if (name == "favorites" || name == "즐겨찾음") return false;
      return true;
    }).toList();

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRecentTile(context),
              const Divider(height: 1),
              ...folderAlbums.map(
                (album) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: _buildAlbumThumbnail(album),
                      title: Text(album.name,
                          style: const TextStyle(fontSize: 16)),
                      subtitle: _buildAlbumCount(_countFutures[album.id]!),
                      onTap: () {
                        widget.onFolderSelected(album);
                      },
                    ),
                    const Divider(height: 1),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
