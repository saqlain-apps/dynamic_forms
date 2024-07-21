import 'package:flutter/material.dart';

part 'responsive_check.dart';

typedef ViewBuilder = Widget Function(BuildContext context, Widget? child);

class ResponsiveViewBuilder extends StatelessWidget {
  const ResponsiveViewBuilder({
    required this.responsive,
    required this.desktop,
    required this.tablet,
    required this.mobile,
    this.child,
    super.key,
  });

  final ResponsiveView responsive;
  final ViewBuilder desktop;
  final ViewBuilder tablet;
  final ViewBuilder mobile;
  final Widget? child;

  ViewBuilder builder(ViewType viewType) => switch (viewType) {
        ViewType.desktop => desktop,
        ViewType.tablet => tablet,
        ViewType.mobile => mobile,
      };

  @override
  Widget build(BuildContext context) {
    var width = responsive._width(context);
    var viewType = responsive._deviceType(width);

    return builder(viewType)(context, child);
  }
}

abstract class ResponsiveView extends ResponsiveCheck {
  const ResponsiveView();
  factory ResponsiveView.portrait() => PortraitView();
  // factory Responsive.landscape() => LandscapeView();

  Widget build({
    required ViewBuilder desktop,
    required ViewBuilder tablet,
    required ViewBuilder mobile,
    Widget? child,
    Key? key,
  }) =>
      ResponsiveViewBuilder(
        key: key,
        responsive: this,
        desktop: desktop,
        tablet: tablet,
        mobile: mobile,
        child: child,
      );
}

class PortraitView extends ResponsiveView {
  @override
  final ViewSizeCheck _check = const ViewSizeCheck(
    mobileMax: 460,
    tabletMax: 960,
    windowDesktopMax: 1200,
  );
}

// class LandscapeView extends ResponsiveView {}
