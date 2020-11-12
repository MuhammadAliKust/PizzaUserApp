import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_user_app/screens/authentication/auth_screens.dart/login.dart';
import 'package:pizza_user_app/services/models/main_model.dart';
import 'package:pizza_user_app/widget_utils/dialog.dart';

signUpController({
  MainModel model,
  var message,
  String email,
  String password,
  String name,
  String instituteName,
  BuildContext context,
}) async {
  message = await model.signUpWithEmailAndPassword(email, password);

  if (message == true) {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var _user = user.uid;
    Firestore.instance.collection('users').add({
      'id':_user,
      'name':name,
      'email':email
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
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
