import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '/utils/app_helpers/_app_helper_import.dart';
import '../../overlay_handler.dart';
import '../scoped.dart';

part 'notification_controller.dart';

class NotificationManager extends StatefulWidget {
  const NotificationManager({
    required this.controller,
    required this.child,
    super.key,
  });

  final NotificationController controller;
  final Widget child;

  @override
  State<NotificationManager> createState() => _NotificationManagerState();
}

class _NotificationManagerState extends State<NotificationManager>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller._init(this);
  }

  @override
  void didUpdateWidget(covariant NotificationManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      widget.controller._init(this, oldWidget.controller._overlayHandler);
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scoped<NotificationController>.static(
      state: widget.controller,
      child: widget.child,
    );
  }
}
