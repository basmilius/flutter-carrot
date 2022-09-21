import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'page.dart';

typedef CarrotRouteNameGenerator = String? Function(BuildContext);
typedef CarrotRouteRedirect = String? Function(BuildContext, GoRouterState);
typedef CarrotRoutePageBuilder = Page<dynamic> Function(BuildContext, GoRouterState);
typedef CarrotRouteWidgetBuilder = Widget Function(BuildContext, GoRouterState);
typedef CarrotShellRoutePageBuilder = Page<dynamic> Function(BuildContext, GoRouterState, Widget);
typedef CarrotShellRouteWidgetBuilder = Widget Function(BuildContext, GoRouterState, Widget);

class CarrotRoute extends GoRoute {
  CarrotRoute({
    required CarrotRouteWidgetBuilder builder,
    required super.path,
    CarrotRoutePageBuilder? pageBuilder,
    CarrotRouteRedirect redirect = _noRedirect,
    List<CarrotRoute> routes = const [],
  }) : super(
          builder: builder,
          pageBuilder: pageBuilder,
          redirect: redirect,
          routes: routes,
        );

  CarrotRoute.defaultTransition({
    required CarrotRouteWidgetBuilder builder,
    required super.path,
    CarrotRouteNameGenerator? nameGenerator,
    CarrotRouteRedirect redirect = _noRedirect,
    List<CarrotRoute> routes = const [],
  }) : super(
          pageBuilder: (context, state) => CarrotRoutingPage<void>(
            key: state.pageKey,
            name: nameGenerator?.call(context),
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
    CarrotShellRouteWidgetBuilder? builder,
    CarrotShellRoutePageBuilder? pageBuilder,
  }) : super(
          builder: builder,
          pageBuilder: pageBuilder,
        );
}

String? _noRedirect(BuildContext _, GoRouterState __) => null;
