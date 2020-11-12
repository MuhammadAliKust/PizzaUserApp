import 'package:flutter/material.dart';

Widget buildHeading(BuildContext context, String label) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      label,
      style: Theme.of(context)
          .textTheme
          .headline6
          .merge(TextStyle(fontWeight: FontWeight.w500)),
    ),
  );
}
