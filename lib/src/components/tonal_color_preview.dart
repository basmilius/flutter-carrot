import 'package:flutter/widgets.dart';

import '../ui/ui.dart';
import 'basic.dart';

class CarrotTonalColorPreview extends StatelessWidget {
  final CarrotTonalColor tones;

  const CarrotTonalColorPreview({
    super.key,
    required this.tones,
  });

  @override
  Widget build(BuildContext context) {
    return CarrotRow(
      children: [
        _ColorTone(color: tones[0]),
        _ColorTone(color: tones[10]),
        _ColorTone(color: tones[20]),
        _ColorTone(color: tones[30]),
        _ColorTone(color: tones[40]),
        _ColorTone(color: tones[50]),
        _ColorTone(color: tones[60]),
        _ColorTone(color: tones[70]),
        _ColorTone(color: tones[80]),
        _ColorTone(color: tones[90]),
        _ColorTone(color: tones[95]),
        _ColorTone(color: tones[99]),
        _ColorTone(color: tones[100]),
      ],
    );
  }
}

class _ColorTone extends StatelessWidget {
  final Color color;

  const _ColorTone({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 21,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
        ),
      ),
    );
  }
}
