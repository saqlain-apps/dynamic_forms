import '../_app_helper_import.dart';

class ThemeStore extends InheritedWidget {
  //----------------------------------------------------------------------------
  ThemeStore({
    AppTheme? style,
    required super.child,
    super.key,
  }) : theme = style ?? AppTheme();

  final AppTheme theme;

  static List<ThemeStore> ancestorsOf(BuildContext context,
      [shouldDepend = false]) {
    List<ThemeStore> ancestors = [];

    context.visitAncestorElements((element) {
      if (element.widget.runtimeType == ThemeStore) {
        ancestors.add(element.widget as ThemeStore);
      }
      return true;
    });

    if (shouldDepend) {
      context.dependOnInheritedWidgetOfExactType<ThemeStore>();
    }

    return ancestors;
  }

  static ThemeStore? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeStore>();
  }

  static ThemeStore? maybeOfStatic(BuildContext context) {
    return context.findAncestorWidgetOfExactType<ThemeStore>();
  }

  static AppTheme of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No Theme found in context');
    return result!.theme;
  }

  static AppTheme ofStatic(BuildContext context) {
    final result = maybeOfStatic(context);
    assert(result != null, 'No Theme found in context');
    return result!.theme;
  }

  @override
  bool updateShouldNotify(covariant ThemeStore oldWidget) =>
      theme != oldWidget.theme;
}
