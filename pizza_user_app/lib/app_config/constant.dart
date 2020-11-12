import 'package:flutter/material.dart';

imgDecoration(String img) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage(img),
      fit: BoxFit.fill,
      alignment: Alignment.topCenter,
    ),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

textFieldDecoration(String label, [String hint]) {
  return InputDecoration(
      disabledBorder: outline_input_border,
      labelText: label,
      labelStyle: TextStyle(color: base_color),
      hintText: hint == null ? '' : hint,
      border: outline_input_border,
      enabledBorder: outline_input_border,
      focusedBorder: outline_input_border);
}



var icon_color = Color(0xff3877D4);
double icon_size = 20;
var base_color = Color(0xff3877D4);
var appBarColor = Color(0xff3877D4);
var button_color = Color(0xff3877D4);
var focused_border =
    UnderlineInputBorder(borderSide: BorderSide(color: icon_color));
var underline_input_border =
    UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff3877D4)));
var outline_input_focused_border =
    OutlineInputBorder(borderSide: BorderSide.none);

var outline_input_border =
    OutlineInputBorder(borderSide: BorderSide(color: base_color));
var button_border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(13), borderSide: BorderSide.none);
var label_style = TextStyle(color: Color(0xff3877D4));
var hint_style = TextStyle(color: Color(0xff3877D4));
var button_border_radius =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
var text_field_text_style = TextStyle(color: Colors.black);
var text_theme = TextTheme(
  headline2: TextStyle(color: Colors.black),
  caption: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w300,
  ),
);

var theme_data = ThemeData(
    canvasColor: Colors.white,
    fontFamily: 'ProductSans',
    // primaryColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0, foregroundColor: Colors.white),
    // brightness: Brightness.light,
    textTheme: text_theme);

dynamic boxDecoration(BuildContext context) {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)));
}

var button_text_style = TextStyle(color: Colors.white);

var textField_filled_color = Color(0xffece7e7);
