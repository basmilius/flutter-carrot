import 'package:flutter/widgets.dart';

import '../typedefs/typedefs.dart';

class CarrotAppView {
  final MediaQueryData _mediaQueryData;

  const CarrotAppView(this._mediaQueryData);

  bool get isPhone => state == CarrotAppViewState.phone;

  bool get isTablet => state == CarrotAppViewState.tablet;

  bool get isTabletLarge => state == CarrotAppViewState.tabletLarge;

  CarrotAppViewState get state {
    if (_mediaQueryData.size.width >= 1200) {
      return CarrotAppViewState.tabletLarge;
    }

    if (_mediaQueryData.size.width >= 900) {
      return CarrotAppViewState.tablet;
    }

    return CarrotAppViewState.phone;
  }

  Widget builderForView(
    BuildContext context, {
    required CarrotWidgetBuilder phoneBuilder,
    required CarrotWidgetBuilder tabletBuilder,
    required CarrotWidgetBuilder tabletLargeBuilder,
  }) {
    switch (state) {
      case CarrotAppViewState.phone:
        return phoneBuilder(context);

      case CarrotAppViewState.tablet:
        return tabletBuilder(context);

      case CarrotAppViewState.tabletLarge:
        return tabletLargeBuilder(context);
    }
  }

  static CarrotAppView of(BuildContext context) {
    return CarrotAppView(MediaQuery.of(context));
  }
}

enum CarrotAppViewState { phone, tablet, tabletLarge }
