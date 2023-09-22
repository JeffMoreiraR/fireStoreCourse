import 'package:firebase_alura/_core/my_colors.dart';
import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String message,
  bool isError = true,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isError ? Colors.red : MyColors.brown,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
