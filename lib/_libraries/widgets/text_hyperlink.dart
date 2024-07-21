import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum HyperlinkTextType { text, hyperlink }

class TextHyperlink extends StatefulWidget {
  const TextHyperlink({
    required this.text,
    this.textStyle,
    this.hyperlinkStyle,
    this.maxLines,
    this.softWrap,
    this.textAlign,
    this.overflow,
    super.key,
  });

  final List<TextHyperlinkSpan> text;
  final TextStyle? textStyle;
  final TextStyle? hyperlinkStyle;

  final int? maxLines;
  final bool? softWrap;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  State<TextHyperlink> createState() => _TextHyperlinkState();
}

class _TextHyperlinkState extends State<TextHyperlink> {
  @override
  void didUpdateWidget(covariant TextHyperlink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _disposeRecognizers(widget.text);
    }
  }

  @override
  void dispose() {
    _disposeRecognizers(widget.text);
    super.dispose();
  }

  void _disposeRecognizers(List<TextHyperlinkSpan> text) {
    for (var span in text) {
      span.recognizer?.dispose();
    }
  }

  List<TextHyperlinkSpan> _buildSpans(List<TextHyperlinkSpan> text) {
    List<TextHyperlinkSpan> spans = [];

    for (var span in text) {
      if (span.style == null) {
        span = span.copyWith(
          style: switch (span.type) {
            HyperlinkTextType.text => widget.textStyle,
            HyperlinkTextType.hyperlink => widget.hyperlinkStyle,
          },
        );
      }
      spans.add(span);
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: widget.maxLines,
      softWrap: widget.softWrap ?? true,
      textAlign: widget.textAlign ?? TextAlign.start,
      overflow: widget.overflow ?? TextOverflow.clip,
      text: TextSpan(children: _buildSpans(widget.text)),
    );
  }
}

class TextHyperlinkSpan extends TextSpan {
  const TextHyperlinkSpan(
    String text, {
    required this.type,
    super.style,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
  }) : super(text: text);

  const TextHyperlinkSpan.text(
    String text, {
    super.style,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
  })  : type = HyperlinkTextType.text,
        super(text: text);

  const TextHyperlinkSpan.hyperlink(
    String text, {
    super.children,
    super.style,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
  })  : type = HyperlinkTextType.hyperlink,
        super(text: text);

  final HyperlinkTextType type;

  @override
  String get text => super.text!;

  TextHyperlinkSpan copyWith({
    HyperlinkTextType? type,
    TextStyle? style,
    GestureRecognizer? recognizer,
    MouseCursor? mouseCursor,
    void Function(PointerEnterEvent)? onEnter,
    void Function(PointerExitEvent)? onExit,
    String? semanticsLabel,
    Locale? locale,
    bool? spellOut,
  }) {
    return TextHyperlinkSpan(
      text,
      type: type ?? this.type,
      style: style ?? this.style,
      recognizer: recognizer ?? this.recognizer,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      onEnter: onEnter ?? this.onEnter,
      onExit: onExit ?? this.onExit,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      locale: locale ?? this.locale,
      spellOut: spellOut ?? this.spellOut,
    );
  }
}
