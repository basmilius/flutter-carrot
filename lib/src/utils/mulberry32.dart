import 'dart:math';

class Mulberry32 {
  late int _state;

  Mulberry32({
    required int seed,
  }) : _state = seed;

  double next() {
    _state = (_state + 0x6D2B79F5) & 0xFFFFFFFF;
    int z = _state;
    z = (((z ^ (z >> 15))) * (z | 1)) & 0xFFFFFFFF;
    z ^= z + (z ^ (z >> 7)) * (z | 61);
    z &= 0xFFFFFFFF;

    return (z ^ (z >> 14)) / 4294967296;
  }

  double nextBetween(double from, double to) {
    return next() * (to - from) + from;
  }

  Mulberry32 fork() {
    return Mulberry32(
      seed: pow(next() * 2, 32).toInt(),
    );
  }
}
