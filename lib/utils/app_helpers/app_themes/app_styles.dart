// ignore_for_file: overridden_fields

import '../_app_helper_import.dart';

class AppStyles extends TextStyle {
  static AppStyles of(BuildContext context) => AppTheme.of(context).styles;
  static AppStyles ofStatic(BuildContext context) =>
      AppTheme.ofStatic(context).styles;
  //----------------------------------------------------------------------------
  static TextStyle appFont = TextStyle(
    fontSize: SilverAttuner().tFont(14),
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  //----------------------------------------------------------------------------
  AppStyles({TextStyle? basic, AppColors? colors})
      : basic = basic ?? appFont,
        colors = colors ?? AppColors.basic(),
        super(
          color: (basic ?? appFont).color,
          fontSize: (basic ?? appFont).fontSize,
          fontWeight: (basic ?? appFont).fontWeight,
          fontStyle: (basic ?? appFont).fontStyle,
          fontFamily: (basic ?? appFont).fontFamily,
          decoration: (basic ?? appFont).decoration,
          locale: (basic ?? appFont).locale,
          height: (basic ?? appFont).height,
        );
  //----------------------------------------------------------------------------
  final TextStyle basic;
  final AppColors colors;

  TextStyle get error => cRed;
  TextStyle get hint => sMedium.colored(colors.hint);
  TextStyle get label => sMedium;
}
