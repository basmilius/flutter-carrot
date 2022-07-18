import 'package:flutter/widgets.dart';

extension CarrotUtilExtension on BuildContext {
  EdgeInsets get safeArea {
    var padding = MediaQuery.of(this).padding;

    return EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, padding.bottom / 2);
  }

  EdgeInsets get safeAreaReal {
    var padding = MediaQuery.of(this).padding;

    return EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, padding.bottom);
  }
}
