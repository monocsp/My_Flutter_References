import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_image_picker/gallerypicker/controller/album_dropdown_controller.dart';
import 'package:flutter_custom_image_picker/gallerypicker/domain/album_dropdown_data.dart';
import 'package:flutter_custom_image_picker/gallerypicker/domain/gallery_photo_album_data.dart';
import 'package:flutter_custom_image_picker/gallerypicker/widgets/rotate_dropdown_button_icon.dart';

class AlbumDropdownWidget extends StatefulWidget {
  final AlbumDropdownController controller;
  const AlbumDropdownWidget({super.key, required this.controller});

  @override
  State<AlbumDropdownWidget> createState() => _AlbumDropdownWidgetState();
}

class _AlbumDropdownWidgetState extends State<AlbumDropdownWidget> {
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: widget.controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          AlbumDropdownData albumDropdownData =
              snapshot.data as AlbumDropdownData;

          return DropdownButtonHideUnderline(
            child: DropdownButton2<GalleryPhotoAlbumData>(
              onMenuStateChange: (bool isOpen) => setState(() {
                isDropdownOpen = isOpen;
              }),
              iconStyleData: IconStyleData(
                icon: RotateDropdownButtonIcon(isOpen: isDropdownOpen),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                width: MediaQuery.of(context).size.width,
                useRootNavigator: true,
                // openInterval:
                //     const Interval(0.0, 1.0, curve: defaultCurves),

                maxHeight: MediaQuery.of(context).size.height,
                // offset: const Offset(0, 8),
              ),
              buttonStyleData: const ButtonStyleData(height: kToolbarHeight),
              menuItemStyleData: MenuItemStyleData(
                height: 84,
                padding: EdgeInsets.zero,
              ),
              value: albumDropdownData.selectedData,
              onChanged: (value) => widget.controller.updateData(widget
                  .controller.albumDropdownData
                  .copyWith(selectedData: value)),
              // getPhotos(value!, galleryPhotoAlbumDataChange: true),
              selectedItemBuilder: (context) {
                return albumDropdownData.galleryPhotoAlbumDatas.map(
                  (GalleryPhotoAlbumData item) {
                    String name = item.name;
                    return Container(
                      alignment: AlignmentDirectional.center,
                      child: FittedBox(
                        child: Text(
                          name,
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                ).toList();
              },
              // style: textStyle_H4.copyWith(color: black),
              items: albumDropdownData.galleryPhotoAlbumDatas
                  .map((GalleryPhotoAlbumData item) {
                GalleryPhotoAlbumData? result =
                    albumDropdownData.galleryPhotoAlbumDatas.firstWhere(
                        (GalleryPhotoAlbumData element) =>
                            element.id == item.id,
                        orElse: () => GalleryPhotoAlbumData.empty());

                return DropdownMenuItem(
                  value: item,
                  child: StatefulBuilder(
                    builder: (context, menuSetState) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1))),
                        child: ListTile(
                          leading: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.black),
                            child: result.id == ''
                                ? SizedBox(
                                    width: 52,
                                    height: 52,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: const DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                        )),
                                  )
                                : SizedBox(
                                    width: 52,
                                    height: 52,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.memory(
                                        result.firstImageAssetEntity
                                            .readAsBytesSync(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                          title: Text(
                            item.name,
                          ),
                          trailing: Text(
                            (result.imageCount ?? 0).toString(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}
