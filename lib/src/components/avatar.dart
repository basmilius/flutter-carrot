import 'package:flutter/widgets.dart';

import '../app/extensions/extensions.dart';
import '../ui/ui.dart';

const _kDefaultAvatarSize = 60.0;

const _swatches = [
  CarrotColors.amber,
  CarrotColors.blue,
  CarrotColors.cyan,
  CarrotColors.emerald,
  CarrotColors.fuchsia,
  CarrotColors.green,
  CarrotColors.indigo,
  CarrotColors.lime,
  CarrotColors.orange,
  CarrotColors.pink,
  CarrotColors.purple,
  CarrotColors.red,
  CarrotColors.rose,
  CarrotColors.sky,
  CarrotColors.teal,
  CarrotColors.violet,
  CarrotColors.yellow,
];

class CarrotAvatar extends StatelessWidget {
  final ImageProvider<Object>? image;
  final String? letters;
  final double size;
  final CarrotColor? color;
  final Widget? visual;

  const CarrotAvatar({
    super.key,
    this.color,
    this.size = _kDefaultAvatarSize,
    this.visual,
  })  : image = null,
        letters = null;

  const CarrotAvatar.image(this.image, {
    super.key,
    this.color,
    this.size = _kDefaultAvatarSize,
  })  : letters = null,
        visual = null;

  const CarrotAvatar.letters(this.letters, {
    super.key,
    this.color,
    this.size = _kDefaultAvatarSize,
  })  : image = null,
        visual = null;

  @override
  Widget build(BuildContext context) {
    final swatch = _swatches[(letters ?? image ?? context.hashCode).hashCode % _swatches.length];

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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: swatch[context.carrotTheme.resolve(100, 900)],
      ),
      child: ClipOval(
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
