//import 'dart:html';

import 'package:flutter/material.dart';

class Utils {
  static final messangerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(BuildContext context, text, Color _color) {
    if (text == null) return;
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text),
          Icon(
            Icons.check,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: _color,
    );
    messangerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
