import 'package:flutter/widgets.dart';

import '../app/settings.dart';
import '../ui/theme.dart';

class CarrotApp extends StatelessWidget {
  final Widget child;
  final Locale? locale;
  final CarrotAppSettings settings;
  final bool showDebugBanner;
  final bool showPerformanceOverlay;
  final CarrotTheme theme;

  const CarrotApp({
    super.key,
    required this.child,
    required this.settings,
    required this.theme,
    this.locale,
    this.showDebugBanner = false,
    this.showPerformanceOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollNotificationObserver(
      child: CarrotThemeProvider(
        theme: theme,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: WidgetsApp(
            color: theme.primary,
            debugShowCheckedModeBanner: showDebugBanner,
            showPerformanceOverlay: showPerformanceOverlay,
            locale: locale,
            title: settings.title,
            builder: (context, widget) => DefaultTextStyle(
              style: theme.typography.body1,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  static CarrotApp of(BuildContext context) {
    CarrotApp? instance = context.findAncestorWidgetOfExactType<CarrotApp>();

    if (instance == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          'CarrotApp.of() called with a context that does not contain a CarrotApp.',
        ),
      ]);
    }

    return instance;
  }
}
