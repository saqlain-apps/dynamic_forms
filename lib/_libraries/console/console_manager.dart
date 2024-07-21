import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '/_libraries/widgets/animated_double.dart';
import '/user_interface/render_components/gap/gap.dart';

part 'console_data.dart';
part 'console_view.dart';

class ConsoleManager {
  void init() {
    _controller ??= StreamController<ConsoleData>.broadcast();
    _sub ??= stream.listen((data) => _logs.add(data));
  }

  Sink<ConsoleData> get sink => _controller!.sink;
  Stream<ConsoleData> get stream => _controller!.stream;
  Stream<List<ConsoleData>> get logStream => stream.map((data) => logs);

  List<ConsoleData> get logs => _logs.toList();
  List<String> get prints => logs.map((e) => e.log).toList();

  bool clear([int? count]) {
    bool didClear = false;
    if (count != null) {
      final len = _logs.length;
      if (len <= count) {
        _logs.removeRange(len - count, len);
        didClear = true;
      }
    } else {
      _logs.clear();
      didClear = true;
    }

    if (didClear) {
      sink.add(ConsoleData('Cleared ${count?.toString() ?? 'all'} logs'));
    }

    return didClear;
  }

  StreamSubscription? _sub;
  StreamController<ConsoleData>? _controller;
  final List<ConsoleData> _logs = [];

  void dispose() {
    _sub?.cancel();
    _sub = null;
    _logs.clear();
    _controller?.close();
    _controller = null;
  }
}
