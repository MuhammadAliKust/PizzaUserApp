import 'package:flutter/material.dart';
import 'package:pizza_user_app/helper/helper.dart';
import 'package:pizza_user_app/screens/distance_selecter.dart';
import 'package:pizza_user_app/services/models/main_model.dart';
import 'package:pizza_user_app/widget_utils/dialog.dart';

loginController(
  MainModel model,
  var message,
  String email,
  String password,
  BuildContext context,
) async {

  message = await model.signInWithEmailAndPassword(email, password);
  if (message == true) {
    HelperFunctions.saveUserLoggedInSharedPreference(true);
    HelperFunctions.saveCurrentUserEmail(email);
    HelperFunctions.saveCurrentUserPassword(password);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => DistanceSelecter(

            )));
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
