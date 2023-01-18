import 'package:flutter/widgets.dart';

import '../extension/extension.dart';

enum CarrotIconStyle {
  brand,
  duotone,
  thin,
  light,
  regular,
  solid,
}

class CarrotIcon extends StatelessWidget {
  final Color? color;
  final String glyph;
  final String? semanticsLabel;
  final double? size;
  final CarrotIconStyle? style;

  const CarrotIcon({
    super.key,
    required this.glyph,
    this.color,
    this.semanticsLabel,
    this.size,
    this.style,
  });

  String _fontFamily(CarrotIconStyle style) {
    style = this.style ?? style;

    switch (style) {
      case CarrotIconStyle.brand:
        return "font_awesome_brands";

      case CarrotIconStyle.duotone:
        return "font_awesome_duotone";

      default:
        return "font_awesome";
    }
  }

  FontWeight _fontWeight(CarrotIconStyle style) {
    style = this.style ?? style;

    switch (style) {
      case CarrotIconStyle.duotone:
        return FontWeight.w900;

      case CarrotIconStyle.thin:
        return FontWeight.w100;

      case CarrotIconStyle.light:
        return FontWeight.w300;

      case CarrotIconStyle.solid:
        return FontWeight.w900;

      default:
        return FontWeight.w400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.carrotTheme;
    final dts = DefaultTextStyle.of(context).style;
    final stableSize = size ?? dts.fontSize ?? 20.0;

    return Semantics(
      image: true,
      label: semanticsLabel,
      child: SizedBox(
        height: stableSize,
        width: stableSize,
        child: Align(
          alignment: AlignmentDirectional.center,
          child: Transform.scale(
            alignment: AlignmentDirectional.center,
            scale: 1.25,
            child: Text(
              glyph,
              softWrap: false,
              textAlign: TextAlign.center,
              textScaleFactor: .8,
              style: TextStyle(
                color: color,
                fontFamily: _fontFamily(appTheme.defaults.iconStyle),
                fontSize: stableSize,
                fontWeight: _fontWeight(appTheme.defaults.iconStyle),
                height: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarrotIconDuotone extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final double primaryOpacity;
  final double secondaryOpacity;
  final String glyph;
  final String? semanticsLabel;
  final double? size;

  const CarrotIconDuotone({
    super.key,
    required this.glyph,
    this.primaryColor = const Color(0xff1e293b),
    this.secondaryColor = const Color(0xffbe123c),
    this.primaryOpacity = 1.0,
    this.secondaryOpacity = 1.0,
    this.semanticsLabel,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticsLabel,
      child: ExcludeSemantics(
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
              child: Text("$glyph#",
                  style: TextStyle(
                    color: primaryColor.withOpacity(primaryOpacity),
                    fontFamily: "font_awesome_duotone",
                    fontSize: size,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  )),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
              child: Text("$glyph##",
                  style: TextStyle(
                    color: secondaryColor.withOpacity(secondaryOpacity),
                    fontFamily: "font_awesome_duotone",
                    fontSize: size,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
