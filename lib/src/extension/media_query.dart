import 'package:flutter/widgets.dart';

enum CarrotAppViewState {
  phone,
  tablet,
  tabletLarge,
}

extension CarrotMediaQueryExtension on MediaQueryData {
  /// Returns `true` if the view size is considered phone size.
  bool get isPhone => appViewState == CarrotAppViewState.phone;

  /// Returns `true` if the view size is considered a tablet.
  bool get isTablet => appViewState == CarrotAppViewState.tablet;

  /// Returns `true` if the view size is considered a large tablet.
  bool get isTabletLarge => appViewState == CarrotAppViewState.tabletLarge;

  /// Gets the current app view state.
  CarrotAppViewState get appViewState {
    if (size.width >= 1200) {
      return CarrotAppViewState.tabletLarge;
    }

    if (size.width >= 900) {
      return CarrotAppViewState.tablet;
    }

    return CarrotAppViewState.phone;
  }

  /// Returns the correct builder for the current app view.
  Widget builderForAppView(
    BuildContext context, {
    required WidgetBuilder phoneBuilder,
    required WidgetBuilder tabletBuilder,
    required WidgetBuilder tabletLargeBuilder,
  }) {
    switch (appViewState) {
      case CarrotAppViewState.phone:
        return phoneBuilder(context);

      case CarrotAppViewState.tablet:
        return tabletBuilder(context);

      case CarrotAppViewState.tabletLarge:
        return tabletLargeBuilder(context);
    }
  }
}
