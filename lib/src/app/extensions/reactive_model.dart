import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../data/data.dart';

extension CarrotReactiveModelExtension on BuildContext {
  T reactiveModel<T extends CarrotReactiveModel>() => watch<T>();
  T immutableModel<T extends CarrotReactiveModel>() => read<T>();
}
