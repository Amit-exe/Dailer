import 'package:flutter/material.dart';

Widget InputFieldMaker(String textLabel, TextEditingController controller_obj,
    TextInputType keyboardType) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    child: TextField(
      controller: controller_obj,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: textLabel,
      ),
    ),
  );
}
