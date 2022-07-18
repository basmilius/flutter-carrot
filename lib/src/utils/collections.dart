import 'package:flutter/widgets.dart' show Widget;

typedef CarrotWrapItemsPredicate<T> = T Function(T);

/// Puts the given [element] between each item in [iterable].
Iterable<T> intersperse<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;

  if (iterator.moveNext()) {
    yield iterator.current;

    while (iterator.moveNext()) {
      yield element;
      yield iterator.current;
    }
  }
}

/// Puts the given [element] between and outside each item in [iterable].
Iterable<T> intersperseOuter<T>(T element, Iterable<T> iterable) sync* {
  final iterator = iterable.iterator;

  if (iterable.isNotEmpty) {
    yield element;
  }

  while (iterator.moveNext()) {
    yield iterator.current;
    yield element;
  }
}

/// Same as [intersperse], but for widgets only.
List<Widget> intersperseWidgets(Widget? element, List<Widget> widgets) => element == null || widgets.length <= 1 ? widgets : intersperse(element, widgets).toList();

List<T> wrapItems<T>(List<T> items, CarrotWrapItemsPredicate<T> predicate) => items.map((item) => predicate(item)).toList();
