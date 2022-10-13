import 'package:flutter/widgets.dart';

import '../../components/app.dart';
import '../../components/drawer_gesture_detector.dart';
import '../../components/scaffold.dart';
import '../../routing/routing.dart';
import '../../theme/theme.dart';
import '../app_view.dart';
import '../settings.dart';

extension CarrotAppExtension on BuildContext {
  CarrotApp get carrot => CarrotApp.of(this);
  CarrotAppView get carrotAppView => CarrotAppView.of(this);
  CarrotDrawerController get carrotDrawer => CarrotDrawerGestureDetector.of(this);
  CarrotRouter get carrotRouter => CarrotRouter.of(this);
  CarrotScaffoldController get carrotScaffold => CarrotScaffold.of(this);
  CarrotAppSettings get carrotSettings => CarrotApp.of(this).settings;
  CarrotThemeData get carrotTheme => CarrotTheme.of(this);
  CarrotTypography get carrotTypography => CarrotTheme.of(this).typography;
}
