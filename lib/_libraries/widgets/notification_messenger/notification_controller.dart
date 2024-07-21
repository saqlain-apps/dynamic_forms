part of 'notification_manager.dart';

abstract class NotificationController extends _NotificationController {
  static NotificationController of(BuildContext context) {
    return Scoped.maybeOfStatic<NotificationController>(context)!;
  }
}

abstract class _NotificationController {
  bool _isDisposed = false;
  Duration get duration => const Duration(milliseconds: 800);
  Duration get animationDuration => const Duration(milliseconds: 300);
  OverlayState get overlayState;
  late final OverlayHandler _overlayHandler;
  late final TickerProvider _tickerProvider;
  final List<_NotificationResource> _resources = [];

  void _init(
    TickerProvider tickerProvider, [
    OverlayHandler? overlayHandler,
  ]) {
    _tickerProvider = tickerProvider;
    _overlayHandler = overlayHandler ?? OverlayHandler();
  }

  void push(Widget Function(AnimationController animation) builder) {
    if (_isDisposed) return;

    var animationController = AnimationController(
      vsync: _tickerProvider,
      duration: animationDuration,
    );

    var child = builder(animationController);
    var overlay = _createOverlay(child);

    var resource = _NotificationResource(
      controller: animationController,
      overlay: overlay,
    );

    _startTimer(resource);
    animationController.forward();
    _overlayHandler.push(overlayState, overlay);
  }

  void _startTimer(_NotificationResource resource) {
    _resources.add(resource);

    void remove() {
      if (!resource.isDisposed) {
        _overlayHandler.remove(resource.overlay);
        resource.controller.dispose();
        _resources.remove(resource);
        resource.isDisposed = true;
      }
    }

    resource.remove = () async {
      if (!resource.isDisposed) {
        await resource.controller.reverse();
        remove();
      }
    };

    var timer = Timer(duration + animationDuration, resource.remove!);
    resource.timer = timer;
    resource.dispose = () {
      resource.timer!.cancel();
      remove();
    };
  }

  OverlayEntry _createOverlay(Widget child) {
    return _overlayHandler.createOverlayEntry(child);
  }

  void dispose() {
    for (var resource in _resources) {
      resource.dispose!();
    }
    _isDisposed = true;
  }
}

class _NotificationResource {
  _NotificationResource({required this.controller, required this.overlay});

  final AnimationController controller;
  final OverlayEntry overlay;

  VoidCallback? remove;
  VoidCallback? dispose;
  Timer? timer;

  bool isDisposed = false;
}
