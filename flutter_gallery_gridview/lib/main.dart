import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_gridview/gallery/gallery_image_picker_page.dart';
import 'package:flutter_gallery_gridview/image_picker_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GalleryImagePickerPage(
        maxSelectableCount: 10,
      ),
    );
  }
}

// class GalleryScreen extends StatefulWidget {
//   @override
//   _GalleryScreenState createState() => _GalleryScreenState();
// }

// class _GalleryScreenState extends State<GalleryScreen> {
//   int _maxSelection = 3; // 초기 최대 선택 개수 (원하는 값으로 조절)
//   List<AssetEntity> _selectedImages = [];

//   // '-' 버튼: 최대 선택 수 감소 (최소 1)
//   void _decrementMax() {
//     if (_maxSelection > 1) {
//       setState(() {
//         _maxSelection--;
//       });
//     }
//   }

//   // '+' 버튼: 최대 선택 수 증가
//   void _incrementMax() {
//     setState(() {
//       _maxSelection++;
//     });
//   }

//   // "이미지 가져오기" 버튼: GalleryBottomSheet 열기
//   Future<void> _openGalleryBottomSheet() async {
//     final result = await showModalBottomSheet<List<AssetEntity>>(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => GalleryBottomSheet(
//         maxSelection: _maxSelection,
//         alreadySelected: _selectedImages,
//       ),
//     );
//     if (result != null) {
//       setState(() {
//         _selectedImages = result;
//       });
//     }
//   }

//   // "즐겨찾기 갤러리" 버튼: GalleryFavoriteBottomSheet 열기
//   Future<void> _openFavoriteGalleryBottomSheet() async {
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => ImagePickerBottomSheet(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gallery Demo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // 메인 화면에 선택된 이미지를 가로 리스트로 보여줍니다.
//             if (_selectedImages.isNotEmpty)
//               Container(
//                 height: 110,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: _selectedImages.length,
//                   itemBuilder: (context, index) {
//                     final asset = _selectedImages[index];
//                     return FutureBuilder<Uint8List?>(
//                       future:
//                           asset.thumbnailDataWithSize(ThumbnailSize(100, 100)),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done &&
//                             snapshot.hasData) {
//                           return Container(
//                             width: 100,
//                             height: 100,
//                             margin: EdgeInsets.all(8),
//                             child: Image.memory(
//                               snapshot.data!,
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         }
//                         return Container(
//                           width: 100,
//                           height: 100,
//                           margin: EdgeInsets.all(8),
//                           color: Colors.grey[300],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             // 최대 선택 개수 조절 컨트롤: '-' 숫자 '+'
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.remove),
//                   onPressed: _decrementMax,
//                 ),
//                 Text(
//                   '$_maxSelection',
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: _incrementMax,
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // 이미지 가져오기 버튼
//             ElevatedButton(
//               child: Text('이미지 가져오기'),
//               onPressed: _openGalleryBottomSheet,
//             ),
//             SizedBox(height: 12),
//             // 즐겨찾기 갤러리 버튼
//             ElevatedButton(
//               child: Text('즐겨찾기 갤러리'),
//               onPressed: _openFavoriteGalleryBottomSheet,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GalleryBottomSheet extends StatefulWidget {
//   final int maxSelection;
//   final List<AssetEntity> alreadySelected;

//   const GalleryBottomSheet({
//     Key? key,
//     required this.maxSelection,
//     required this.alreadySelected,
//   }) : super(key: key);

//   @override
//   _GalleryBottomSheetState createState() => _GalleryBottomSheetState();
// }

// class _GalleryBottomSheetState extends State<GalleryBottomSheet> {
//   List<AssetEntity> _photos = [];
//   List<AssetEntity> _newSelections = []; // 새로 선택한 이미지
//   bool _loading = true;
//   String _errorMsg = '';

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissionAndLoad();
//   }

//   Future<void> _requestPermissionAndLoad() async {
//     setState(() {
//       _loading = true;
//       _errorMsg = '';
//     });
//     PermissionStatus status = await Permission.photos.request();
//     if (status.isGranted) {
//       _loadPhotos();
//     } else {
//       setState(() {
//         _errorMsg = '사진 접근 권한이 부여되지 않았습니다.';
//         _loading = false;
//       });
//     }
//   }

//   Future<void> _loadPhotos() async {
//     try {
//       List<AssetPathEntity> albums =
//           await PhotoManager.getAssetPathList(type: RequestType.image);
//       if (albums.isNotEmpty) {
//         AssetPathEntity album = albums.first;
//         List<AssetEntity> photos =
//             await album.getAssetListPaged(page: 0, size: 100);
//         setState(() {
//           _photos = photos;
//           _loading = false;
//         });
//       } else {
//         setState(() {
//           _errorMsg = '앨범을 찾을 수 없습니다.';
//           _loading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMsg = '이미지 로드 중 오류가 발생했습니다: $e';
//         _loading = false;
//       });
//     }
//   }

//   // 총 선택수 = 이미 선택된(_already) + 새로 선택된(_newSelections)
//   int get totalSelected =>
//       widget.alreadySelected.length + _newSelections.length;

//   // BottomSheet 내에서 이미지 선택 토글
//   // 이미 외부에서 선택된 이미지는 선택/해제 불가.
//   // 새로 선택한 이미지의 최대 허용 개수는 widget.maxSelection - widget.alreadySelected.length 입니다.
//   void _toggleSelection(AssetEntity asset) {
//     // 만약 이미 외부 선택 목록에 있다면 아무 동작 안함.
//     if (widget.alreadySelected.any((e) => e.id == asset.id)) return;

//     setState(() {
//       if (_newSelections.any((e) => e.id == asset.id)) {
//         _newSelections.removeWhere((e) => e.id == asset.id);
//       } else {
//         if (_newSelections.length <
//             (widget.maxSelection - widget.alreadySelected.length)) {
//           _newSelections.add(asset);
//         }
//       }
//     });
//   }

//   // 그리드 아이템 위젯 생성
//   // 이미 외부 선택된 경우 노란 테두리, 새로 선택된 경우 파란 오버레이와 번호 표시
//   Widget _buildGridItem(AssetEntity asset) {
//     // 외부에서 이미 선택된지 확인 (id로 비교)
//     bool isExternallySelected =
//         widget.alreadySelected.any((e) => e.id == asset.id);
//     // 새로 선택된 목록 내에 있는지 확인
//     int newIndex = _newSelections.indexWhere((e) => e.id == asset.id);
//     return GestureDetector(
//       onTap: () => _toggleSelection(asset),
//       child: Stack(
//         children: [
//           FutureBuilder<Uint8List?>(
//             future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done &&
//                   snapshot.hasData) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     // 외부 선택된 경우 노란 테두리로 감싸기
//                     border: isExternallySelected
//                         ? Border.all(color: Colors.red, width: 2)
//                         : null,
//                   ),
//                   child: Image.memory(
//                     snapshot.data!,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: double.infinity,
//                   ),
//                 );
//               }
//               return Container(
//                 color: Colors.grey[300],
//               );
//             },
//           ),
//           // 우측 상단 오버레이:
//           // - 이미 외부 선택된 경우: 노란 원 (번호는 외부에서 따로 표시하지 않고, 테두리로 구분)
//           // - 새로 선택된 경우: 파란색 원 안에 새 선택 순서 번호 표시
//           Positioned(
//             top: 4,
//             right: 4,
//             child: Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 // 새로 선택된 경우 파란색, 그렇지 않으면 투명 (외부 선택은 이미 테두리로 표시됨)
//                 color: newIndex >= 0 ? Colors.blueAccent : Colors.transparent,
//                 border: Border.all(color: Colors.black),
//               ),
//               child: newIndex >= 0
//                   ? Center(
//                       child: Text(
//                         '${newIndex + 1}',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 6,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                   : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.8,
//       padding: EdgeInsets.all(8),
//       child: Column(
//         children: [
//           // 상단 선택 상태 표시: 외부+새로 선택된 총합 / 최대 선택 수
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('선택: $totalSelected / ${widget.maxSelection}'),
//               if (totalSelected == widget.maxSelection)
//                 ElevatedButton(
//                   onPressed: () {
//                     // 완료 시 외부 선택과 새로 선택한 이미지를 합쳐서 반환
//                     Navigator.pop(
//                       context,
//                       [...widget.alreadySelected, ..._newSelections],
//                     );
//                   },
//                   child: Text('완료'),
//                 ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Expanded(
//             child: _loading
//                 ? Center(child: CircularProgressIndicator())
//                 : _errorMsg.isNotEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(_errorMsg),
//                             SizedBox(height: 16),
//                             ElevatedButton(
//                               onPressed: _requestPermissionAndLoad,
//                               child: Text('권한 재요청'),
//                             ),
//                           ],
//                         ),
//                       )
//                     : GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 2,
//                           mainAxisSpacing: 2,
//                         ),
//                         itemCount: _photos.length,
//                         itemBuilder: (context, index) {
//                           return _buildGridItem(_photos[index]);
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ---------- 즐겨찾기 갤러리 바텀시트 래퍼 (GalleryFavoriteGrid 코드는 건드리지 않음) ----------

// class GalleryFavoriteBottomSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.8,
//       padding: EdgeInsets.all(8),
//       child: Column(
//         children: [
//           // 헤더: 제목과 완료 버튼
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "즐겨찾기 갤러리",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text("완료"),
//               )
//             ],
//           ),
//           SizedBox(height: 8),
//           // 즐겨찾기 관련 코드는 내부 GalleryFavoriteGrid 위젯에 있음
//           Expanded(child: GalleryFavoriteGrid()),
//         ],
//       ),
//     );
//   }
// }

// // ---------- 즐겨찾기 갤러리 코드 (수정하지 말 것) ----------

// class GalleryFavoriteGrid extends StatefulWidget {
//   @override
//   _GalleryFavoriteGridState createState() => _GalleryFavoriteGridState();
// }

// class _GalleryFavoriteGridState extends State<GalleryFavoriteGrid> {
//   List<AssetEntity> _photos = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPhotos();
//   }

//   Future<void> _loadPhotos() async {
//     // 권한 요청
//     final permission = await PhotoManager.requestPermissionExtend();
//     if (!permission.isAuth) {
//       return;
//     }

//     // '모든 사진' 앨범 가져오기
//     List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//       type: RequestType.image,
//       hasAll: true,
//       onlyAll: true,
//     );
//     if (albums.isEmpty) return;
//     AssetPathEntity allPhotosAlbum = albums.first;
//     final int allPhotosAlbumCount = await allPhotosAlbum.assetCountAsync;
//     // 해당 앨범의 모든 사진 가져오기
//     final photos = await allPhotosAlbum.getAssetListPaged(
//         page: 0, size: allPhotosAlbumCount);

//     setState(() {
//       _photos = photos;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: _photos.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         mainAxisSpacing: 2,
//         crossAxisSpacing: 2,
//       ),
//       itemBuilder: (context, index) {
//         AssetEntity asset = _photos[index];
//         // photo_manager 가 제공하는 AssetEntityImage 위젯 사용
//         Widget thumbnail = AssetEntityImage(
//           asset,
//           isOriginal: false,
//           thumbnailSize: const ThumbnailSize.square(200),
//           fit: BoxFit.cover,
//         );
//         // 즐겨찾기 여부에 따라 하트 아이콘 오버레이
//         bool favorite = asset.isFavorite;
//         return Stack(
//           children: [
//             Positioned.fill(child: thumbnail),
//             if (favorite)
//               Positioned(
//                 right: 4,
//                 bottom: 4,
//                 child: Icon(Icons.favorite, color: Colors.redAccent, size: 20),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
