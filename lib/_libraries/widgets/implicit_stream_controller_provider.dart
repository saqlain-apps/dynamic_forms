import 'dart:async';

import 'package:flutter/material.dart';

/// Stream Controller Provider
///
/// Creates a new StreamController\
/// Provides a Builder Method to build UI based on streamData
///
/// Also has a child Parameter\
/// to provide a separate widget subtree which doesnt need to change
/// on rebuilds
///
/// AutoDisposes StreamController
class ImplicitStreamControllerProvider<T> extends StatefulWidget {
  const ImplicitStreamControllerProvider({
    required this.builder,
    this.initalData,
    this.child,
    super.key,
  });

  final Widget Function(
    BuildContext context,
    StreamSink<T> sink,
    AsyncSnapshot<T> snapshot,
    Widget? child,
  ) builder;
  final T? initalData;
  final Widget? child;

  @override
  State<ImplicitStreamControllerProvider<T>> createState() =>
      _ImplicitStreamControllerProviderState();
}

class _ImplicitStreamControllerProviderState<T>
    extends State<ImplicitStreamControllerProvider<T>> {
  late final StreamController<T> _controller = StreamController();

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: _controller.stream,
      initialData: widget.initalData,
      builder: (context, snapshot) {
        return widget.builder(
          context,
          _controller.sink,
          snapshot,
          widget.child,
        );
      },
    );
  }
}
