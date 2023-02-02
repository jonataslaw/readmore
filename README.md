# enhanced_read_more

A Flutter plugin than allow expand and collapse text.

This is a fork of https://github.com/jonataslaw/readmore that allows you to control the expanded and collapsed state

![](read-more-text-view-flutter.gif)

## usage:
add to your pubspec

```
enhanced_read_more: ^0.0.1
```
and import:
```
import 'package:readmore/readmore.dart';
```

```dart
ReadMoreText(
  'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
  trimLines: 2,
  collapsed: true,
  colorClickableText: Colors.pink,
  trimMode: TrimMode.Line,
  trimCollapsedText: 'Show more',
  trimExpandedText: 'Show less',
  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
);
```


