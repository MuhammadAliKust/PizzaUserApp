import 'package:flutter/material.dart';

Widget buildAlertButton(String text, VoidCallback onPressed) {
  return FlatButton(
    child: Text(text),
    onPressed: () => onPressed(),
  );
}
