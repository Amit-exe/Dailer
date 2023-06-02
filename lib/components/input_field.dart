import 'package:flutter/material.dart';

Widget InputFieldMaker(String textLabel, TextEditingController controller_obj) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    child: TextField(
      controller: controller_obj,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: textLabel,
      ),
    ),
  );
}
