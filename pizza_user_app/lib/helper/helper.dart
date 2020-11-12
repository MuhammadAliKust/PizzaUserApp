import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceSchoolName = "SCHOOLNAME";
  static String sharedPreferenceEmail = "EMAILID";
  static String sharedPreferencePassword = "PASSWORD";
  static String sharedPreferenceUid = "UID";
  static String sharedPrefrenceLat = "LAT";
  static String sharedPrefrenceLng = "LNG";

  /// saving data to sharedpreference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveCurrentUserEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceEmail, email);
  }

  static Future<bool> saveCurrentUserPassword(String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferencePassword, password);
  }

  static Future<bool> saveUserLoggedInUidSharedPreference(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUid, uid);
  }

  static Future<bool> saveLat(var lat) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setDouble(sharedPrefrenceLat, lat);
  }

  static Future<bool> saveLng(var lng) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setDouble(sharedPrefrenceLng, lng);
  }

  /// fetching data from sharedpreference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getSchoolNameSharedPrefrence() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceSchoolName);
  }

  static Future<String> getCurrentUserEmailId() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    return await prefrences.getString(sharedPreferenceEmail);
  }

  static Future<String> getCurrentUserPassword() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    return await prefrences.getString(sharedPreferencePassword);
  }

  static Future<String> getUserLoggedInUidSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUid);
  }

  static Future<double> getLat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(sharedPrefrenceLat);
  }

  static Future<double> getLng() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(sharedPrefrenceLng);
  }
}
