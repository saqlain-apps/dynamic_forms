import 'package:flutter/material.dart';

class OverlayHandler {
  final List<OverlayEntry> entries = [];

  void push(OverlayState state, OverlayEntry overlay) {
    entries.add(overlay);
    _insertOverlay(state, overlay);
  }

  void pop() {
    if (entries.isNotEmpty) {
      _removeOverlay(entries.removeLast());
    }
  }

  void remove(OverlayEntry overlay) {
    if (entries.remove(overlay)) {
      _removeOverlay(overlay);
    }
  }

  void clear() {
    for (var overlay in entries) {
      _removeOverlay(overlay);
    }
    entries.clear();
  }

  OverlayEntry createOverlayEntry(Widget child) {
    return OverlayEntry(builder: (context) => child);
  }

  void _removeOverlay(OverlayEntry overlay) {
    overlay.remove();
    overlay.dispose();
  }

  void _insertOverlay(OverlayState state, OverlayEntry overlay) {
    state.insert(overlay);
  }
}
