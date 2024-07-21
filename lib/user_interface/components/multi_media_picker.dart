import 'dart:async';

import 'package:dynamic_form/_libraries/widgets/prototype_item.dart';
import 'package:dynamic_form/user_interface/components/app_image.dart';
import 'package:dynamic_form/user_interface/dialogs/bottom_sheet/select_media_bottomsheet.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiMediaPicker extends StatelessWidget {
  const MultiMediaPicker({
    required this.controller,
    this.picker = SelectMediaBottomSheet.showBottomSheet,
    this.builder = container,
    this.addMoreBuilder = addMore,
    this.limit,
    super.key,
  });

  final ValueNotifier<List<XFile>> controller;
  final FutureOr<List<XFile>?> Function(
    BuildContext context, {
    List<XFile>? selectedMedia,
    int? limit,
  }) picker;
  final Widget Function(XFile file, void Function() remove) builder;
  final Widget Function(void Function() onTap) addMoreBuilder;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    return PrototypeItem(
      prototype: const SizedBox.square(dimension: 108),
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, media, child) {
          void remove(XFile file) {
            controller.value = media.toList()..remove(file);
          }

          void add() async {
            final updatedMedia = await picker(
              context,
              selectedMedia: media,
              limit: limit,
            );

            if (updatedMedia != null) {
              controller.value = updatedMedia.toList();
            }
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: limit != null && limit! > 0
                ? (media.length.clamp(0, limit! - 1) + 1).toInt()
                : media.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index < media.length) {
                final file = media[index];
                return builder(file, () => remove(file));
              } else {
                return addMoreBuilder(add);
              }
            },
          );
        },
      ),
    );
  }

  static Widget container(XFile file, void Function() remove) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconSize = constraints.biggest.shortestSide * .16;
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppImage(
                  image: file.path,
                  type: ImageType.file,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: iconSize / 4,
                top: iconSize / 4,
                child: GestureDetector(
                  onTap: remove,
                  child: Container(
                    height: iconSize,
                    width: iconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(),
                    ),
                    child: Icon(Icons.close, size: iconSize * .75),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  static Widget addMore(void Function() onTap, {bool isLoading = false}) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(builder: (context, constraints) {
          final iconSize = constraints.biggest.shortestSide * .48;
          return Container(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
              color: Colors.grey[200],
            ),
            child: isLoading
                ? const CircularProgressIndicator.adaptive()
                : Icon(Icons.add_photo_alternate, size: iconSize),
          );
        }),
      ),
    );
  }
}
