import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
      ),
      title: 'Read More Text',
      home: DemoApp(),
    );
  }
}

class DemoApp extends StatelessWidget {
  final collapsedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Read More Text',
        style: TextStyle(color: Colors.white),
      )),
      body: DefaultTextStyle.merge(
        style: const TextStyle(
          fontSize: 16.0,
          //fontFamily: 'monospace',
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                key: const Key('showMore'),
                padding: const EdgeInsets.all(16.0),
                child: ReadMoreText(
                  'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                  collapsed: true,
                  trimLines: 2,
                  preDataText: "AMANDA",
                  preDataTextStyle: TextStyle(fontWeight: FontWeight.w500),
                  style: TextStyle(color: Colors.black),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: ' show less',
                  withDelimiter: true,
                ),
              ),
              Divider(
                color: const Color(0xFF167F67),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReadMoreText(
                  'Flutter(https://flutter.dev/) has its own UI components, along with an engine to render them on both the Android and iOS platforms. Most of those UI components, right out of the box, conform to the guidelines of Material Design.',
                  collapsed: true,
                  trimLines: 3,
                  style: TextStyle(color: Colors.black),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Expand',
                  trimExpandedText: ' Collapse ',
                  onLinkPressed: (url) {
                    print(url);
                  },
                  withDelimiter: true,
                ),
              ),
              Divider(
                color: const Color(0xFF167F67),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReadMoreText(
                  'The Flutter framework builds its layout via the composition of widgets, everything that you construct programmatically is a widget and these are compiled together to create the user interface. ',
                  collapsed: true,
                  trimLines: 2,
                  style: TextStyle(color: Colors.black),
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Read more',
                  trimExpandedText: ' Less',
                  withDelimiter: false,
                ),
              ),
              Divider(
                color: const Color(0xFF167F67),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        collapsedNotifier.value = !collapsedNotifier.value;
                      },
                      child: Text('Click me to toggle expand or collapse'),
                    ),
                    const SizedBox(height: 15),
                    ValueListenableBuilder(
                      valueListenable: collapsedNotifier,
                      builder: (context, bool value, _) {
                        return ReadMoreText(
                          'This text will collapse or expand if you tap or click the button above Laboris cillum id aliqua ullamco fugiat nulla consequat. Occaecat eu excepteur amet id aliqua ea esse excepteur. Eiusmod aliqua anim amet nisi nulla ipsum ut ullamco velit nisi sunt. Laborum eu in excepteur elit excepteur eu fugiat reprehenderit deserunt enim duis anim veniam. Reprehenderit deserunt laborum veniam eu amet minim esse dolore aliquip enim commodo. Non enim qui consequat sint dolor do exercitation consequat est. Deserunt cillum magna mollit veniam mollit id nulla culpa quis nisi cillum mollit sint dolore. Id fugiat adipisicing ullamco consequat elit reprehenderit dolore.',
                          collapsed: value,
                          trimLines: 2,
                          style: TextStyle(color: Colors.black),
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...Read more',
                          trimExpandedText: ' Less',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
