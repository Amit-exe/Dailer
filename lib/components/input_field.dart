import 'package:flutter/material.dart';

Widget InputFieldMaker(String textLabel, TextEditingController controller_obj,
    TextInputType keyboardType, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
    child: TextField(
      onEditingComplete: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      controller: controller_obj,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: textLabel,
      ),
    ),
  );
}
