import 'package:flutter/material.dart';

class Rebuilder extends StatefulWidget {
  const Rebuilder({
    required this.builder,
    this.child,
    super.key,
  });

  final Widget Function(
    BuildContext context,
    VoidCallback reload,
    Widget? child,
  ) builder;

  final Widget? child;

  @override
  State<Rebuilder> createState() => _RebuilderState();
}

class _RebuilderState extends State<Rebuilder> {
  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, reload, widget.child);
}
