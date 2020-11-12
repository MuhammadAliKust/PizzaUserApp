import 'package:flutter/material.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/screens/menu_list.dart';
import 'package:pizza_user_app/widget_utils/EmptyCartWidget.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';


class ThanksNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pizzeria"),
      elevation: 0,
      backgroundColor: base_color,),
      body: DataNotAvailable(Icons.shopping_cart, 'Thanks for your feedback.'),
    );
  }
}
