import 'package:provider/provider.dart';

import 'reactive_model_provider.dart';

class CarrotReactiveModelProviders extends MultiProvider {
  CarrotReactiveModelProviders({
    super.key,
    super.builder,
    super.child,
    required List<CarrotReactiveModelProvider> providers,
  }) : super(
          providers: providers,
        );
}
