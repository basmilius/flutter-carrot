import 'package:flutter/widgets.dart';

enum CarrotAppViewState {
  phone,
  tablet,
  tabletLarge,
}

extension CarrotMediaQueryExtension on MediaQueryData {
  bool get isPhone => appViewState == CarrotAppViewState.phone;

  bool get isTablet => appViewState == CarrotAppViewState.tablet;

  bool get isTabletLarge => appViewState == CarrotAppViewState.tabletLarge;

  CarrotAppViewState get appViewState {
    if (size.width >= 1200) {
      return CarrotAppViewState.tabletLarge;
    }

    if (size.width >= 900) {
      return CarrotAppViewState.tablet;
    }

    return CarrotAppViewState.phone;
  }

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
