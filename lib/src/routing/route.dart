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
    super.redirect,
    super.routes = const [],
    super.name,
    super.parentNavigatorKey,
  });

  CarrotRoute.customPage({
    required super.pageBuilder,
    required super.path,
    super.redirect,
    super.routes = const [],
    super.name,
    super.parentNavigatorKey,
  }) : super();

  CarrotRoute.defaultTransition({
    required CarrotRouteWidgetBuilder builder,
    required super.path,
    CarrotRouteNameGenerator? nameGenerator,
    super.redirect,
    super.routes = const [],
    super.parentNavigatorKey,
    Object? arguments,
  }) : super(
          pageBuilder: (context, state) => CarrotPage<void>(
            key: state.pageKey,
            arguments: arguments,
            name: nameGenerator?.call(context, state),
            child: builder(context, state),
          ),
        );
}

class CarrotShellRoute extends ShellRoute {
  CarrotShellRoute({
    required super.routes,
    super.navigatorKey,
    super.builder,
    super.pageBuilder,
  });

  CarrotShellRoute.defaultTransition({
    required super.routes,
    super.navigatorKey,
    CarrotShellRouteWidgetBuilder? builder,
  }) : super(
          pageBuilder: (context, state, child) => CarrotPage<void>(
            key: state.pageKey,
            child: builder?.call(context, state, child) ?? child,
          ),
        );
}
