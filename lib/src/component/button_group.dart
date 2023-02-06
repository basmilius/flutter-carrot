part of 'button.dart';

typedef _GetThemeData = _CarrotButtonThemeData Function(BuildContext);
typedef _WrapTheme = Widget Function(Widget, _CarrotButtonThemeData);

class CarrotButtonGroup extends StatelessWidget {
  final List<Widget> children;
  final _GetThemeData _getThemeData;
  final _WrapTheme _wrapTheme;

  const CarrotButtonGroup.contained({
    super.key,
    required this.children,
  })  : assert(children.length > 1),
        _getThemeData = _getContainedButtonThemeData,
        _wrapTheme = _wrapContainedButtonTheme;

  const CarrotButtonGroup.link({
    super.key,
    required this.children,
  })  : assert(children.length > 1),
        _getThemeData = _getLinkButtonThemeData,
        _wrapTheme = _wrapLinkButtonTheme;

  const CarrotButtonGroup.text({
    super.key,
    required this.children,
  })  : assert(children.length > 1),
        _getThemeData = _getTextButtonThemeData,
        _wrapTheme = _wrapTextButtonTheme;

  Widget _wrap({
    required Widget child,
    required _CarrotButtonThemeData theme,
    bool first = false,
    bool last = false,
  }) {
    final middle = !first && !last;

    return _wrapTheme(
      child,
      theme.copyWith(
        borderRadius: CarrotOptional.of((theme.borderRadius ?? BorderRadius.zero).copyWith(
          topLeft: middle || last ? Radius.zero : null,
          topRight: middle || first ? Radius.zero : null,
          bottomLeft: middle || last ? Radius.zero : null,
          bottomRight: middle || first ? Radius.zero : null,
        )),
        shadow: const CarrotOptional.of(CarrotShadows.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    for (final child in children) {
      assert(child is _CarrotButton);
    }

    final first = children.removeAt(0) as _CarrotButton;
    final last = children.removeLast() as _CarrotButton;
    final theme = _getThemeData(context);

    return AnimatedContainer(
      curve: first.curve,
      duration: last.duration,
      decoration: BoxDecoration(
        borderRadius: theme.borderRadius,
        boxShadow: theme.shadow,
        color: theme.background,
      ),
      child: CarrotFlex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        gap: -1,
        children: [
          _wrap(
            theme: theme,
            first: true,
            child: first,
          ),
          ...children.map((child) => _wrap(
                theme: theme,
                child: child,
              )),
          _wrap(
            theme: theme,
            last: true,
            child: last,
          ),
        ],
      ),
    );
  }
}

CarrotContainedButtonThemeData _getContainedButtonThemeData(BuildContext context) => CarrotContainedButtonTheme.of(context);

CarrotLinkButtonThemeData _getLinkButtonThemeData(BuildContext context) => CarrotLinkButtonTheme.of(context);

CarrotTextButtonThemeData _getTextButtonThemeData(BuildContext context) => CarrotTextButtonTheme.of(context);

Widget _wrapContainedButtonTheme(Widget child, _CarrotButtonThemeData theme) => CarrotContainedButtonTheme(
      data: CarrotContainedButtonThemeData.raw(
        background: theme.background,
        backgroundActive: theme.backgroundActive,
        border: theme.border,
        borderActive: theme.borderActive,
        borderRadius: theme.borderRadius,
        fontFamily: theme.fontFamily,
        fontSize: theme.fontSize,
        fontWeight: theme.fontWeight,
        foreground: theme.foreground,
        foregroundActive: theme.foregroundActive,
        padding: theme.padding,
        shadow: theme.shadow,
        shadowActive: theme.shadowActive,
        tapScale: theme.tapScale,
      ),
      child: child,
    );

Widget _wrapLinkButtonTheme(Widget child, _CarrotButtonThemeData theme) => CarrotLinkButtonTheme(
      data: CarrotLinkButtonThemeData.raw(
        background: theme.background,
        backgroundActive: theme.backgroundActive,
        border: theme.border,
        borderActive: theme.borderActive,
        borderRadius: theme.borderRadius,
        fontFamily: theme.fontFamily,
        fontSize: theme.fontSize,
        fontWeight: theme.fontWeight,
        foreground: theme.foreground,
        foregroundActive: theme.foregroundActive,
        padding: theme.padding,
        shadow: theme.shadow,
        shadowActive: theme.shadowActive,
        tapScale: theme.tapScale,
      ),
      child: child,
    );

Widget _wrapTextButtonTheme(Widget child, _CarrotButtonThemeData theme) => CarrotTextButtonTheme(
      data: CarrotTextButtonThemeData.raw(
        background: theme.background,
        backgroundActive: theme.backgroundActive,
        border: theme.border,
        borderActive: theme.borderActive,
        borderRadius: theme.borderRadius,
        fontFamily: theme.fontFamily,
        fontSize: theme.fontSize,
        fontWeight: theme.fontWeight,
        foreground: theme.foreground,
        foregroundActive: theme.foregroundActive,
        padding: theme.padding,
        shadow: theme.shadow,
        shadowActive: theme.shadowActive,
        tapScale: theme.tapScale,
      ),
      child: child,
    );
