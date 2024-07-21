import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '/utils/task_handler/task_handler.dart';
import 'app_video.dart';

class VideoAutoPlay extends StatefulWidget {
  const VideoAutoPlay({
    required this.video,
    required this.videoSource,
    required this.builder,
    this.initialize,
    this.debounceMilliseconds = 400,
    this.autoPlay = true,
    super.key,
  });

  final String video;
  final DataSourceType videoSource;
  final int debounceMilliseconds;
  final bool autoPlay;
  final void Function(
    BuildContext context,
    AppVideoController player,
  )? initialize;
  final Widget Function(
    BuildContext context,
    AppVideo video,
    AppVideoController player,
  ) builder;

  @override
  State<VideoAutoPlay> createState() => _VideoAutoPlayState();
}

class _VideoAutoPlayState extends State<VideoAutoPlay> {
  late TimedTaskHandler _videoPlayDebouncer;
  late AppVideoController _controller;

  @override
  void initState() {
    super.initState();
    _videoPlayDebouncer = TimedTaskHandler(widget.debounceMilliseconds);
    _init();
    _play();
  }

  @override
  void activate() {
    super.activate();
    _controller.initialize();
  }

  @override
  void didUpdateWidget(covariant VideoAutoPlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.debounceMilliseconds != oldWidget.debounceMilliseconds) {
      _videoPlayDebouncer.reset();
      _videoPlayDebouncer = TimedTaskHandler(widget.debounceMilliseconds);
    }

    if (widget.video != oldWidget.video ||
        widget.videoSource != oldWidget.videoSource) {
      _controller.dispose();
      _init();
    }
  }

  @override
  void deactivate() {
    _release();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _init() async {
    _controller = AppVideoController.withSource(
      source: widget.video,
      sourceType: widget.videoSource,
    );
    await _controller.initialize();
    if (mounted) widget.initialize?.call(context, _controller);
  }

  void _play() {
    if (widget.autoPlay) {
      _videoPlayDebouncer.handle(_controller.resume);
    }
  }

  void _release() {
    _videoPlayDebouncer.reset();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.release();
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(_controller.hashCode.toString()),
      onVisibilityChanged: (info) {
        if (info.visibleFraction.round() == 0) {
          _release();
        } else {
          _controller.initialize();
        }
      },
      child: widget.builder(
        context,
        AppVideo(controller: _controller),
        _controller,
      ),
    );
  }
}
