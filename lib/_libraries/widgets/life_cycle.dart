import 'package:flutter/widgets.dart';

class LifeCycle extends StatefulWidget {
  const LifeCycle({
    required this.builder,
    this.dispose,
    super.key,
  });

  final void Function()? dispose;
  final Widget Function(BuildContext context) builder;

  @override
  State<LifeCycle> createState() => _LifeCycleState();
}

class _LifeCycleState extends State<LifeCycle> {
  AppLifecycleListener? _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant LifeCycle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dispose != oldWidget.dispose) {
      _dispose();
      _init();
    }
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _init() {
    _lifecycleListener ??= AppLifecycleListener(
      onDetach: widget.dispose,
      onStateChange: onStateChanged,
    );
  }

  void _dispose() {
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
  }

  void onStateChanged(AppLifecycleState state) {
    print(state);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
