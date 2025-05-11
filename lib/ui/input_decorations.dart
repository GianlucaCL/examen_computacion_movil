import 'package:flutter/material.dart';

class InputDecortions {
  static InputDecoration authInputDecoration({
    required String hinText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color(0xFFB01AF0),
        )),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color(0xFFB01AF0),
          width: 1.5,
        )),
        hintText: hinText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 193, 167, 227)),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: const Color(0xFFB01AF0),
              )
            : null);
  }
}
