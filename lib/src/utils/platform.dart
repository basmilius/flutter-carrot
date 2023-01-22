import 'package:flutter/widgets.dart';

bool isKeyboardOpen(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom > 0;
}
