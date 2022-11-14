import 'package:flutter/widgets.dart';

mixin CarrotDelegatedTransitionsRoute<T> on ModalRoute<T> {
  List<CarrotDelegatedTransitionsRoute<dynamic>>? _nextRoutes;

  Widget buildSecondaryTransitionForPreviousRoute(
    BuildContext context,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      child;

  bool canDriveSecondaryTransitionForPreviousRoute(Route<dynamic> previousRoute) => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (_nextRoutes != null && _nextRoutes!.isNotEmpty) {
      var proxyChild = child;

      for (final nextRoute in _nextRoutes!) {
        final secondaryAnimation = ProxyAnimation(nextRoute.animation!);
        proxyChild = nextRoute.buildSecondaryTransitionForPreviousRoute(
          context,
          secondaryAnimation,
          child,
        );
      }

      final proxySecondaryAnimation = ProxyAnimation(kAlwaysDismissedAnimation);

      return super.buildTransitions(
        context,
        animation,
        proxySecondaryAnimation,
        proxyChild,
      );
    }

    return super.buildTransitions(
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }

  @override
  void didChangeNext(Route<dynamic>? nextRoute) {
    if (nextRoute is CarrotDelegatedTransitionsRoute && nextRoute.canDriveSecondaryTransitionForPreviousRoute(this)) {
      _nextRoutes ??= [];
      _nextRoutes!.add(nextRoute);

      nextRoute.completed.then((_) => _nextRoutes!.remove(nextRoute));
    }

    super.didChangeNext(nextRoute);
  }

  @override
  void didReplace(Route<dynamic>? oldRoute) {
    if (oldRoute is CarrotDelegatedTransitionsRoute && oldRoute._nextRoutes != null) {
      _nextRoutes = List.from(oldRoute._nextRoutes!);
    }

    super.didReplace(oldRoute);
  }
}
