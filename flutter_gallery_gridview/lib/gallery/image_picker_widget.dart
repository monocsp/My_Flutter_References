import 'package:flutter/material.dart';
import 'package:flutter_gallery_gridview/gallery/gallery_folder_list_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// ImagePickerWidget – 전달받은 앨범 목록을 기반으로 "최근 항목"(전체 이미지) 또는 선택한 폴더의 이미지를 GridView로 표시합니다.
/// 매개변수:
/// - maxSelectable: 사용자가 선택할 수 있는 최대 이미지 개수
/// - resultSelectedImages: 모든 선택 완료 시 호출할 콜백 (선택된 이미지 리스트 전달)
/// - albums: 전체 앨범(폴더) 목록

/// 각 그리드 셀을 담당하는 위젯: SelectableGridItem
class SelectableGridItem extends StatelessWidget {
  final AssetEntity asset;
  final bool isSelected;
  final int? selectionIndex; // 선택된 경우 0부터 시작하는 순서
  final VoidCallback onTap;

  const SelectableGridItem({
    super.key,
    required this.asset,
    required this.isSelected,
    required this.selectionIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 선택 시 애니메이션 지속시간: 선택 시 150ms, 해제 시 10ms
    final Duration animDuration = isSelected
        ? const Duration(milliseconds: 50)
        : const Duration(milliseconds: 10);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // 이미지와 선택 테두리: AnimatedContainer로 애니메이션 적용
          Positioned.fill(
            child: Image(
              image: AssetEntityImageProvider(
                asset,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize(200, 200),
              ),
              fit: BoxFit.cover,
            ),
          ),
          // 선택된 경우: 이미지 전체에 AnimatedOpacity 적용한 40% 검정 오버레이
          AnimatedSwitcher(
            duration: animDuration,
            child: isSelected
                ? Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black.withValues(alpha: 0.4)
                          : null,
                      border: isSelected
                          ? Border.all(color: const Color(0xFFFE788E), width: 2)
                          : null,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // 우측 상단: AnimatedContainer로 구성된 원형 선택 위젯 (24x24)
          Positioned(
            top: 8,
            right: 8,
            child: AnimatedContainer(
              duration: animDuration,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // 선택된 경우 테두리 제거, 배경색 FE788E, 미선택 시 흰색 테두리만
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white, width: 1),
                color:
                    isSelected ? const Color(0xFFFE788E) : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Text(
                      "${selectionIndex! + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    )
                  : const SizedBox(),
            ),
          ),
          // 즐겨찾기 아이콘: 왼쪽 하단 (left: 9, bottom: 9), 19x19, white
          Positioned(
            left: 9,
            bottom: 9,
            child: asset.isFavorite
                ? const Icon(Icons.favorite, color: Colors.white, size: 19)
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

/// 전체 GridView를 구성하는 위젯: GridViewSection
class GridViewSection extends StatelessWidget {
  final ValueNotifier<List<AssetEntity>> assetsNotifier;
  final ValueNotifier<List<AssetEntity>> selectedImagesNotifier;
  final void Function(AssetEntity asset) onImageTap;

  const GridViewSection({
    super.key,
    required this.assetsNotifier,
    required this.selectedImagesNotifier,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AssetEntity>>(
      valueListenable: assetsNotifier,
      builder: (context, assets, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1.0,
          ),
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index];
            return ValueListenableBuilder<List<AssetEntity>>(
              valueListenable: selectedImagesNotifier,
              builder: (context, selected, _) {
                final int selectedIndex =
                    selected.indexWhere((e) => e.id == asset.id);
                final bool isSelected = selectedIndex != -1;
                return SelectableGridItem(
                  asset: asset,
                  isSelected: isSelected,
                  selectionIndex: isSelected ? selectedIndex : null,
                  onTap: () => onImageTap(asset),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// ImagePickerWidget – 전체 기능 구현
/// - 전달받은 앨범 목록을 기반으로 "최근 항목" (selectedAlbum == null) 또는 선택한 폴더의 이미지를 GridView로 표시합니다.
/// - AppBar의 드롭다운 버튼을 누르면 오버레이(폴더 리스트)가 슬라이드 애니메이션으로 나타나고, 폴더 선택 시 GridView가 부드럽게 전환됩니다.
/// - 선택된 이미지들은 전역적으로 유지되며, 최대 선택 수(widget.maxSelectable)를 넘지 않도록 제한합니다.
class ImagePickerWidget extends StatefulWidget {
  final int maxSelectable;
  final Function? resultSelectedImages;
  final List<AssetPathEntity> albums;
  const ImagePickerWidget({
    super.key,
    required this.albums,
    required this.maxSelectable,
    this.resultSelectedImages,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget>
    with SingleTickerProviderStateMixin {
  // -------------------- ValueNotifier 상태 --------------------
  final ValueNotifier<String> dropdownTextNotifier = ValueNotifier("최근 항목");
  final ValueNotifier<bool> overlayOpenNotifier = ValueNotifier(false);
  final ValueNotifier<AssetPathEntity?> selectedAlbumNotifier =
      ValueNotifier(null);
  final ValueNotifier<List<AssetEntity>> selectedImagesNotifier =
      ValueNotifier([]);

  // 이미지 리스트 (최근 항목과 폴더별)
  final ValueNotifier<List<AssetEntity>> recentAssetsNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<AssetEntity>> folderAssetsNotifier =
      ValueNotifier([]);

  // -------------------- 내부 변수 (앨범, 페이지네이션) --------------------
  late final List<AssetPathEntity> _albums;
  AssetPathEntity? _allPhotosAlbum; // 전체 사진(최근 항목)
  int _recentPage = 0, _folderPage = 0;
  bool _isLoadingMore = false;
  bool _recentComplete = false;
  bool _folderComplete = false;

  // -------------------- 애니메이션 (오버레이 슬라이드, 아이콘 회전) --------------------
  late final AnimationController overlayController;
  late final Animation<double> overlayAnimation;
  late final Animation<double> iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _albums = widget.albums;
    // _albums에서 전체 사진(최근 항목) 앨범 식별 (album.isAll)
    for (AssetPathEntity album in _albums) {
      if (album.isAll) {
        _allPhotosAlbum = album;
        break;
      }
    }
    _allPhotosAlbum ??= _albums.isNotEmpty ? _albums.first : null;
    // 기본 상태: "최근 항목" (selectedAlbumNotifier == null)
    dropdownTextNotifier.value = "최근 항목";
    selectedAlbumNotifier.value = null;
    _loadRecentAssets(firstPage: true);

    overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    overlayAnimation = CurvedAnimation(
      parent: overlayController,
      curve: Curves.easeOut,
    );
    iconRotationAnimation =
        Tween<double>(begin: 0, end: 3.14159).animate(overlayAnimation);
  }

  @override
  void dispose() {
    overlayController.dispose();
    dropdownTextNotifier.dispose();
    overlayOpenNotifier.dispose();
    selectedAlbumNotifier.dispose();
    selectedImagesNotifier.dispose();
    recentAssetsNotifier.dispose();
    folderAssetsNotifier.dispose();
    super.dispose();
  }

  // -------------------- 데이터 로딩 함수 --------------------
  Future<void> _loadRecentAssets({bool firstPage = false}) async {
    if (_allPhotosAlbum == null || _recentComplete) return;
    if (firstPage) {
      recentAssetsNotifier.value = [];
      _recentPage = 0;
      _recentComplete = false;
    }
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    List<AssetEntity> newAssets = await _allPhotosAlbum!.getAssetListPaged(
      page: _recentPage,
      size: 100,
    );
    if (newAssets.length < 100) _recentComplete = true;
    recentAssetsNotifier.value = [...recentAssetsNotifier.value, ...newAssets];
    _recentPage++;
    _isLoadingMore = false;
  }

  Future<void> _loadFolderAssets({bool firstPage = false}) async {
    final album = selectedAlbumNotifier.value;
    if (album == null || _folderComplete) return;
    if (firstPage) {
      folderAssetsNotifier.value = [];
      _folderPage = 0;
      _folderComplete = false;
    }
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    List<AssetEntity> newAssets = await album.getAssetListPaged(
      page: _folderPage,
      size: 100,
    );
    if (newAssets.length < 100) _folderComplete = true;
    folderAssetsNotifier.value = [...folderAssetsNotifier.value, ...newAssets];
    _folderPage++;
    _isLoadingMore = false;
  }

  void _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis == Axis.vertical &&
        notification.metrics.pixels / notification.metrics.maxScrollExtent >
            0.7) {
      if (selectedAlbumNotifier.value == null) {
        _loadRecentAssets();
      } else {
        _loadFolderAssets();
      }
    }
  }

  // -------------------- 드롭다운/오버레이 관련 --------------------
  void _toggleOverlay() {
    if (overlayOpenNotifier.value) {
      overlayController.reverse();
      overlayOpenNotifier.value = false;
    } else {
      overlayController.forward();
      overlayOpenNotifier.value = true;
    }
  }

  /// 폴더 선택 콜백 – album이 null이면 "최근 항목"을 의미함.
  void _onFolderSelected(AssetPathEntity? album) {
    if (album == null) {
      dropdownTextNotifier.value = "최근 항목";
      selectedAlbumNotifier.value = null;
      recentAssetsNotifier.value = [];
      _recentPage = 0;
      _recentComplete = false;
      _loadRecentAssets(firstPage: true);
    } else {
      dropdownTextNotifier.value = album.name;
      selectedAlbumNotifier.value = album;
      folderAssetsNotifier.value = [];
      _folderPage = 0;
      _folderComplete = false;
      _loadFolderAssets(firstPage: true);
    }
    _toggleOverlay();
  }

  // -------------------- 이미지 선택 관련 --------------------
  void _onImageTapped(AssetEntity asset) {
    final selected = selectedImagesNotifier.value;
    final index = selected.indexWhere((e) => e.id == asset.id);
    if (index == -1) {
      // 아직 선택되지 않은 경우, 최대 선택 개수 이하이면 추가.
      if (selected.length < widget.maxSelectable) {
        selectedImagesNotifier.value = [...selected, asset];
      } else {
        // TODO: 최대 선택 개수 초과 시 추가 동작 (예: 안내 메시지 표시)
      }
    } else {
      // 선택된 이미지 해제 및 순서 재정렬
      final newList = List<AssetEntity>.from(selected)..removeAt(index);
      selectedImagesNotifier.value = newList;
    }
  }

  // -------------------- 화면 구성 함수 --------------------
  /// GridViewSection을 사용해 데이터를 표시하는 함수.
  Widget _buildGridContent() {
    return ValueListenableBuilder<AssetPathEntity?>(
      valueListenable: selectedAlbumNotifier,
      builder: (context, selectedAlbum, _) {
        if (selectedAlbum == null) {
          if (recentAssetsNotifier.value.isEmpty) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              key: const ValueKey("recent_loading"),
              child: FutureBuilder(
                future: _loadRecentAssets(firstPage: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    return GridViewSection(
                      assetsNotifier: recentAssetsNotifier,
                      selectedImagesNotifier: selectedImagesNotifier,
                      onImageTap: _onImageTapped,
                    );
                  }
                },
              ),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
            );
          } else {
            return GridViewSection(
              assetsNotifier: recentAssetsNotifier,
              selectedImagesNotifier: selectedImagesNotifier,
              onImageTap: _onImageTapped,
            );
          }
        } else {
          if (folderAssetsNotifier.value.isEmpty) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              key: const ValueKey("folder_loading"),
              child: FutureBuilder(
                future: _loadFolderAssets(firstPage: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    return GridViewSection(
                      assetsNotifier: folderAssetsNotifier,
                      selectedImagesNotifier: selectedImagesNotifier,
                      onImageTap: _onImageTapped,
                    );
                  }
                },
              ),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
            );
          } else {
            return GridViewSection(
              assetsNotifier: folderAssetsNotifier,
              selectedImagesNotifier: selectedImagesNotifier,
              onImageTap: _onImageTapped,
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // AppBar 타이틀에 Dropdown 버튼: 터치 시 오버레이 토글
        title: GestureDetector(
          onTap: _toggleOverlay,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: dropdownTextNotifier,
                builder: (context, value, child) {
                  return Text(value, style: const TextStyle(fontSize: 18));
                },
              ),
              const SizedBox(width: 4),
              AnimatedBuilder(
                animation: iconRotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: iconRotationAnimation.value,
                    child: const Icon(Icons.arrow_drop_down),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          // 완료 버튼: 선택된 이미지 수가 0이면 disabled, 그렇지 않으면 선택된 이미지 수와 함께 활성화
          ValueListenableBuilder<List<AssetEntity>>(
            valueListenable: selectedImagesNotifier,
            builder: (context, selected, child) {
              final isEmpty = selected.isEmpty;
              return Row(
                children: [
                  if (!isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "${selected.length}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  TextButton(
                    onPressed: isEmpty
                        ? null
                        : () {
                            if (widget.resultSelectedImages != null) {
                              widget.resultSelectedImages!(selected);
                            }
                          },
                    child: Text(
                      "완료",
                      style: TextStyle(
                        color: isEmpty ? Colors.grey : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 메인 컨텐츠: AnimatedSwitcher로 GridView 전환 (무한 스크롤 포함)
          NotificationListener<ScrollNotification>(
            onNotification: (notif) {
              if (notif.metrics.axis == Axis.vertical) {
                _onScroll(notif);
              }
              return false;
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: _buildGridContent(),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),
          // 오버레이: GalleryFolderListWidget를 사용하여 전체 앨범(폴더) 목록을 표시 (최상단에 "최근 항목" 옵션 포함)
          ValueListenableBuilder<bool>(
            valueListenable: overlayOpenNotifier,
            builder: (context, open, child) {
              return AnimatedBuilder(
                animation: overlayAnimation,
                builder: (context, child) {
                  double overlayTop =
                      -deviceHeight + (deviceHeight * overlayAnimation.value);
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: overlayTop,
                    height: deviceHeight,
                    child: child!,
                  );
                },
                child: GalleryFolderListWidget(
                  albums: _albums,
                  onFolderSelected: _onFolderSelected,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
