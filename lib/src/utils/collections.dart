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

/// Wraps the items in given [list] using the given [predicate].
List<T> wrapItems<T>(List<T> list, CarrotWrapItemsPredicate<T> predicate) => list.map(predicate).toList();

extension CarrotList<T> on List<T> {
  /// Maps over the list using [convert] that is given
  /// both [index] and [item].
  Iterable<R> mapIndexed<R>(R Function(int index, T item) convert) sync* {
    for (int index = 0; index < length; ++index) {
      yield convert(index, this[index]);
    }
  }
}
