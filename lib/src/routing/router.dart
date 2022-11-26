import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../components/overlay.dart';
import '../components/scaffold.dart';
import 'overlay.dart';

class CarrotRouter extends GoRouter {
  CarrotRouter({
    super.debugLogDiagnostics = false,
    super.initialLocation = "/",
    super.navigatorKey,
    super.observers,
    super.redirect,
    super.redirectLimit = 5,
    super.refreshListenable,
    super.restorationScopeId,
    super.routerNeglect = false,
    required super.routes,
    super.errorBuilder,
    super.errorPageBuilder,
  });

  NavigatorState? get navigator => routerDelegate.navigatorKey.currentState;

  Future<T?> overlay<T>({
    required CarrotOverlayBaseBuilder<T> builder,
    T? defaultValue,
    bool dismissible = false,
  }) async {
    assert(navigator != null);

    return await navigator!.push<T?>(CarrotOverlayRoute<T?>(
      builder: builder,
      defaultValue: defaultValue,
      dismissible: dismissible,
    ));
  }

  Future<T?> overlayEntry<T>({
    required CarrotOverlayBuilder<T> builder,
    T? defaultValue,
    bool dismissible = false,
  }) async {
    assert(navigator != null);
    assert(navigator!.overlay != null);

    final completer = Completer<T?>();

    navigator!.overlay!.insert(CarrotOverlay.entry(
      builder: builder,
      completer: completer,
      defaultValue: defaultValue,
      dismissible: dismissible,
    ));

    return completer.future;
  }

  @override
  void go(String location, {Object? extra}) {
    if (super.location == location) {
      return;
    }

    super.go(location, extra: extra);
  }

  @override
  void push(String location, {Object? extra}) {
    if (super.location == location) {
      return;
    }

    super.push(location, extra: extra);
  }

  static CarrotRouter of(BuildContext context) {
    final scaffold = context.findAncestorWidgetOfExactType<CarrotScaffold>();

    if (scaffold != null && scaffold.router != null) {
      return scaffold.router!;
    }

    return GoRouter.of(context) as CarrotRouter;
  }
}
