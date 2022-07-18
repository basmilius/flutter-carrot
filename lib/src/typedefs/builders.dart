import 'package:flutter/widgets.dart';

typedef CarrotInstanceBuilder<T> = T Function();

typedef CarrotLayoutBuilder = Widget Function(BuildContext, BoxConstraints);

typedef CarrotWidgetBuilder = Widget Function(BuildContext);
