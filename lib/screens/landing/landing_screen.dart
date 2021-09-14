import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  final int index;

  const LandingScreen({Key? key, required this.index}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(child: Image.asset('')),
        Text('Response'),
        Text('Meeting point after evacuation'),
        LinearProgressIndicator()
      ],),
    );
  }
}
