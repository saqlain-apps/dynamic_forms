import '../_app_helper_import.dart';
import 'theme_store.dart';

class AppTheme {
  AppTheme({
    AppStyles? styles,
    AppColors? colors,
  })  : colors = colors ?? AppColors.basic(),
        styles = styles ?? AppStyles(colors: colors ?? AppColors.basic());

  final AppStyles styles;
  final AppColors colors;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppTheme &&
        other.styles == styles &&
        other.colors == colors;
  }

  @override
  int get hashCode => styles.hashCode ^ colors.hashCode;

  static AppTheme of(BuildContext context) => ThemeStore.of(context);
  static AppTheme ofStatic(BuildContext context) =>
      ThemeStore.ofStatic(context);
}
