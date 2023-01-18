import 'package:flutter/widgets.dart';

import '../../l10n/l10n.dart';
import '../component/component.dart';
import '../routing/routing.dart';
import '../theme/theme.dart';

extension CarrotExtension on BuildContext {
  /// Returns the containing [CarrotApp].
  CarrotApp get carrot => CarrotApp.of(this);

  /// Returns the nearest [CarrotDrawerController].
  CarrotDrawerController get carrotDrawer => CarrotDrawerGestureDetector.of(this);

  /// Returns the nearest [CarrotRouter].
  CarrotRouter get carrotRouter => CarrotRouter.of(this);

  /// Returns the nearest [CarrotScaffoldController].
  CarrotScaffoldController get carrotScaffold => CarrotScaffold.of(this);

  /// Returns the [CarrotAppSettings].
  CarrotAppSettings get carrotSettings => CarrotApp.of(this).settings;

  /// Returns the [CarrotLocalizations] for the active locale.
  CarrotLocalizations get carrotStrings => CarrotLocalizations.of(this)!;

  /// Returns the nearest [CarrotTheme].
  CarrotThemeData get carrotTheme => CarrotTheme.of(this);

  /// Returns the [CarrotTypography] of the nearest [CarrotTheme].
  CarrotTypography get carrotTypography => CarrotTheme.of(this).typography;

  /// Returns the [MediaQueryData] of the view.
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
