import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../component/overlay.dart';
import 'overlay.dart';

class CarrotRouter extends GoRouter {
  CarrotRouter({
    super.debugLogDiagnostics = false,
    super.initialLocation = "/",
    super.navigatorKey,
    super.observers,
    // super.redirect,
    // super.redirectLimit = 5,
    super.refreshListenable,
    super.restorationScopeId,
    super.routerNeglect = false,
    // required super.routes,
    super.errorBuilder,
    super.errorPageBuilder,
    required List<RouteBase> routes,
    GoRouterRedirect? redirect,
    int redirectLimit = 5,
  }) : super.routingConfig(
    routingConfig: _CarrotConstantRoutingConfig(
        RoutingConfig(
          routes: routes,
          redirect: redirect ?? _defaultRedirect,
          redirectLimit: redirectLimit,
        )
    )
  );

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

  static FutureOr<String?> _defaultRedirect(BuildContext context, GoRouterState state) => null;

  static Uri locationOf(BuildContext context) {
    return GoRouterState.of(context).uri;
  }

  static CarrotRouter of(BuildContext context) {
    return GoRouter.of(context) as CarrotRouter;
  }
}

class _CarrotConstantRoutingConfig extends ValueListenable<RoutingConfig> {
  @override
  final RoutingConfig value;

  const _CarrotConstantRoutingConfig(this.value);

  @override
  void addListener(VoidCallback listener) {
  }

  @override
  void removeListener(VoidCallback listener) {
  }
}
