import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'page.dart';

typedef CarrotRouteNameGenerator = String? Function(BuildContext context);
typedef CarrotRouteRedirect = String? Function(GoRouterState state);
typedef CarrotRoutePageBuilder = Page<void> Function(BuildContext context, GoRouterState state);
typedef CarrotRouteWidgetBuilder = Widget Function(BuildContext context, GoRouterState state);

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

  static String? _noRedirect(GoRouterState state) => null;
}
