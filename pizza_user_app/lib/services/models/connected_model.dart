import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_user_app/helper/helper.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedModel extends Model {
  bool _isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth _classTeachersAuth = FirebaseAuth.instance;
  String errorMessage;
  String idToken;
  String selCId;
  String collectionPath;
  String selSId;
  bool _isClassDeleteAllowed = false;
  //get currentUser ID
  getCurrentUserID() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    var uid = _user.uid;

    return uid;
  }

  //Admin Collection
  final CollectionReference _adminCollection =
      Firestore.instance.collection('adminDetails');

  //Class Collection
  final CollectionReference _classCollection =
      Firestore.instance.collection('classDetails');

  //Student Collection
  final CollectionReference studentCollection =
      Firestore.instance.collection('studentDetails');

  final CollectionReference _classTeacherCollection =
      Firestore.instance.collection('classTeacherDetails');
}

class AuthModel extends ConnectedModel {
  //Peform Signin Operation
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Invalid Password.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "Email not found.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          errorMessage = "Kindly! Check your Internet Connection.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return errorMessage;
    }
  }

  //Perform SignUp Operation
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "This email is already in use.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return errorMessage;
    }
  }

  //Perform Password Reset Operation
  Future resetPass(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "ّYour provided email not found.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    }
  }

  //Checking user logged in status
  getLoggedInStatus() async {
    return await HelperFunctions.getUserLoggedInSharedPreference();
  }

  //Perform SignOut Operation
  Future signOut() async {
    return await _auth.signOut();
  }
}




class Utilities extends ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}
