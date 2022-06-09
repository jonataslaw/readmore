# readmore

A Flutter plugin than allow expand and collapse text.

![](read-more-text-view-flutter.gif)

## usage:
add to your pubspec

```
readmore: ^2.1.0
```
and import:
```
import 'package:readmore/readmore.dart';
```

```dart
ReadMoreText(
  'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
  trimLines: 2,
  colorClickableText: Colors.pink,
  trimMode: TrimMode.Line,
  trimCollapsedText: 'Show more',
  trimExpandedText: 'Show less',
  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
);
```


