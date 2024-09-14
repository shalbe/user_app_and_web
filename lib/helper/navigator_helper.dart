import 'package:flutter/material.dart';

class MyNav {
  static Future<T?> goTo<T extends Object?>(
    BuildContext context,
    Widget page, {
    bool fullscreenDialog = false,
  }) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => page, fullscreenDialog: fullscreenDialog),
    );
  }

  static void goBack<T extends Object?>(BuildContext context,
      [T? result]) async {
    return Navigator.pop(context, result);
  }
}
