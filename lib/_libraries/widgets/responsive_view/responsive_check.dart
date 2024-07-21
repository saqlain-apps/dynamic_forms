part of 'responsive_view.dart';

enum ViewType { mobile, tablet, desktop }

abstract class ResponsiveCheck {
  const ResponsiveCheck();

  ViewSizeCheck get _check;

  ViewSizeMap check() => ViewSizeMap(_check);
  ViewType deviceType(BuildContext context) => _deviceType(_width(context));

  double _width(BuildContext context) => MediaQuery.of(context).size.width;
  ViewType _deviceType(double width) => switch (width) {
        _ when (_check.isMobile(width)) => ViewType.mobile,
        _ when (_check.isTablet(width)) => ViewType.tablet,
        _ when (_check.isDesktop(width)) => ViewType.desktop,
        _ => ViewType.desktop,
      };
}

class ViewSizeMap {
  const ViewSizeMap(this._check);
  final ViewSizeCheck _check;

  double _width(BuildContext context) => MediaQuery.of(context).size.width;

  bool isMobile(BuildContext context) => _check.isMobile(_width(context));
  bool isTablet(BuildContext context) => _check.isTablet(_width(context));
  bool isDesktop(BuildContext context) => _check.isDesktop(_width(context));
  bool isWindowedDesktop(BuildContext context) =>
      _check.isWindowedDesktop(_width(context));
  bool isFullDesktop(BuildContext context) =>
      _check.isFullDesktop(_width(context));
}

class ViewSizeCheck {
  const ViewSizeCheck({
    required this.mobileMax,
    required this.tabletMax,
    required this.windowDesktopMax,
  });

  final double mobileMax;
  final double tabletMax;
  final double windowDesktopMax;

  bool isMobile(double width) => width <= mobileMax;
  bool isTablet(double width) => width > mobileMax && width <= tabletMax;
  bool isDesktop(double width) => width > tabletMax;
  bool isWindowedDesktop(double width) =>
      width > tabletMax && width <= windowDesktopMax;
  bool isFullDesktop(double width) => width > windowDesktopMax;
}

enum ViewSize { mobile, tablet, desktop, windowedDesktop, fullDesktop }
