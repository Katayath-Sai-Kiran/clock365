import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomWidgets {
  ScaffoldFeatureController snacbar(
      {required String text, required BuildContext context}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
      content: Text(text),
    ));
  }
}
