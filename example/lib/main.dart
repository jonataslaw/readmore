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

  @override
  void dispose() {
    super.dispose();

    isCollapsed.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Read More Text',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DefaultTextStyle.merge(
        style: const TextStyle(
          fontSize: 16,
          //fontFamily: 'monospace',
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                key: Key('showMore'),
                padding: EdgeInsets.all(16),
                child: ReadMoreText(
                  'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                  preDataText: 'AMANDA',
                  preDataTextStyle: TextStyle(fontWeight: FontWeight.w500),
                  style: TextStyle(color: Colors.black),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
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
                  trimLines: 3,
                  style: const TextStyle(color: Colors.black),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
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
                            ..onTap = () => print(text),
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
                              ..onTap = () => print('User not found'),
                          );
                        }

                        return TextSpan(
                          text: '@$user',
                          style: (textStyle ?? const TextStyle()).copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.redAccent,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => print('@$user'),
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
                            ..onTap = () => print(text),
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
                  isCollapsed: isCollapsed,
                  style: const TextStyle(color: Colors.black),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
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
          ),
        ),
      ),
    );
  }
}
