import 'package:dynamic_form/_libraries/media_access.dart';
import 'package:dynamic_form/user_interface/components/multi_media_picker.dart';
import 'package:dynamic_form/utils/app_helpers/_app_helper_import.dart';
import 'package:image_picker/image_picker.dart';

class SelectMediaBottomSheet extends StatefulWidget {
  static Future<List<XFile>?> showBottomSheet(
    BuildContext context, {
    List<XFile>? selectedMedia,
    int? limit,
  }) async {
    return showModalBottomSheet<List<XFile>>(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) => SelectMediaBottomSheet(
        selectedMedia: selectedMedia ?? [],
        limit: limit,
      ),
    );
  }

  const SelectMediaBottomSheet({
    this.selectedMedia = const [],
    this.limit,
    super.key,
  });

  final List<XFile> selectedMedia;
  final int? limit;

  @override
  State<SelectMediaBottomSheet> createState() => _SelectMediaBottomSheetState();
}

class _SelectMediaBottomSheetState extends State<SelectMediaBottomSheet> {
  late final List<XFile> _selectedMedia =
      List<XFile>.from(widget.selectedMedia);
  bool _isLoading = false;
  MediaAccess get mediaAccess => getit.get<MediaAccess>();

  void _remove(XFile file) {
    _selectedMedia.remove(file);
    _refresh();
  }

  void _add() async {
    _isLoading = true;
    _refresh();

    List<XFile>? files;
    if (widget.limit != null) {
      final slotsLeft = widget.limit! - _selectedMedia.length;

      if (slotsLeft < 2) {
        final file = await mediaAccess.pickMedia();
        if (file != null) {
          files = [file];
        }
      } else {
        files = await mediaAccess.pickMultiMedia(mediaLimit: slotsLeft);
      }
    } else {
      files = await mediaAccess.pickMultiMedia();
    }

    _isLoading = false;
    _refresh();

    if (isNotBlank(files)) {
      _selectedMedia.addAll(files!);
      _refresh();
    }
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h).copyWith(top: 20.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Text(
                    "Cancel",
                    style: AppStyles.of(context).sLarge,
                  ),
                ),
                const Spacer(),
                Text(
                  "Select Media",
                  style: AppStyles.of(context).basic.sLarge.wSemiBold,
                ),
                const Spacer(),
                Text(
                  "Cancel",
                  style:
                      AppStyles.of(context).sLarge.colored(Colors.transparent),
                )
              ],
            ),
          ),
          const Divider(),
          Gap(14.h),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final size = (constraints.biggest.shortestSide - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...(widget.limit != null
                          ? _selectedMedia.take(widget.limit!)
                          : _selectedMedia)
                      .map((e) {
                    return SizedBox.square(
                      dimension: size,
                      child: MultiMediaPicker.container(e, () => _remove(e)),
                    );
                  }),
                  if (widget.limit != null
                      ? _selectedMedia.length < widget.limit!
                      : true)
                    SizedBox.square(
                      dimension: size,
                      child: MultiMediaPicker.addMore(_add),
                    ),
                ],
              );
            }),
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!_isLoading) {
                      Navigator.pop(context, _selectedMedia);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text("Done", style: AppStyles.of(context).sMedium),
                ),
              )
            ],
          ),
          Gap(20.h),
        ],
      ),
    );
  }
}
