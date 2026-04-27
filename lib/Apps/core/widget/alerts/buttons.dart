import 'package:flutter/material.dart';

Widget outlineBtn(String text, VoidCallback onTap) {
  return OutlinedButton(
    onPressed: onTap,
    child: Text(text),
  );
}

Widget fillBtn(String text, Color color, VoidCallback onTap) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: color),
    onPressed: onTap,
    child: Text(text),
  );
}