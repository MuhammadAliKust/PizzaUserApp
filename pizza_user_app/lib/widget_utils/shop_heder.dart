 import 'package:flutter/material.dart';
import 'package:pizza_user_app/widget_utils/build_heading.dart';
import 'package:pizza_user_app/widget_utils/display_rating.dart';

Widget buildShopName(BuildContext context, {
  var shopName, var rating
}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildHeading(context,shopName),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: displayRating(rating),
        )
      ]),
    );
  }