import '/utils/app_helpers/_app_helper_import.dart';

class AppPopup<T> extends StatelessWidget {
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16),
    Color backgroundColor = Colors.white,
    required Widget child,
  }) {
    return showAdaptiveDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AppPopup<T>(
          padding: padding,
          backgroundColor: backgroundColor,
          child: child,
        );
      },
    );
  }

  const AppPopup({
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = Colors.white,
    required this.child,
    super.key,
  });

  final EdgeInsets padding;
  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: padding,
          child: Material(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15.r),
            clipBehavior: Clip.hardEdge,
            child: child,
          ),
        ),
      ),
    );
  }
}
