import 'dart:math';

import 'package:flutter/material.dart';

typedef Tuner = double Function(TuningSizes sizes);

class TuningSizes {
  const TuningSizes({
    required this.size,
    required this.designSize,
    required this.screenSize,
  });

  final num size;
  final Size designSize;
  final Size screenSize;

  double get widthRatio => screenSize.width / designSize.width;
  double get heightRatio => screenSize.height / designSize.height;

  double get diagonalRatio => widthRatio * heightRatio;
  double get radiusRatio => min(widthRatio, heightRatio);
  double get diameterRatio => max(widthRatio, heightRatio);
}

class SilverAttuner {
  SilverAttuner._internal();
  static final _instance = SilverAttuner._internal();
  factory SilverAttuner() => _instance;
  //----------------------------------------------------------------------------

  static void init(BuildContext context, Size size) {
    _instance._designSize = size;
    _instance._screenSize = MediaQuery.of(context).size;
  }

  // Font Size
  static double fontSizeTuning(TuningSizes sizes) {
    return widthTuning(sizes);
  }

  double tFont(num size) => tune(size, fontSizeTuning);

  // Width
  static double widthTuning(TuningSizes sizes) {
    return sizes.size * sizes.widthRatio;
  }

  double tWidth(num size) => tune(size, widthTuning);

  // Height
  static double heightTuning(TuningSizes sizes) {
    return sizes.size * sizes.heightRatio;
  }

  double tHeight(num size) => tune(size, heightTuning);

  // Radius
  static double radiusTuning(TuningSizes sizes) {
    return sizes.size * sizes.radiusRatio;
  }

  double tRadius(num size) => tune(size, radiusTuning);

  //----------------------------------------------------------------------------

  Size? _designSize;
  Size? _screenSize;

  bool get _isInitialized =>
      _instance._screenSize != null && _instance._designSize != null;

  double tune(num size, Tuner tuner) {
    if (!_isInitialized) return size.toDouble();
    return tuner(_sizes(size));
  }

  TuningSizes _sizes(num size) => TuningSizes(
        size: size,
        designSize: _designSize!,
        screenSize: _screenSize!,
      );
}

extension SilverCustomizationsExtension on TextStyle {
  //----------------------------------------------------------------------------
  // Font Size Customizations
  //----------------------------------------------------------------------------
  /// FontSize: 10
  TextStyle get sExtraSmall => sized(10);

  /// FontSize: 12
  TextStyle get sSmall => sized(12);

  /// FontSize: 14
  TextStyle get sRegular => sized(14);

  /// FontSize: 16
  TextStyle get sMedium => sized(16);

  /// FontSize: 18
  TextStyle get sLarge => sized(18);

  /// FontSize: 22
  TextStyle get sExtraLarge => sized(22);

  /// Custom
  TextStyle sized(double size) =>
      copyWith(fontSize: SilverAttuner().tFont(size));
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Font Weight Customizations
  //----------------------------------------------------------------------------
  /// FontWeight: w300
  TextStyle get wLight => weighted(FontWeight.w300);

  /// FontWeight: w400
  TextStyle get wRegular => weighted(FontWeight.w400);

  /// FontWeight: w500
  TextStyle get wSemiBold => weighted(FontWeight.w500);

  /// FontWeight: w600
  TextStyle get wBold => weighted(FontWeight.w600);

  /// FontWeight: w700
  TextStyle get wBolder => weighted(FontWeight.w700);

  /// FontWeight: w900
  TextStyle get wBlock => weighted(FontWeight.w900);

  /// Custom
  TextStyle weighted(FontWeight weight) => copyWith(fontWeight: weight);
  TextStyle varyWeight(double weight) =>
      variations(FontVariation.weight(weight));
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Font Color Customizations
  //----------------------------------------------------------------------------
  /// FontColor: Red
  TextStyle get cRed => colored(Colors.red);

  /// FontColor: White
  TextStyle get cWhite => colored(Colors.white);

  /// FontColor: Grey
  TextStyle get cGrey => colored(Colors.grey);

  /// FontColor: Black
  TextStyle get cBlack => colored(Colors.black);

  /// Custom
  TextStyle colored(Color? color) => copyWith(color: color);
  TextStyle opacity(double opacity) =>
      copyWith(color: color?.withOpacity(opacity));
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Other Font Customizations
  //----------------------------------------------------------------------------
  /// FontHeight: 1.25
  TextStyle get fhMediumHigh => copyWith(height: 1.25);

  /// FontHeight: 1.5
  TextStyle get fhHigh => copyWith(height: 1.5);

  /// FontDecoration: Underlined
  TextStyle get fdUnderlined => copyWith(decoration: TextDecoration.underline);
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Variable Fonts
  //----------------------------------------------------------------------------
  TextStyle variations(FontVariation variation) =>
      copyWith(fontVariations: [variation]);
  TextStyle addVariations(FontVariation variation) =>
      copyWith(fontVariations: [...(fontVariations ?? []), variation]);
  //----------------------------------------------------------------------------
}

extension SizeExtension on num {
  double get w => SilverAttuner().tWidth(this);
  double get h => SilverAttuner().tHeight(this);
  double get r => SilverAttuner().tRadius(this);
  double get sp => SilverAttuner().tFont(this);

  ///smart size :  it check your value - if it is bigger than your value it will set your value
  ///for example, you have set 16.sm() , if for your screen 16.sp() is bigger than 16 , then it will set 16 not 16.sp()
  ///I think that it is good for save size balance on big sizes of screen
  double get spMin => min(toDouble(), sp);

  double get spMax => max(toDouble(), sp);
}

extension EdgeInsetsExtension on EdgeInsets {
  /// Creates adapt insets using r [SizeExtension].
  EdgeInsets get r => copyWith(
        top: top.r,
        bottom: bottom.r,
        right: right.r,
        left: left.r,
      );

  EdgeInsets get w => copyWith(
        top: top.w,
        bottom: bottom.w,
        right: right.w,
        left: left.w,
      );

  EdgeInsets get h => copyWith(
        top: top.h,
        bottom: bottom.h,
        right: right.h,
        left: left.h,
      );

  EdgeInsets get hw => copyWith(
        top: top.h,
        bottom: bottom.h,
        right: right.w,
        left: left.w,
      );
}

extension BorderRaduisExtension on BorderRadius {
  /// Creates adapt BorderRadius using r [SizeExtension].
  BorderRadius get r => copyWith(
        bottomLeft: bottomLeft.r,
        bottomRight: bottomRight.r,
        topLeft: topLeft.r,
        topRight: topRight.r,
      );

  BorderRadius get w => copyWith(
        bottomLeft: bottomLeft.w,
        bottomRight: bottomRight.w,
        topLeft: topLeft.w,
        topRight: topRight.w,
      );

  BorderRadius get h => copyWith(
        bottomLeft: bottomLeft.h,
        bottomRight: bottomRight.h,
        topLeft: topLeft.h,
        topRight: topRight.h,
      );
}

extension RadiusExtension on Radius {
  /// Creates adapt Radius using r [SizeExtension].
  Radius get r => Radius.elliptical(x.r, y.r);
  Radius get w => Radius.elliptical(x.w, y.w);
  Radius get h => Radius.elliptical(x.h, y.h);
}

extension BoxConstraintsExtension on BoxConstraints {
  /// Creates adapt BoxConstraints using r [SizeExtension].
  BoxConstraints get r => copyWith(
        maxHeight: maxHeight.r,
        maxWidth: maxWidth.r,
        minHeight: minHeight.r,
        minWidth: minWidth.r,
      );

  /// Creates adapt BoxConstraints using h-w [SizeExtension].
  BoxConstraints get hw => copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.w,
        minHeight: minHeight.h,
        minWidth: minWidth.w,
      );

  BoxConstraints get w => copyWith(
        maxHeight: maxHeight.w,
        maxWidth: maxWidth.w,
        minHeight: minHeight.w,
        minWidth: minWidth.w,
      );

  BoxConstraints get h => copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.h,
        minHeight: minHeight.h,
        minWidth: minWidth.h,
      );
}
