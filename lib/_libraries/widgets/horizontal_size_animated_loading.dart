import 'package:flutter/material.dart';

import '../../user_interface/render_components/empty/empty.dart';

class HorizontalSizeAnimatedLoading extends ImplicitlyAnimatedWidget {
  const HorizontalSizeAnimatedLoading({
    required this.child,
    required this.parent,
    this.loader,
    this.isLoading = false,
    super.duration = const Duration(milliseconds: 300),
    super.key,
  });

  final bool isLoading;

  final Widget child;
  final Widget? loader;
  final Widget Function(BuildContext context, Widget child) parent;

  @override
  AnimatedWidgetBaseState<HorizontalSizeAnimatedLoading> createState() =>
      _LoadingButtonState();
}

class _LoadingButtonState
    extends AnimatedWidgetBaseState<HorizontalSizeAnimatedLoading> {
  Tween<double>? _loadingValue;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _loadingValue = visitor(_loadingValue, widget.isLoading ? 1.0 : 0.0,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double height =
            (constraints.maxHeight.isFinite) ? constraints.maxHeight : 32;

        var currentLoadingValue = _loadingValue!.evaluate(animation);
        var width = Tween<double>(
          begin: constraints.maxWidth,
          end: height,
        ).transform(currentLoadingValue);

        return SizedBox(
          height: height,
          width: width,
          child: widget.parent(
            context,
            switch (currentLoadingValue) {
              0 => widget.child,
              1 => widget.loader ?? const CircularProgressIndicator(),
              _ => nothing,
            },
          ),
        );
      },
    );
  }
}
