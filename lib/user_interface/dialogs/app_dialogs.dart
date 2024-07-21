import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '/_libraries/media_access.dart';
import '/_libraries/web_functions/web_functions.dart';
import '/utils/app_helpers/_app_helper_import.dart';

class DialogOptions<T> {
  const DialogOptions(
    this.option, {
    required this.onTap,
    this.isDestructive = false,
    this.textColor,
  });

  final String option;
  final Color? textColor;
  final bool isDestructive;
  final T Function(BuildContext context) onTap;

  Widget buildText(BuildContext context) {
    return Text(
      option,
      style: AppStyles.of(context)
          .sMedium
          .colored(textColor ?? (isDestructive ? Colors.red : Colors.black)),
    );
  }
}

class AppDialogs {
  static Future<T?> showAdaptiveBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) async {
    final platform = WebFunctions().operatingSystem;
    dynamic result;
    if (platform == OperatingPlatform.ios) {
      result = await showCupertinoModalPopup(
        context: context,
        builder: builder,
      );
    } else {
      result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          side: BorderSide.none,
        ),
        clipBehavior: Clip.hardEdge,
        builder: builder,
        useRootNavigator: true,
      );
    }

    return result;
  }

  static Widget Function(BuildContext context) buildAdaptive({
    required List<DialogOptions> actions,
    String? title,
    DialogOptions? cancel,
  }) {
    return (context) {
      final platform = WebFunctions().operatingSystem;

      void onTap(DialogOptions option) {
        final future = Completer<dynamic>();
        Navigator.of(context).pop(future.future);
        future.complete(option.onTap(context));
      }

      Widget buildAndroid(DialogOptions option) {
        return ListTile(
          onTap: () => onTap(option),
          titleAlignment: ListTileTitleAlignment.center,
          title: Center(child: option.buildText(context)),
        );
      }

      Widget buildIos(DialogOptions option, {bool isDefault = false}) {
        return CupertinoActionSheetAction(
          onPressed: () => onTap(option),
          isDefaultAction: isDefault,
          isDestructiveAction: option.isDestructive,
          child: option.buildText(context),
        );
      }

      final android = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isNotBlank(title)
              ? Column(
                  children: [
                    Gap(6.h),
                    Text(title!),
                    const Divider(),
                  ],
                )
              : const SizedBox(),
          // Gap(16.h),
          ...actions.map(buildAndroid),
          if (cancel != null) ...[
            const Divider(),
            buildAndroid(cancel),
          ],
          Gap(8.h),
        ],
      );

      final ios = CupertinoActionSheet(
        title: isNotBlank(title) ? Text(title!) : null,
        cancelButton: cancel != null ? buildIos(cancel, isDefault: true) : null,
        actions: actions.map(buildIos).toList(),
      );

      return platform == OperatingPlatform.ios ? ios : android;
    };
  }

  static Future<T?> showAdaptiveConfirmation<T>(
    BuildContext context, {
    String? title,
    required DialogOptions<T> negative,
    required DialogOptions<T> positive,
  }) async {
    final buildTitle = title != null
        ? Text(title, style: AppStyles.of(context).sMedium.wLight)
        : null;

    final positiveChild = Text(
      positive.option,
      style: AppStyles.of(context)
          .sMedium
          .colored(positive.isDestructive ? AppColors.red : AppColors.black),
    );

    final negativeChild = Text(
      negative.option,
      style: AppStyles.of(context)
          .sMedium
          .colored(negative.isDestructive ? AppColors.red : AppColors.black),
    );

    return showDialog<T>(
      context: context,
      builder: (context) {
        final platform = WebFunctions().operatingSystem;

        final android = AlertDialog(
          title: buildTitle,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    final res = negative.onTap(context);
                    Navigator.of(context).pop(res);
                  },
                  child: negativeChild,
                ),
                GestureDetector(
                  onTap: () {
                    final res = positive.onTap(context);
                    Navigator.of(context).pop(res);
                  },
                  child: positiveChild,
                ),
              ],
            ),
          ],
        );

        final ios = CupertinoAlertDialog(
          title: buildTitle,
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                final res = negative.onTap(context);
                Navigator.of(context).pop(res);
              },
              isDestructiveAction: negative.isDestructive,
              child: negativeChild,
            ),
            CupertinoDialogAction(
              onPressed: () {
                final res = positive.onTap(context);
                Navigator.of(context).pop(res);
              },
              isDestructiveAction: positive.isDestructive,
              child: positiveChild,
            ),
          ],
        );

        return platform == OperatingPlatform.ios ? ios : android;
      },
    );
  }

  static Future<bool?> adaptiveConfirmation(
    BuildContext context, {
    String? title,
  }) {
    return showAdaptiveConfirmation<bool>(
      context,
      title: title,
      negative: DialogOptions<bool>(
        'No',
        onTap: (context) => false,
      ),
      positive: DialogOptions<bool>(
        'Yes',
        isDestructive: true,
        onTap: (context) => true,
      ),
    );
  }

  static Future<DateTime?> showAdaptiveDatePicker(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? maximumDate,
    DateTime? minimumDate,
  }) async {
    final platform = WebFunctions().operatingSystem;
    final now = DateTime.now();
    DateTime? selectedDate;

    if (platform == OperatingPlatform.ios) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoDatePicker(
            onDateTimeChanged: (DateTime value) {
              selectedDate = value;
            },
            dateOrder: DatePickerDateOrder.dmy,
            itemExtent: 70,
            initialDateTime: initialDate ?? now,
            mode: CupertinoDatePickerMode.date,
            maximumDate: maximumDate ?? now,
            minimumDate: minimumDate ?? DateTime(1900),
          );
        },
      );
    } else {
      selectedDate = await showDatePicker(
        context: context,
        firstDate: minimumDate ?? DateTime(1900),
        lastDate: maximumDate ?? now,
        initialDate: initialDate ?? now,
        currentDate: now,
      );
    }

    return selectedDate;
  }

  static Future<DateTime?> showAdaptiveTimePicker(
    BuildContext context, {
    required DateTime initialTime,
  }) async {
    final platform = WebFunctions().operatingSystem;
    DateTime? selectedDate;
    if (platform == OperatingPlatform.ios) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoDatePicker(
            onDateTimeChanged: (DateTime value) {
              selectedDate = value;
            },
            itemExtent: 70,
            initialDateTime: initialTime,
            mode: CupertinoDatePickerMode.time,
          );
        },
      );
    } else {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialTime),
      );

      if (selectedTime != null) {
        selectedDate = DateTime(
          initialTime.year,
          initialTime.month,
          initialTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return selectedDate;
  }

  static Future<DateTime?> showAdaptiveDateTimePicker(
    BuildContext context, {
    DateTime? initialTime,
  }) async {
    final platform = WebFunctions().operatingSystem;
    DateTime? selectedDate;
    final now = DateTime.now();

    if (platform == OperatingPlatform.ios) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoDatePicker(
            onDateTimeChanged: (DateTime value) {
              selectedDate = value;
            },
            dateOrder: DatePickerDateOrder.dmy,
            itemExtent: 70,
            initialDateTime: initialTime,
            mode: CupertinoDatePickerMode.dateAndTime,
            maximumDate: now,
          );
        },
      );
    } else {
      selectedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        lastDate: now,
        initialDate: initialTime,
        currentDate: now,
      );

      if (selectedDate != null && context.mounted) {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: initialTime != null
              ? TimeOfDay.fromDateTime(initialTime)
              : TimeOfDay.fromDateTime(now),
        );

        if (selectedTime != null) {
          selectedDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          if (selectedDate.isAfter(now)) {
            selectedDate = now;
          }
        }
      }
    }

    return selectedDate;
  }

  static Future<XFile?> pickImage(BuildContext context) async {
    XFile? file;

    final mediaAccess = getit.get<MediaAccess>();

    final gallery = DialogOptions(
      "Gallery",
      textColor: Colors.blue,
      onTap: (context) => mediaAccess.pickImage(ImageSource.gallery),
    );

    final camera = DialogOptions(
      'Camera',
      textColor: Colors.blue,
      onTap: (context) => mediaAccess.pickImage(ImageSource.camera),
    );

    file = await showAdaptiveBottomSheet<XFile?>(
      context: context,
      builder: buildAdaptive(
        title: "Select Photo",
        actions: [gallery, camera],
      ),
    );

    return file;
  }
}
