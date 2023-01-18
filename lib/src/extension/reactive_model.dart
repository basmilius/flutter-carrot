import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../data/data.dart';

extension CarrotReactiveModelExtension on BuildContext {
  /// Subscribes to the reactive model of type [T].
  T reactiveModel<T extends CarrotReactiveModel>() => watch<T>();

  /// Reads the reactive model of type [T].
  T immutableModel<T extends CarrotReactiveModel>() => read<T>();
}
