import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../app/settings.dart';
import '../theme/theme.dart';
import 'scroll/scroll.dart';

class CarrotApp extends StatefulWidget {
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
  final CarrotThemeData? theme;
  final CarrotThemeData? themeDark;

  const CarrotApp({
    super.key,
    required this.child,
    required this.settings,
    this.theme,
    this.themeDark,
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
    this.useInheritedMediaQuery = true,
  });

  @override
  createState() => _CarrotAppState();

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

class _CarrotAppState extends State<CarrotApp> {
  Widget _appBuilder(BuildContext context) {
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final effectiveTheme = platformBrightness == Brightness.light ? (widget.theme ?? CarrotThemeData.light()) : (widget.themeDark ?? CarrotThemeData.dark());

    return CarrotAnimatedTheme(
      data: effectiveTheme,
      child: DefaultSelectionStyle(
        cursorColor: effectiveTheme.primary,
        selectionColor: effectiveTheme.primary,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: WidgetsApp(
            key: GlobalObjectKey(this),
            color: effectiveTheme.primary,
            locale: widget.locale,
            localizationsDelegates: widget.localizationsDelegates,
            localeResolutionCallback: widget.localeResolutionCallback,
            localeListResolutionCallback: widget.localeListResolutionCallback,
            supportedLocales: widget.supportedLocales,
            actions: widget.actions,
            shortcuts: widget.shortcuts,
            navigatorObservers: widget.navigatorObservers,
            restorationScopeId: widget.restorationScopeId,
            checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
            checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
            debugShowCheckedModeBanner: widget.showDebugBanner,
            debugShowWidgetInspector: widget.debugShowWidgetInspector,
            inspectorSelectButtonBuilder: widget.inspectorSelectButtonBuilder,
            showPerformanceOverlay: widget.showPerformanceOverlay,
            showSemanticsDebugger: widget.showSemanticsDebugger,
            useInheritedMediaQuery: widget.useInheritedMediaQuery,
            title: widget.settings.title,
            textStyle: effectiveTheme.typography.body1,
            builder: (context, _) => DefaultTextHeightBehavior(
              textHeightBehavior: effectiveTheme.typography.textHeightBehavior,
              child: DefaultTextStyle(
                style: effectiveTheme.typography.body1,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollNotificationObserver(
      child: ScrollConfiguration(
        behavior: const CarrotScrollBehavior(),
        child: MediaQuery.fromWindow(
          child: Builder(
            builder: _appBuilder,
          ),
        ),
      ),
    );
  }
}
