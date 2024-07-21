import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '/user_interface/components/generic_components/animatables/animation_transformers.dart';
import '/user_interface/components/generic_components/animatables/transform_curve.dart';
import '/user_interface/components/generic_components/animated_double.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo({
    required this.onRestart,
    required this.onResume,
    required this.onPause,
    required this.playing,
    required this.video,
    this.loader =
        const CircularProgressIndicator.adaptive(backgroundColor: Colors.white),
    this.onSeek,
    super.key,
  });

  final void Function() onRestart;
  final void Function() onResume;
  final void Function() onPause;
  final void Function(Duration duration)? onSeek;
  final ValueListenable<VideoPlayerValue> playing;
  final Widget loader;
  final Widget video;

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  // final TimedTaskHandler _seekDebouncer = TimedTaskHandler(300);
  late final ValueNotifier<Duration> _position =
      ValueNotifier(widget.playing.value.position);
  ValueNotifier<bool>? _overlayStatus = ValueNotifier(false);
  Timer? _overlayTimer;

  @override
  void initState() {
    super.initState();
    widget.playing.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant PlayVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playing != oldWidget.playing) {
      oldWidget.playing.removeListener(_listener);
      widget.playing.addListener(_listener);
    }
  }

  @override
  void dispose() {
    _position.dispose();
    _overlayStatus?.dispose();
    _overlayStatus = null;
    super.dispose();
  }

  void _listener() {
    final playing = widget.playing.value;
    _position.value = playing.position;
  }

  void _startTimer(Duration duration) {
    _overlayTimer?.cancel();
    _overlayTimer = Timer(duration, () {
      _overlayStatus?.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_overlayStatus, widget.playing]),
      builder: (context, child) {
        final playing = widget.playing.value;
        final isShowing = _overlayStatus?.value ?? false;
        final isPlaying = playing.isPlaying;
        final isCompleted = playing.isCompleted;
        final showPlayPause = isShowing && !isCompleted;
        return GestureDetector(
          onTap: () {
            _overlayStatus?.value = !isShowing;
            _startTimer(const Duration(seconds: 2));
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              child!,
              if (!playing.isInitialized || playing.isBuffering) widget.loader,
              if (widget.onSeek != null) Positioned.fill(child: _seekbar()),
              if (isCompleted) Positioned.fill(child: _restartButton()),
              if (showPlayPause)
                Positioned.fill(child: _playPauseButton(isPlaying)),
            ],
          ),
        );
      },
      child: widget.video,
    );
  }

  Widget _restartButton() {
    return _videoOverlay(
      onTap: widget.onRestart,
      builder: _videoIcon(Icons.replay),
    );
  }

  Widget _playPauseButton(bool isPlaying) {
    return _videoOverlay(
      onTap: () {
        if (isPlaying) {
          widget.onPause();
        } else {
          widget.onResume();
        }
        _startTimer(Durations.short3);
      },
      builder: (size) {
        return AnimatedDouble(
          value: isPlaying ? 1 : 0,
          duration: Durations.medium2,
          builder: (context, _, animation, rawAnimation, ___) {
            final icon = animation.value.round() == 0
                ? Icons.play_arrow_rounded
                : Icons.pause;
            final child = _videoIcon(icon)(size);

            return _shrinkAnimation(
              context,
              animation,
              rawAnimation,
              child,
            );
          },
        );
      },
    );
  }

  Widget _seekbar() {
    final playing = widget.playing.value;

    return ValueListenableBuilder(
      valueListenable: _position,
      builder: (context, position, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                    child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 5,
                    trackShape: const RoundedRectSliderTrackShape(),
                  ),
                  child: IntrinsicHeight(
                    child: Slider(
                      value: !playing.isInitialized ||
                              position.inMilliseconds >
                                  playing.duration.inMilliseconds
                          ? 0
                          : position.inMilliseconds /
                              playing.duration.inMilliseconds,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        final ms = playing.duration.inMilliseconds * value;
                        final update = Duration(milliseconds: ms.toInt());
                        _position.value = update;
                        // _seekDebouncer.handle(() => widget.onSeek!(update));
                        widget.onSeek!(update);
                      },
                    ),
                  ),
                )),
                const SizedBox(width: 10),
                _seekbarTime(position, playing.duration),
                const SizedBox(width: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _seekbarTime(Duration position, Duration duration) {
    var showHour = duration.inHours > 0;
    String time(Duration moment) {
      String timeElement(int time) => time.toString().padLeft(2, '0');

      final hours = moment.inHours;
      final minutes = moment.inMinutes % 60;
      final seconds = moment.inSeconds % 60;

      return showHour
          ? '${timeElement(hours)}'
              ':${timeElement(minutes)}'
          : '${timeElement(minutes)}'
              ':${timeElement(seconds)}';
    }

    return Text(
      '${time(position)} / ${time(duration)}',
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _videoOverlay({
    required VoidCallback onTap,
    required Widget Function(double size) builder,
  }) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.3),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: onTap,
          child: builder(/*constraints.maxWidth / 4*/ 64),
        ),
      ),
    );
  }

  Widget Function(double size) _videoIcon(IconData icon) {
    return (size) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(.5),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size / 2,
        ),
      );
    };
  }

  Widget _shrinkAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> rawAnimation,
    Widget child,
  ) {
    final transformation = TransformedAnimation(
      parent: animation,
      transformer: AnimationTransformers.rebound(.5),
    );

    return FadeTransition(
      opacity: transformation,
      child: ScaleTransition(
        scale: transformation,
        child: child,
      ),
    );
  }
}
