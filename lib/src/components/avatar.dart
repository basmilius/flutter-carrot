import 'package:flutter/widgets.dart';

import '../app/extensions/extensions.dart';
import '../ui/ui.dart';

const _kDefaultAvatarSize = 60.0;

class CarrotAvatar extends StatelessWidget {
  final BorderRadius? borderRadius;
  final ImageProvider<Object>? image;
  final String? letters;
  final double size;
  final CarrotColor? color;
  final Widget? visual;

  const CarrotAvatar({
    super.key,
    this.borderRadius,
    this.color,
    this.size = _kDefaultAvatarSize,
    this.visual,
  })  : image = null,
        letters = null;

  const CarrotAvatar.image(
    this.image, {
    super.key,
    this.borderRadius,
    this.color,
    this.size = _kDefaultAvatarSize,
  })  : letters = null,
        visual = null;

  const CarrotAvatar.letters(
    this.letters, {
    super.key,
    this.borderRadius,
    this.color,
    this.size = _kDefaultAvatarSize,
  })  : image = null,
        visual = null;

  @override
  Widget build(BuildContext context) {
    final swatch = CarrotColors.colorful[(letters ?? image ?? context.hashCode).hashCode];

    Widget media;

    if (letters != null) {
      media = Text(letters!);
    } else if (image != null) {
      media = Image(
        image: image!,
        alignment: Alignment.center,
        fit: BoxFit.cover,
        height: size,
        width: size,
      );
    } else if (visual != null) {
      media = visual!;
    } else {
      media = Container();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(size),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: swatch[context.carrotTheme.resolve(100, 900)],
        ),
        child: SizedBox.square(
          dimension: size,
          child: Center(
            child: DefaultTextStyle(
              style: context.carrotTypography.base.copyWith(
                color: swatch[context.carrotTheme.resolve(500, 400)],
                fontSize: size * 0.35,
                fontWeight: FontWeight.w600,
              ),
              child: media,
            ),
          ),
        ),
      ),
    );
  }
}
