part of 'console_manager.dart';

class ConsoleView extends StatefulWidget {
  const ConsoleView({
    required this.manager,
    required this.child,
    this.options,
    this.sliderPosition = 100,
    super.key,
  });

  final double sliderPosition;

  final ConsoleManager manager;
  final Widget Function(
    BuildContext context,
    ConsoleManager manager,
    VoidCallback refresh,
  )? options;
  final Widget child;

  @override
  State<ConsoleView> createState() => _ConsoleViewState();
}

class _ConsoleViewState extends State<ConsoleView> {
  final TextEditingController _controller = TextEditingController();
  late final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _open = ValueNotifier(false);

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _open.dispose();
    super.dispose();
  }

  void refresh() => setState(() {});

  Color get _backgroundColor => Colors.black.withOpacity(0.8);
  Duration get _animationDuration => const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        widget.child,
        _animatedListenableBuilder<bool>(
          listenable: _open,
          rangeConverter: (data) => data ? 1 : 0,
          builder: (context, value, _) {
            return Positioned(
              top: widget.sliderPosition,
              right: _transformAnimation(value, width - 36, 64 - 36),
              width: 36,
              child: _slider(
                isOpen: value.round() == 1,
                onTap: () {
                  _open.value = !_open.value;
                },
              ),
            );
          },
        ),
        _animatedListenableBuilder<bool>(
          listenable: _open,
          rangeConverter: (data) => data ? 1 : 0,
          builder: (context, value, _) {
            return Positioned.fill(
              right: _transformAnimation(value, width, 64),
              child: _view(
                isOpen: value.round() == 1,
                onClear: widget.manager.clear,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _slider({required bool isOpen, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(8),
          ),
        ),
        child: Icon(
          isOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _view({required bool isOpen, required VoidCallback onClear}) {
    return Material(
      color: _backgroundColor,
      child: SafeArea(
        child: Offstage(
          offstage: !isOpen,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                StreamBuilder<List<ConsoleData>>(
                  initialData: widget.manager.logs,
                  stream: widget.manager.logStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data!;
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          sliver: SliverList.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) => data[index].view,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                    bottom: 12,
                    right: 12,
                    left: 12,
                    child: _animatedListenableBuilder<bool>(
                      listenable: _open,
                      rangeConverter: (data) => data ? 1 : 0,
                      builder: (context, value, _) {
                        return Offstage(
                          offstage: value != 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: widget.options?.call(
                                        context, widget.manager, refresh) ??
                                    const SizedBox.shrink(),
                              ),
                              const Gap(8),
                              IconButton(
                                onPressed: onClear,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(Icons.clear_all),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _animatedListenableBuilder<T>({
    required ValueNotifier<T> listenable,
    required double Function(T data) rangeConverter,
    required Widget Function(BuildContext context, double value, Widget? child)
        builder,
    Widget Function(BuildContext context, T data, Widget? child)? childBuilder,
    Widget? child,
  }) {
    return ValueListenableBuilder<T>(
      valueListenable: listenable,
      builder: (context, data, child) {
        return AnimatedDouble(
          duration: _animationDuration,
          value: rangeConverter(data),
          builder: (context, value, _, __, child) =>
              builder(context, value, child),
          child: childBuilder?.call(context, data, child) ?? child,
        );
      },
      child: child,
    );
  }

  double _transformAnimation(double value, double min, double max) {
    return min + value * (max - min);
  }
}
