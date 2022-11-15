import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'page.dart';

typedef CarrotRouteNameGenerator = String? Function(BuildContext, GoRouterState);
typedef CarrotRouteRedirect = String? Function(BuildContext, GoRouterState);
typedef CarrotRoutePageBuilder = Page<dynamic> Function(BuildContext, GoRouterState);
typedef CarrotRouteWidgetBuilder = Widget Function(BuildContext, GoRouterState);
typedef CarrotShellRoutePageBuilder = Page<dynamic> Function(BuildContext, GoRouterState, Widget);
typedef CarrotShellRouteWidgetBuilder = Widget Function(BuildContext, GoRouterState, Widget);

class CarrotRoute extends GoRoute {
  CarrotRoute({
    required CarrotRouteWidgetBuilder super.builder,
    required super.path,
    super.pageBuilder,
    CarrotRouteRedirect super.redirect = _noRedirect,
    List<CarrotRoute> super.routes = const [],
    super.name,
    super.parentNavigatorKey,
  });

  CarrotRoute.defaultTransition({
    required CarrotRouteWidgetBuilder builder,
    required super.path,
    CarrotRouteNameGenerator? nameGenerator,
    CarrotRouteRedirect redirect = _noRedirect,
    List<CarrotRoute> routes = const [],
    super.name,
    super.parentNavigatorKey,
  }) : super(
          pageBuilder: (context, state) => CarrotRoutingPage<void>(
            key: state.pageKey,
            name: nameGenerator?.call(context, state),
            child: builder(context, state),
          ),
          redirect: redirect,
          routes: routes,
        );
}

class CarrotShellRoute extends ShellRoute {
  CarrotShellRoute({
    super.navigatorKey,
    super.routes,
    super.builder,
    super.pageBuilder,
  });

  CarrotShellRoute.defaultTransition({
    super.navigatorKey,
    super.routes,
    CarrotShellRouteWidgetBuilder? builder,
  }) : super(
          pageBuilder: (context, state, child) => CarrotRoutingPage<void>(
            key: state.pageKey,
            child: builder?.call(context, state, child) ?? child,
          ),
        );
}

String? _noRedirect(BuildContext _, GoRouterState __) => null;
