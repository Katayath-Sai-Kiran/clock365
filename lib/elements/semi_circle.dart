import 'package:flutter/material.dart';

class SemiCircle extends StatelessWidget {
  const SemiCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 64,
        width: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(56), bottomRight: Radius.circular(56)),
        ));
  }
}
