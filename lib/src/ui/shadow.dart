import 'package:flutter/widgets.dart';

class CarrotShadows {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> pixel = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.03),
      spreadRadius: .5,
    ),
  ];

  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      offset: Offset(0, 1.0),
      blurRadius: 2.0,
    ),
  ];

  static const List<BoxShadow> normal = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 1.0),
      blurRadius: 3.0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 1.0),
      blurRadius: 2.0,
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 4.0),
      blurRadius: 6.0,
      spreadRadius: -1.0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      offset: Offset(0, 2.0),
      blurRadius: 4.0,
      spreadRadius: -1.0,
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 10.0),
      blurRadius: 15.0,
      spreadRadius: -3.0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      offset: Offset(0, 4.0),
      blurRadius: 6.0,
      spreadRadius: -2.0,
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 20.0),
      blurRadius: 25.0,
      spreadRadius: -5.0,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 10.0),
      blurRadius: 10.0,
      spreadRadius: -5.0,
    ),
  ];
}
