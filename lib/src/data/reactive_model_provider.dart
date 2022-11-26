import 'package:provider/provider.dart';

import 'reactive_model.dart';

typedef CarrotReactiveModelCreator<T> = T Function();

class CarrotReactiveModelProvider<T extends CarrotReactiveModel> extends ChangeNotifierProvider<T> {
  CarrotReactiveModelProvider({
    super.key,
    super.child,
    required CarrotReactiveModelCreator<T> create,
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
