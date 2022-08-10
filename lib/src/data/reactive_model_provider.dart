import 'package:provider/provider.dart';

import '../typedefs/typedefs.dart';

import 'reactive_model.dart';

class CarrotReactiveModelProvider<T extends CarrotReactiveModel> extends ChangeNotifierProvider<T> {
  CarrotReactiveModelProvider({
    super.key,
    super.child,
    required CarrotInstanceBuilder<T> create,
  }) : super(
          create: (_) => create(),
        );

  CarrotReactiveModelProvider.fromModel({
    super.key,
    super.child,
    required T model,
  }) : super(
          create: (_) => model,
        );
}
