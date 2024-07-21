import 'package:flutter/material.dart';

typedef ShiftViewBuilder = Widget Function(
  BuildContext context,
  void Function([dynamic argument]) shiftA,
  void Function([dynamic argument]) shiftB,
  dynamic argument,
);

class ShiftView extends StatefulWidget {
  const ShiftView({
    required this.viewA,
    required this.viewB,
    super.key,
  });

  final ShiftViewBuilder viewA;
  final ShiftViewBuilder viewB;

  @override
  State<ShiftView> createState() => _ShiftViewState();
}

class _ShiftViewState extends State<ShiftView> {
  late ShiftViewBuilder _currentView;
  dynamic _argument;

  @override
  void initState() {
    super.initState();
    _currentView = widget.viewA;
  }

  @override
  void didUpdateWidget(covariant ShiftView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentView == oldWidget.viewA) {
      _currentView = widget.viewA;
    } else if (_currentView == oldWidget.viewB) {
      _currentView = widget.viewB;
    }
  }

  void _refresh() => setState(() {});

  void shiftA([dynamic argument]) {
    _argument = argument;
    _currentView = widget.viewA;
    _refresh();
  }

  void shiftB([dynamic argument]) {
    _argument = argument;
    _currentView = widget.viewB;
    _refresh();
  }

  void shift() {
    if (_currentView == widget.viewA) {
      _currentView = widget.viewB;
    } else if (_currentView == widget.viewB) {
      _currentView = widget.viewA;
    }
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return _currentView(context, shiftA, shiftB, _argument);
  }
}
