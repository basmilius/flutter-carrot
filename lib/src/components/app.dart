import 'package:flutter/widgets.dart';

import '../app/settings.dart';
import '../ui/theme.dart';

class CarrotApp extends StatelessWidget {
  final Widget child;
  final Locale? locale;
  final LocaleResolutionCallback? localeResolutionCallback;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final CarrotAppSettings settings;
  final Map<Type, Action<Intent>>? actions;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final List<NavigatorObserver> navigatorObservers;
  final String? restorationScopeId;
  final bool checkerboardOffscreenLayers;
  final bool checkerboardRasterCacheImages;
  final bool debugShowWidgetInspector;
  final InspectorSelectButtonBuilder? inspectorSelectButtonBuilder;
  final bool showDebugBanner;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final bool useInheritedMediaQuery;
  final CarrotTheme theme;

  const CarrotApp({
    super.key,
    required this.child,
    required this.settings,
    required this.theme,
    this.locale,
    this.localeResolutionCallback,
    this.localeListResolutionCallback,
    this.localizationsDelegates,
    this.supportedLocales = const [Locale('en', 'US')],
    this.actions,
    this.shortcuts,
    this.navigatorObservers = const [],
    this.restorationScopeId,
    this.checkerboardOffscreenLayers = false,
    this.checkerboardRasterCacheImages = false,
    this.debugShowWidgetInspector = false,
    this.inspectorSelectButtonBuilder,
    this.showDebugBanner = false,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.useInheritedMediaQuery = false,
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
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            localeResolutionCallback: localeResolutionCallback,
            localeListResolutionCallback: localeListResolutionCallback,
            supportedLocales: supportedLocales,
            actions: actions,
            shortcuts: shortcuts,
            navigatorObservers: navigatorObservers,
            restorationScopeId: restorationScopeId,
            checkerboardOffscreenLayers: checkerboardOffscreenLayers,
            checkerboardRasterCacheImages: checkerboardRasterCacheImages,
            debugShowCheckedModeBanner: showDebugBanner,
            debugShowWidgetInspector: debugShowWidgetInspector,
            inspectorSelectButtonBuilder: inspectorSelectButtonBuilder,
            showPerformanceOverlay: showPerformanceOverlay,
            showSemanticsDebugger: showSemanticsDebugger,
            useInheritedMediaQuery: useInheritedMediaQuery,
            title: settings.title,
            textStyle: theme.typography.body1,
            builder: (context, widget) => DefaultTextHeightBehavior(
              textHeightBehavior: theme.typography.textHeightBehavior,
              child: DefaultTextStyle(
                style: theme.typography.body1,
                child: child,
              ),
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
