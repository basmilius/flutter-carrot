import 'package:flutter/painting.dart';

/// Checks whether the given [border] has at least one
/// side that has a positive width.
bool hasPositiveBorder(Border border) {
  if (border.isUniform && border.top.width > 0) {
    return true;
  }

  if (border.top.width > 0) {
    return true;
  }

  if (border.left.width > 0) {
    return true;
  }

  if (border.right.width > 0) {
    return true;
  }

  if (border.bottom.width > 0) {
    return true;
  }

  return false;
}

/// Checks whether the given [borderRadius] has at least
/// one positive value.
bool hasPositiveBorderRadius(BorderRadiusGeometry borderRadius) {
  if (borderRadius is! BorderRadius) {
    return false;
  }

  if (borderRadius.topLeft.x > 0 || borderRadius.topLeft.y > 0) {
    return true;
  }

  if (borderRadius.topRight.x > 0 || borderRadius.topRight.y > 0) {
    return true;
  }

  if (borderRadius.bottomLeft.x > 0 || borderRadius.bottomLeft.y > 0) {
    return true;
  }

  if (borderRadius.bottomRight.x > 0 || borderRadius.bottomRight.y > 0) {
    return true;
  }

  return false;
}
