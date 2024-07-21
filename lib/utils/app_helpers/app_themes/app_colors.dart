import '../_app_helper_import.dart';

class AppColors {
  factory AppColors() => instance;
  static const AppColors instance = AppColors.create();
  factory AppColors.basic() => const AppColors.create();
  const AppColors.create();

  static const Color lightBlack = Color(0xff272727);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static const Color grey = Colors.grey;

  Color get scaffoldBackground => Colors.grey[50]!;
  Color get transparent => Colors.transparent;

  // Custom Colors
  Color get primary => const Color(0xff33BEE7);
  Color get secondary => const Color.fromARGB(255, 150, 218, 239);
  Color get divider => const Color(0xffEBEBEB);
  Color get disabled => Colors.blueGrey;
  Color get hint => grey;
  Color get correct => Colors.green;
  Color get incorrect => Colors.red;

  //----------------------------------------------------------------------------
  // Color Functions
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  /// Mix two colors.
  ///- By default [color2] is black.
  ///- The optimal opacity of color1 is 0.18
  static Color mixColor(Color color1, [Color color2 = Colors.black]) {
    return Color.alphaBlend(color1, color2);
  }

  /// Check if the color is Light or Dark
  static bool isLight(Color color) {
    var grayscale =
        (0.299 * color.red) + (0.587 * color.green) + (0.114 * color.blue);

    return grayscale > 128;
  }

  static AppColors of(BuildContext context) => AppTheme.of(context).colors;
  static AppColors ofStatic(BuildContext context) =>
      AppTheme.ofStatic(context).colors;
  //----------------------------------------------------------------------------
}
