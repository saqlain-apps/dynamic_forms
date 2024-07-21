import '/utils/app_helpers/_app_helper_import.dart';
import '/utils/app_helpers/app_widgets.dart';
import 'app_popup.dart';

class SelectionPopup<T> extends StatelessWidget {
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required List<T> options,
    required Widget Function(T item) builder,
    Widget? title,
    Widget Function(BuildContext context, Widget child) containerBuilder =
        defaultContainer,
    Widget Function(BuildContext context, int index)? separationBuilder,
  }) {
    return AppPopup.showBottomSheet(
      context,
      child: SelectionPopup<T>(
        options: options,
        builder: builder,
        title: title,
        containerBuilder: containerBuilder,
        separationBuilder: separationBuilder,
      ),
    );
  }

  const SelectionPopup({
    required this.options,
    required this.builder,
    this.title,
    this.containerBuilder = defaultContainer,
    this.separationBuilder,
    super.key,
  });

  final List<T> options;
  final Widget? title;
  final Widget Function(T item) builder;
  final Widget Function(BuildContext context, Widget child) containerBuilder;
  final Widget Function(BuildContext context, int index)? separationBuilder;

  @override
  Widget build(BuildContext context) {
    final separator = (separationBuilder ?? defaultSeparationBuilder);
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      child: containerBuilder(
        context,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[title!, Gap(8.h)],
              ...options
                  .map<Widget>((e) {
                    return GestureDetector(
                      onTap: () => Messenger().navigator.pop(e),
                      child: builder(e),
                    );
                  })
                  .toList()
                  .separated((index) => separator(context, index)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget defaultContainer(BuildContext context, Widget child) => child;

  static Widget defaultSeparationBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: AppWidgets.divider,
    );
  }
}
