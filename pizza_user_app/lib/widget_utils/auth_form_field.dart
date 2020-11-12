import 'package:flutter/material.dart';
import 'package:pizza_user_app/app_config/constant.dart';

Widget buildFormField(
    {Function(String) validator,
    TextStyle style,
    String label,
    String hint,
    IconData icon,
    bool cursor = true,
    FocusNode focusNode,
    TextInputType keyBoardType = TextInputType.text,
    VoidCallback onTap,
    int maxLines = 1,
    Function(String) onSaved,
    Function(String) onSubmit}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
    child: TextFormField(
      textInputAction: TextInputAction.done,
      validator: validator,
      focusNode: focusNode,
      showCursor: cursor,
      keyboardType: keyBoardType,
      maxLines: maxLines,
      style: text_field_text_style,
      cursorColor: base_color,
      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: icon_color,
            size: icon_size,
          ),
          labelText: label,
          labelStyle: label_style,
          hintText: hint,
          hintStyle: hint_style,
          focusedBorder: focused_border,
          enabledBorder: underline_input_border,
          border: underline_input_border),
      onSaved: onSaved,
      onFieldSubmitted: onSubmit,
    ),
  );
}
