import 'dart:math';

int imul(int x, int y) {
  return (x.toUnsigned(32) * y.toUnsigned(32)).toSigned(32);
}

double radians(double angle) {
  return pi / 180 * angle;
}
