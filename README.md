# readmore

A Flutter plugin that allows for expanding and collapsing text with the added capability to style and interact with specific patterns in the text like hashtags, URLs, and mentions using the new `Annotation` feature.

![](read-more-text-view-flutter.gif)

## Usage:

Add the package to your pubspec.yaml:

```yaml
readmore: ^3.0.0
```

Then, import it in your Dart code:

```dart
import 'package:readmore/readmore.dart';
```

### Basic Example

```dart
ReadMoreText(
  'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
  trimMode: TrimMode.Line,
  trimLines: 2,
  colorClickableText: Colors.pink,
  trimCollapsedText: 'Show more',
  trimExpandedText: 'Show less',
  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
);
```

### Using Annotations

The `Annotation` feature enhances the interactivity and functionality of the text content. You can define custom styles and interactions for patterns like hashtags, URLs, and mentions.

```dart
ReadMoreText(
  'This is a sample text with a #hashtag, a mention <@123>, and a URL: https://example.com.',
  trimMode: TrimMode.Line,
  trimLines: 2,
  colorClickableText: Colors.pink,
  annotations: [
    Annotation(
      regExp: RegExp(r'#([a-zA-Z0-9_]+)'),
      spanBuilder: ({required String text, TextStyle? textStyle}) => TextSpan(
        text: text,
        style: textStyle?.copyWith(color: Colors.blue),
      ),
    ),
    Annotation(
      regExp: RegExp(r'<@(\d+)>'),
      spanBuilder: ({required String text, TextStyle? textStyle}) => TextSpan(
        text: 'User123',
        style: textStyle?.copyWith(color: Colors.green),
        recognizer: TapGestureRecognizer()..onTap = () {
          // Handle tap, e.g., navigate to a user profile
        },
      ),
    ),
    // Additional annotations for URLs...
  ],
  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
);
```
