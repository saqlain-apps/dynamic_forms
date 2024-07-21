import 'package:flutter/material.dart';

import '/_libraries/extensions.dart';
import '../overlay_handler.dart';

enum OverlayAnimationState { open, closed }

sealed class OverlayItem {
  const OverlayItem({
    required this.size,
    required this.child,
  });

  factory OverlayItem.animated({
    required Offset position,
    required Size size,
    required Widget child,
  }) =>
      OverlayAnimatedItem(position: position, size: size, child: child);

  factory OverlayItem.direct({
    required Size size,
    required Widget child,
  }) =>
      OverlayDirectItem(size: size, child: child);

  final Widget child;
  final Size size;
}

class OverlayAnimatedItem extends OverlayItem {
  const OverlayAnimatedItem({
    required this.position,
    required super.size,
    required super.child,
  });

  final Offset position;
}

class OverlayDirectItem extends OverlayItem {
  const OverlayDirectItem({
    required super.size,
    required super.child,
  });
}

class OverlayedStack extends StatefulWidget {
  final OverlayController? controller;

  final Widget Function(
    BuildContext context,
    void Function(List<OverlayItem> items) onTap,
    Animation<double> animation,
    Widget? child,
  ) builder;

  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  )? transitionBuilder;

  final Duration duration;
  final Widget? child;

  const OverlayedStack({
    this.controller,
    required this.builder,
    this.transitionBuilder,
    this.duration = const Duration(milliseconds: 300),
    this.child,
    super.key,
  });

  @override
  State<OverlayedStack> createState() => _OverlayedStackState();
}

class _OverlayedStackState extends State<OverlayedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final OverlayHandler _overlayHandler = OverlayHandler();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _init();
  }

  @override
  void didUpdateWidget(covariant OverlayedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      animationController.duration = widget.duration;
    }

    if (oldWidget.controller != widget.controller) {
      _init();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    animationController.dispose();
    super.dispose();
  }

  void _init() {
    widget.controller?._init(
      forward: _forwardAnimation,
      reverse: _reverseAnimation,
      remove: _directReverse,
      animationController: animationController,
    );
  }

  Animation<Offset> _createPositionAnimation(
    Offset endPoint, [
    Interval? interval,
  ]) {
    var animation = interval == null
        ? animationController
        : CurvedAnimation(parent: animationController, curve: interval);

    var position = Tween(
      begin: _convertToLocal(Offset.zero),
      end: _convertToLocal(endPoint),
    ).animate(animation);
    return position;
  }

  Offset _convertToLocal(Offset position) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset renderZeroOffset = renderBox.localToGlobal(Offset.zero);
    Offset zeroOffset = renderBox.size.center(renderZeroOffset);
    Offset adjustedPosition = zeroOffset + position;
    return adjustedPosition;
  }

  Widget _buildPositioned(
    Animation<Offset> position,
    Size size,
    Widget child,
  ) {
    return Positioned(
      left: position.value.dx - size.width / 2,
      top: position.value.dy - size.height / 2,
      child: child,
    );
  }

  Widget _buildItem(OverlayItem item) {
    return switch (item) {
      OverlayAnimatedItem() => _buildAnimatedItem(item),
      OverlayDirectItem() => _buildDirectItem(item),
    };
  }

  Widget _buildDirectItem(OverlayDirectItem item) {
    return SizedBox.fromSize(size: item.size, child: item.child);
  }

  Widget _buildAnimatedItem(OverlayAnimatedItem item) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        Widget result = child!;

        if (widget.transitionBuilder != null) {
          result = widget.transitionBuilder!(
            context,
            animationController,
            result,
          );
        }

        result = _buildPositioned(
          _createPositionAnimation(item.position),
          item.size,
          result,
        );

        return result;
      },
      child: item.child,
    );
  }

  OverlayEntry _createOverlayEntry(List<OverlayItem> items) {
    var children = items.reversed.map(_buildItem).toList();
    var child = Stack(children: children);
    return _overlayHandler.createOverlayEntry(child);
  }

  Future<void> _forwardAnimation(List<OverlayItem> items) async {
    var overlay = _createOverlayEntry(items);
    animationController.forward();
    _overlayHandler.push(Overlay.of(context), overlay);
  }

  Future<void> _reverseAnimation() async {
    await animationController.reverse();
    _removeOverlay();
  }

  Future<void> _directReverse() async {
    animationController.value = 0;
    _removeOverlay();
  }

  void _removeOverlay() async {
    _overlayHandler.pop();
  }

  void _onTap(List<OverlayItem> items) async {
    if (animationController.isForward) {
      _reverseAnimation();
    } else {
      _forwardAnimation(items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return widget.builder(
          context,
          _onTap,
          animationController,
          widget.child,
        );
      },
    );
  }
}

class OverlayController {
  Future<void> Function(List<OverlayItem> items)? _forward;
  Future<void> Function()? _reverse;
  Future<void> Function()? _remove;
  AnimationController? _animationController;

  void _init({
    required Future<void> Function(List<OverlayItem> items) forward,
    required Future<void> Function() reverse,
    required Future<void> Function() remove,
    required AnimationController animationController,
  }) {
    _forward = forward;
    _reverse = reverse;
    _remove = remove;
    _animationController = animationController;
  }

  Future<void> open(List<OverlayItem> items) async => _forward?.call(items);
  Future<void> close() async => _reverse?.call();
  Future<void> directClose() async => _remove?.call();
  Future<void> move(List<OverlayItem> items) async {
    if (isConnected) {
      isOpen ? await close() : await open(items);
    }
  }

  Animation<double>? get animation => _animationController?.view;
  bool get isOpen => animation?.value == 0;
  bool get isClosed => animation?.value == 1;
  bool get isConnected => animation != null;
}
