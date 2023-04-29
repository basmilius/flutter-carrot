import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/l10n.dart';
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
    this.supportedLocales = CarrotLocalizations.supportedLocales,
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
    final effectiveTheme = _resolveEffectiveTheme();

    return CarrotAnimatedTheme(
      data: effectiveTheme,
      child: DefaultSelectionStyle(
        cursorColor: effectiveTheme.primary,
        selectionColor: effectiveTheme.primary,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: WidgetsApp(
            key: GlobalObjectKey(this),
            color: widget.settings.color,
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
            title: widget.settings.title,
            textStyle: effectiveTheme.typography.body1,
            builder: (context, _) => DefaultTextHeightBehavior(
              textHeightBehavior: effectiveTheme.typography.textHeightBehavior,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  CarrotThemeData _resolveEffectiveTheme() {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    final darkTheme = widget.themeDark ?? CarrotThemeData.dark();
    final lightTheme = widget.theme ?? CarrotThemeData.light();

    return platformBrightness == Brightness.light ? lightTheme : darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollNotificationObserver(
      child: ScrollConfiguration(
        behavior: const CarrotScrollBehavior(),
        child: MediaQuery.fromView(
          view: View.of(context),
          child: Builder(
            builder: _appBuilder,
          ),
        ),
      ),
    );
  }
}

class CarrotAppSettings {
  final Color color;
  final String title;

  const CarrotAppSettings({
    required this.color,
    required this.title,
  });
}
