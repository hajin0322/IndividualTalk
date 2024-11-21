import 'package:flutter/material.dart';

class AppStyles {
  static Color chatBackground = Colors.blue.shade200;

  static TextStyle appbar =
  const TextStyle(fontSize: 28, fontWeight: FontWeight.w600);
  static TextStyle chatbar =
  const TextStyle(fontSize: 26, fontWeight: FontWeight.w600);
  static TextStyle t1 =
  const TextStyle(fontSize: 20, fontWeight: FontWeight.w400);

  static TextStyle? s1(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }
}
