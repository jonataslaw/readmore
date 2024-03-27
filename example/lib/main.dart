import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
      ),
      title: 'Read More Text',
      home: const DemoApp(),
    );
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final isCollapsed = ValueNotifier<bool>(false);

  // K: UID, V: Username
  final userMap = {
    123: 'Android',
    456: 'iOS',
  };

  var _trimMode = TrimMode.Line;
  int _trimLines = 3;
  int _trimLength = 240;

  void _incrementTrimLines() => setState(() => _trimLines++);

  void _decrementTrimLines() =>
      setState(() => _trimLines = _trimLines > 1 ? _trimLines - 1 : 1);

  void _incrementTrimLength() => setState(() => _trimLength++);

  void _decrementTrimLength() =>
      setState(() => _trimLength = _trimLength > 1 ? _trimLength - 1 : 1);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    super.dispose();

    isCollapsed.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read More Text'),
      ),
      body: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 14),
        child: DraggableDivider(
          child: SingleChildScrollView(
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Column _buildContent() {
    return Column(
      children: <Widget>[
        _buildSettings(),
        Padding(
          key: const Key('showMore'),
          padding: const EdgeInsets.all(16),
          child: ReadMoreText(
            'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
            trimMode: _trimMode,
            trimLines: _trimLines,
            trimLength: _trimLength,
            preDataText: 'AMANDA',
            preDataTextStyle: const TextStyle(fontWeight: FontWeight.w500),
            style: const TextStyle(color: Colors.black),
            colorClickableText: Colors.pink,
            trimCollapsedText: '...Show more',
            trimExpandedText: ' show less',
          ),
        ),
        const Divider(
          color: Color(0xFF167F67),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ReadMoreText(
            'Flutter(https://flutter.dev/) has its own UI components, along with an engine to render them on both the <@123> and <@456> platforms <@999> http://google.com #read_more. Most of those UI components, right out of the box, conform to the guidelines of #Material Design.',
            trimMode: _trimMode,
            trimLines: _trimLines,
            trimLength: _trimLength,
            style: const TextStyle(color: Colors.black),
            colorClickableText: Colors.pink,
            trimCollapsedText: '...Expand',
            trimExpandedText: ' Collapse ',
            annotations: [
              // URL
              Annotation(
                regExp: RegExp(
                  r'(?:(?:https?|ftp)://)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
                ),
                spanBuilder: ({
                  required String text,
                  TextStyle? textStyle,
                }) {
                  return TextSpan(
                    text: text,
                    style: (textStyle ?? const TextStyle()).copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.green,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showMessage(text),
                  );
                },
              ),
              // Mention
              Annotation(
                regExp: RegExp(r'<@(\d+)>'),
                spanBuilder: ({
                  required String text,
                  TextStyle? textStyle,
                }) {
                  final user = userMap[int.tryParse(
                    text.substring(2, text.length - 1),
                  )];

                  if (user == null) {
                    return TextSpan(
                      text: '@unknown user',
                      style: (textStyle ?? const TextStyle()).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _showMessage('User not found'),
                    );
                  }

                  return TextSpan(
                    text: '@$user',
                    style: (textStyle ?? const TextStyle()).copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.redAccent,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showMessage('@$user'),
                    children: [
                      if (user == 'iOS') const TextSpan(text: 'Extra'),
                    ],
                  );
                },
              ),
              // Hashtag
              Annotation(
                // Test: non capturing group should work also
                regExp: RegExp('#(?:[a-zA-Z0-9_]+)'),
                spanBuilder: ({
                  required String text,
                  TextStyle? textStyle,
                }) {
                  return TextSpan(
                    text: text,
                    style: (textStyle ?? const TextStyle()).copyWith(
                      color: Colors.blueAccent,
                      height: 1.5,
                      letterSpacing: 5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showMessage(text),
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(
          color: Color(0xFF167F67),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ReadMoreText(
            'The Flutter framework builds its layout via the composition of widgets, everything that you construct programmatically is a widget and these are compiled together to create the user interface. ',
            trimMode: _trimMode,
            trimLines: _trimLines,
            trimLength: _trimLength,
            isCollapsed: isCollapsed,
            style: const TextStyle(color: Colors.black),
            colorClickableText: Colors.pink,
            trimCollapsedText: '...Read more',
            trimExpandedText: ' Less',
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isCollapsed,
          builder: (context, value, child) {
            return Center(
              child: ElevatedButton(
                onPressed: () => isCollapsed.value = !isCollapsed.value,
                child: Text('is collapsed: $value'),
              ),
            );
          },
        ),
      ],
    );
  }

  Column _buildSettings() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Trim Mode'),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SegmentedButton<TrimMode>(
            segments: const [
              ButtonSegment<TrimMode>(
                value: TrimMode.Length,
                label: Text('Length'),
              ),
              ButtonSegment<TrimMode>(
                value: TrimMode.Line,
                label: Text('Line'),
              ),
            ],
            selected: <TrimMode>{_trimMode},
            onSelectionChanged: (Set<TrimMode> newSelection) {
              setState(() {
                _trimMode = newSelection.first;
              });
            },
          ),
        ),
        if (_trimMode == TrimMode.Length)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrementTrimLength,
              ),
              Text('$_trimLength'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _incrementTrimLength,
              ),
            ],
          ),
        if (_trimMode == TrimMode.Line)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrementTrimLines,
              ),
              Text('$_trimLines'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _incrementTrimLines,
              ),
            ],
          ),
      ],
    );
  }
}

class DraggableDivider extends StatefulWidget {
  const DraggableDivider({super.key, required this.child});

  final Widget child;

  @override
  State<DraggableDivider> createState() => _DraggableDividerState();
}

class _DraggableDividerState extends State<DraggableDivider> {
  final double dividerWidth = 10;
  late double _leftWidth;
  final double _minWidth = 20;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final screenWidth = MediaQuery.sizeOf(context).width;
    setState(() {
      _leftWidth = screenWidth - _minWidth - dividerWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _leftWidth,
          child: widget.child,
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              final newWidth = _leftWidth + details.delta.dx;
              final screenWidth = MediaQuery.of(context).size.width;

              if (newWidth >= _minWidth &&
                  (screenWidth - newWidth - dividerWidth) >= _minWidth) {
                _leftWidth = newWidth;
              }
            });
          },
          child: Container(
            color: Colors.grey,
            width: 10,
          ),
        ),
        const Expanded(
          child: Center(child: VerticalText('Drag Test')),
        ),
      ],
    );
  }
}

class VerticalText extends StatelessWidget {
  const VerticalText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: text
          .split('')
          .map(
            (letter) => Text(
              letter,
              textAlign: TextAlign.center,
            ),
          )
          .toList(),
    );
  }
}
