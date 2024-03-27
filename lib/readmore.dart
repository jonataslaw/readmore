import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum TrimMode { Length, Line }

/// Defines a customizable pattern within text, such as hashtags, URLs, or mentions.
///
/// Enables applying custom styles and interactions to matched patterns,
/// enhancing text interactivity. Utilize this class to highlight specific text
/// segments or to add clickable functionality, facilitating navigation or other actions.
@immutable
class Annotation {
  const Annotation({
    required this.regExp,
    required this.spanBuilder,
  });

  final RegExp regExp;
  final TextSpan Function({required String text, TextStyle? textStyle})
      spanBuilder;
}

class ReadMoreText extends StatefulWidget {
  const ReadMoreText(
    this.data, {
    super.key,
    this.isCollapsed,
    this.preDataText,
    this.postDataText,
    this.preDataTextStyle,
    this.postDataTextStyle,
    this.trimExpandedText = 'show less',
    this.trimCollapsedText = 'read more',
    this.colorClickableText,
    this.trimLength = 240,
    this.trimLines = 2,
    this.trimMode = TrimMode.Length,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.textScaler,
    this.semanticsLabel,
    this.moreStyle,
    this.lessStyle,
    this.delimiter = '$_kEllipsis ',
    this.delimiterStyle,
    this.annotations,
    this.isExpandable = true,
  });

  final ValueNotifier<bool>? isCollapsed;

  /// Used on TrimMode.Length
  final int trimLength;

  /// Used on TrimMode.Lines
  final int trimLines;

  /// Determines the type of trim. TrimMode.Length takes into account
  /// the number of letters, while TrimMode.Lines takes into account
  /// the number of lines
  final TrimMode trimMode;

  /// TextStyle for expanded text
  final TextStyle? moreStyle;

  /// TextStyle for compressed text
  final TextStyle? lessStyle;

  /// Textspan used before the data any heading or somthing
  final String? preDataText;

  /// Textspan used after the data end or before the more/less
  final String? postDataText;

  /// Textspan used before the data any heading or somthing
  final TextStyle? preDataTextStyle;

  /// Textspan used after the data end or before the more/less
  final TextStyle? postDataTextStyle;

  final List<Annotation>? annotations;

  /// Expand text on readMore press
  final bool isExpandable;

  final String delimiter;
  final String data;
  final String trimExpandedText;
  final String trimCollapsedText;
  final Color? colorClickableText;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final TextScaler? textScaler;
  final String? semanticsLabel;
  final TextStyle? delimiterStyle;

  @override
  ReadMoreTextState createState() => ReadMoreTextState();
}

const String _kEllipsis = '\u2026';

const String _kLineSeparator = '\u2028';

class ReadMoreTextState extends State<ReadMoreText> {
  static final _nonCapturingGroupPattern = RegExp(r'\((?!\?:)');

  final TapGestureRecognizer _recognizer = TapGestureRecognizer();

  ValueNotifier<bool>? _isCollapsed;
  ValueNotifier<bool> get _effectiveIsCollapsed =>
      widget.isCollapsed ?? (_isCollapsed ??= ValueNotifier(true));

  void _onTap() {
    if (widget.isExpandable) {
      _effectiveIsCollapsed.value = !_effectiveIsCollapsed.value;
    }
  }

  RegExp? _mergeRegexPatterns(List<Annotation>? annotations) {
    if (annotations == null || annotations.isEmpty) {
      return null;
    } else if (annotations.length == 1) {
      return annotations[0].regExp;
    }

    // replacing groups '(' => to non capturing groups '(?:'
    return RegExp(
      annotations
          .map(
            (a) =>
                '(${a.regExp.pattern.replaceAll(_nonCapturingGroupPattern, '(?:')})',
          )
          .join('|'),
    );
  }

  @override
  void initState() {
    super.initState();

    _recognizer.onTap = _onTap;
  }

  @override
  void didUpdateWidget(ReadMoreText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCollapsed == null && oldWidget.isCollapsed != null) {
      final oldValue = oldWidget.isCollapsed!.value;
      (_isCollapsed ??= ValueNotifier(oldValue)).value = oldValue;
    }
  }

  @override
  void dispose() {
    _recognizer.dispose();
    _isCollapsed?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _effectiveIsCollapsed,
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, bool isCollapsed, Widget? child) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (widget.style?.inherit ?? false) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    } else {
      effectiveTextStyle = const TextStyle();
    }

    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final textScaler = widget.textScaler ?? MediaQuery.textScalerOf(context);
    final overflow = defaultTextStyle.overflow;
    final locale = widget.locale ?? Localizations.maybeLocaleOf(context);

    final colorClickableText =
        widget.colorClickableText ?? Theme.of(context).colorScheme.secondary;
    final defaultLessStyle = widget.lessStyle ??
        effectiveTextStyle.copyWith(color: colorClickableText);
    final defaultMoreStyle = widget.moreStyle ??
        effectiveTextStyle.copyWith(color: colorClickableText);
    final defaultDelimiterStyle = widget.delimiterStyle ?? effectiveTextStyle;

    final link = TextSpan(
      text: isCollapsed ? widget.trimCollapsedText : widget.trimExpandedText,
      style: isCollapsed ? defaultMoreStyle : defaultLessStyle,
      recognizer: _recognizer,
    );

    final delimiter = TextSpan(
      text: isCollapsed
          ? widget.trimCollapsedText.isNotEmpty
              ? widget.delimiter
              : ''
          : '',
      style: defaultDelimiterStyle,
      recognizer: _recognizer,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final maxWidth = constraints.maxWidth;

        TextSpan? preTextSpan;
        TextSpan? postTextSpan;
        if (widget.preDataText != null) {
          preTextSpan = TextSpan(
            text: '${widget.preDataText!} ',
            style: widget.preDataTextStyle ?? effectiveTextStyle,
          );
        }
        if (widget.postDataText != null) {
          postTextSpan = TextSpan(
            text: ' ${widget.postDataText!}',
            style: widget.postDataTextStyle ?? effectiveTextStyle,
          );
        }

        final regExp = _mergeRegexPatterns(widget.annotations);

        final annotatedText = _buildAnnotatedTextSpan(
          data: widget.data,
          textStyle: effectiveTextStyle,
          regExp: regExp,
          annotations: widget.annotations,
        );

        // Create a TextSpan with data
        final text = TextSpan(
          children: [
            if (preTextSpan != null) preTextSpan,
            annotatedText,
            if (postTextSpan != null) postTextSpan,
          ],
        );

        // Layout and measure link
        final textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaler: textScaler,
          maxLines: widget.trimLines,
          ellipsis: overflow == TextOverflow.ellipsis ? widget.delimiter : null,
          locale: locale,
        );
        textPainter.layout(maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // Layout and measure delimiter
        textPainter.text = delimiter;
        textPainter.layout(maxWidth: maxWidth);
        final delimiterSize = textPainter.size;

        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        // Get the endIndex of data
        var linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final readMoreSize = linkSize.width + delimiterSize.width;
          final pos = textPainter.getPositionForOffset(
            Offset(
              textDirection == TextDirection.rtl
                  ? readMoreSize
                  : textSize.width - readMoreSize,
              textSize.height,
            ),
          );
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          final pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }

        late final TextSpan textSpan;
        switch (widget.trimMode) {
          case TrimMode.Length:
            if (widget.trimLength < widget.data.length) {
              final effectiveAnnotatedText = isCollapsed
                  ? _trimTextSpan(
                      textSpan: annotatedText,
                      spanStartIndex: 0,
                      endIndex: widget.trimLength,
                    ).textSpan
                  : annotatedText;

              textSpan = TextSpan(
                style: effectiveTextStyle,
                children: <TextSpan>[effectiveAnnotatedText, delimiter, link],
              );
            } else {
              textSpan = annotatedText;
            }
            break;
          case TrimMode.Line:
            if (textPainter.didExceedMaxLines) {
              final effectiveAnnotatedText = isCollapsed
                  ? _trimTextSpan(
                      textSpan: annotatedText,
                      spanStartIndex: 0,
                      endIndex: endIndex,
                    ).textSpan
                  : annotatedText;

              textSpan = TextSpan(
                style: effectiveTextStyle,
                children: <TextSpan>[
                  effectiveAnnotatedText,
                  if (linkLongerThanLine) const TextSpan(text: _kLineSeparator),
                  delimiter,
                  link,
                ],
              );
            } else {
              textSpan = annotatedText;
            }
            break;
        }

        return Text.rich(
          TextSpan(
            children: [
              if (preTextSpan != null) preTextSpan,
              textSpan,
              if (postTextSpan != null) postTextSpan,
            ],
          ),
          textAlign: textAlign,
          textDirection: textDirection,
          softWrap: true,
          overflow: TextOverflow.clip,
          textScaler: textScaler,
        );
      },
    );
    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return result;
  }

  TextSpan _buildAnnotatedTextSpan({
    required String data,
    required TextStyle? textStyle,
    required RegExp? regExp,
    required List<Annotation>? annotations,
  }) {
    if (regExp == null || data.isEmpty) {
      return TextSpan(text: data, style: textStyle);
    }

    final contents = <TextSpan>[];

    data.splitMapJoin(
      regExp,
      onMatch: (Match regexMatch) {
        final matchedText = regexMatch.group(0)!;
        late final Annotation matchedAnnotation;

        if (annotations!.length == 1) {
          matchedAnnotation = annotations[0];
        } else {
          for (var i = 0; i < regexMatch.groupCount; i++) {
            if (matchedText == regexMatch.group(i + 1)) {
              matchedAnnotation = annotations[i];
              break;
            }
          }
        }

        final content = matchedAnnotation.spanBuilder(
          text: matchedText,
          textStyle: textStyle,
        );

        assert(_isTextSpan(content));
        contents.add(content);

        return '';
      },
      onNonMatch: (String unmatchedText) {
        contents.add(TextSpan(text: unmatchedText));
        return '';
      },
    );

    return TextSpan(style: textStyle, children: contents);
  }

  _TextSpanTrimResult _trimTextSpan({
    required TextSpan textSpan,
    required int spanStartIndex,
    required int endIndex,
  }) {
    var spanEndIndex = spanStartIndex;

    final text = textSpan.text;
    if (text != null) {
      final textLen = text.length;
      spanEndIndex += textLen;

      if (spanEndIndex >= endIndex) {
        final nextSpan = TextSpan(
          text: text.substring(0, endIndex - spanStartIndex),
          children: null, // remove potential children
          style: textSpan.style,
          recognizer: textSpan.recognizer,
          mouseCursor: textSpan.mouseCursor,
          onEnter: textSpan.onEnter,
          onExit: textSpan.onExit,
          semanticsLabel: textSpan.semanticsLabel,
          locale: textSpan.locale,
          spellOut: textSpan.spellOut,
        );

        return _TextSpanTrimResult(
          textSpan: nextSpan,
          spanEndIndex: spanEndIndex,
          didTrim: true,
        );
      }
    }

    var didTrim = false;
    final newChildren = <InlineSpan>[];

    final children = textSpan.children;
    if (children != null) {
      for (final child in children) {
        if (child is TextSpan) {
          final result = _trimTextSpan(
            textSpan: child,
            spanStartIndex: spanEndIndex,
            endIndex: endIndex,
          );

          spanEndIndex = result.spanEndIndex;
          newChildren.add(result.textSpan);

          if (result.didTrim) {
            didTrim = true;
            break;
          }
        } else {
          // WidgetSpan shouldn't occur
          newChildren.add(child);
        }
      }
    }

    final resultTextSpan = didTrim
        ? TextSpan(
            text: textSpan.text,
            children: newChildren, // update children
            style: textSpan.style,
            recognizer: textSpan.recognizer,
            mouseCursor: textSpan.mouseCursor,
            onEnter: textSpan.onEnter,
            onExit: textSpan.onExit,
            semanticsLabel: textSpan.semanticsLabel,
            locale: textSpan.locale,
            spellOut: textSpan.spellOut,
          )
        : textSpan;

    return _TextSpanTrimResult(
      textSpan: resultTextSpan,
      spanEndIndex: spanEndIndex,
      didTrim: didTrim,
    );
  }

  bool _isTextSpan(InlineSpan span) {
    if (span is! TextSpan) {
      return false;
    }

    final children = span.children;
    if (children == null || children.isEmpty) {
      return true;
    }

    return children.every(_isTextSpan);
  }
}

@immutable
class _TextSpanTrimResult {
  const _TextSpanTrimResult({
    required this.textSpan,
    required this.spanEndIndex,
    required this.didTrim,
  });

  final TextSpan textSpan;
  final int spanEndIndex;
  final bool didTrim;
}
