import 'package:flutter/material.dart';

Widget buildDescription(String label, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(label,
        style: TextStyle(
          color: Color(0xff979797),
        )),
  );
}
