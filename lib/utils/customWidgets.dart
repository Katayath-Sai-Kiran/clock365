import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomWidgets {
  ScaffoldFeatureController snacbar(
      {required String text, required BuildContext context}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.black,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.orange,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    maxLines: 10,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(),
              ],
            ),
          ),
        )));
  }
}
