import 'package:flutter/material.dart';
import 'package:pizza_user_app/screens/authentication/auth_screens.dart/login.dart';
import 'package:pizza_user_app/services/models/main_model.dart';
import 'package:pizza_user_app/widget_utils/dialog.dart';

forgotPassowrdController({
  MainModel model,
  String email,
  BuildContext context,
}) async {
  var message;
  message = await model.resetPass(email);
  if (message == true) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return displayDialog(
              'An email with password reset link has been send to your provided email id.',
              context,
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false),
              'Information!');
        });
  } else {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return displayDialog(
            message,
            context,
            () => Navigator.of(context).pop(),
          );
        });
  }
}
