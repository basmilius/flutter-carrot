import 'package:flutter/widgets.dart';

extension CarrotBuildContextExtension on BuildContext {
  /// Gets the safe area, but tweaked a little bit.
  EdgeInsets get safeArea {
    var padding = MediaQuery.of(this).padding;

    return EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, padding.bottom / 2);
  }

  /// Gets the real safe area.
  EdgeInsets get safeAreaReal {
    var padding = MediaQuery.of(this).padding;

    return EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, padding.bottom);
  }
}
