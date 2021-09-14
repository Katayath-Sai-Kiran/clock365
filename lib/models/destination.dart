import 'package:flutter/material.dart';

class Destination {
  final int id;
  final String name;
  final String iconPath;
  final Widget? child;

  const Destination(
      {required this.id, required this.iconPath, required this.name, this.child});
}
