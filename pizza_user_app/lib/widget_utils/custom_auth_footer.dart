import 'package:flutter/material.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/screens/authentication/auth_screens.dart/login.dart';
import 'package:pizza_user_app/screens/authentication/auth_screens.dart/signUp.dart';

Widget buildSignUpRow(
    String leading, String linkText, bool isLogin, BuildContext context) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    Text(
      leading,
      style: label_style,
    ),
    InkWell(
      onTap: () => !isLogin
          ? Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Login()))
          : Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => SignUp())),
      child: Text(
        linkText.toUpperCase(),
        style:
            TextStyle(color: icon_color, decoration: TextDecoration.underline, letterSpacing: 1),
      ),
    ),
  ]);
}
