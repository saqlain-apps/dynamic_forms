import '_app_helper_import.dart';

abstract class AppWidgets {
  static const Widget divider = Divider(
    thickness: 1,
    height: 1,
    color: Colors.grey,
  );

  static const Widget kSmallVerticalPad =
      SizedBox(height: AppConstants.kSmallSpace);
  static const Widget kDefaultVerticalPad =
      SizedBox(height: AppConstants.kDefaultSpace);
}
