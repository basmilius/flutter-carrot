import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class CarrotReactiveModel with ChangeNotifier, DiagnosticableTreeMixin {
  bool _inTransaction = false;

  @override
  void notifyListeners() {
    if (_inTransaction) {
      return;
    }

    super.notifyListeners();
  }

  void transaction(Function fn) {
    Future.microtask(() {
      _inTransaction = true;
      fn();
      _inTransaction = false;
      notifyListeners();
    });
  }

  static T read<T extends CarrotReactiveModel>(BuildContext context) {
    return context.read<T>();
  }

  static T reactive<T extends CarrotReactiveModel>(BuildContext context) {
    return context.watch<T>();
  }
}
