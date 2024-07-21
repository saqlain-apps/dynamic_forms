import 'package:flutter/material.dart';

/// Takes either [item] or [itemBuilder]\
/// atleast one of them are required
///
/// if [shouldDispose] is not false\
/// then auto disposes the [item] it hold\
///
/// can be used in a [StatelessWidget] to dispose stuff
class Disposable<T> extends StatefulWidget {
  const Disposable({
    this.item,
    this.itemBuilder,
    this.shouldDispose = true,
    required this.itemDisposer,
    required this.builder,
    super.key,
  }) : assert(item != null || itemBuilder != null);

  final T? item;
  final T Function()? itemBuilder;
  final void Function(T item) itemDisposer;
  final bool shouldDispose;
  final Widget Function(BuildContext context, T? item) builder;

  @override
  State<Disposable<T>> createState() => _DisposableState<T>();
}

class _DisposableState<T> extends State<Disposable<T>> {
  late T item;

  @override
  void initState() {
    super.initState();
    item = widget.item ?? widget.itemBuilder!();
  }

  @override
  void dispose() {
    if (widget.shouldDispose) {
      widget.itemDisposer(item);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, item);
}
