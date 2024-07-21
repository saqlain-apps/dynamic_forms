// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '/utils/app_helpers/_app_helper_import.dart';

class AppVideo extends StatefulWidget {
  const AppVideo({required this.controller, super.key});

  final AppVideoController controller;

  @override
  State<AppVideo> createState() => _AppVideoState();
}

class _AppVideoState extends State<AppVideo> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant AppVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    if (!widget.controller.video.isInitialized) {
      widget.controller.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller.videoListenable,
      builder: (context, child) {
        final video = widget.controller.video;
        return AspectRatio(
          aspectRatio: video.isInitialized ? video.aspectRatio : 9 / 16,
          child: VideoPlayer(widget.controller._controller),
        );
      },
    );
  }
}

class AppVideoController {
  AppVideoController.withSource({
    required String source,
    required DataSourceType sourceType,
  }) : _create = (() => createController(source, sourceType));

  AppVideoController({required VideoPlayerController controller})
      : _create = (() =>
            createController(controller.dataSource, controller.dataSourceType));
  final VideoPlayerController Function() _create;

  ValueListenable<VideoPlayerValue> get videoListenable => _controller;
  VideoPlayerValue get video => videoListenable.value;
  bool get isInitialized => _isInitialized;

  double _volume = 1;
  double get volume => _volume;
  double _lastVolume = 1;

  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _isDisposed = false;

  VideoPlayerController? __controller;
  void _buildController() {
    if (__controller == null) {
      __controller = _create();
      if (_isInitialized) {
        _isInitialized = false;
        initialize();
      }
    }
  }

  VideoPlayerController get _controller {
    _buildController();
    return __controller!;
  }

  void _listener() {
    _isPlaying = video.isPlaying;
  }

  Future<void> initialize() async {
    _buildController();
    if (!_isInitialized) {
      _isInitialized = true;
      await _controller.initialize();
      _controller.addListener(_listener);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _controller.setVolume(_volume);
      if (_isPlaying) _controller.play();
    });
  }

  Future<void> play() async {
    await _controller.seekTo(Duration.zero);
    await _controller.play();
    _isPlaying = true;
  }

  Future<void> seek(Duration duration) async {
    await _controller.seekTo(duration);
  }

  Future<void> resume() async {
    if (_isPlaying) return;
    await _controller.play();
    _isPlaying = true;
  }

  Future<void> pause() async {
    if (!_isPlaying) return;
    await _controller.pause();
    _isPlaying = false;
  }

  Future<void> setVolume(double volume) async {
    _updateVolume(volume);
    await _controller.setVolume(volume);
  }

  Future<void> mute() async {
    await setVolume(0);
  }

  Future<void> unmute() async {
    await setVolume(_lastVolume);
  }

  void _updateVolume(double volume) {
    _lastVolume = _volume;
    _volume = volume;
  }

  void release() {
    __controller?.removeListener(_listener);
    __controller?.dispose();
    __controller = null;
  }

  void dispose() {
    _isDisposed = true;
    __controller?.removeListener(_listener);
    __controller?.dispose();
    __controller = null;
  }

  static VideoPlayerController createController(
    String source,
    DataSourceType sourceType,
  ) {
    return switch (sourceType) {
      DataSourceType.asset => VideoPlayerController.asset(source),
      DataSourceType.file => VideoPlayerController.file(File(source)),
      DataSourceType.network =>
        VideoPlayerController.networkUrl(Uri.parse(source)),
      DataSourceType.contentUri =>
        VideoPlayerController.contentUri(Uri.parse(source)),
    };
  }
}
