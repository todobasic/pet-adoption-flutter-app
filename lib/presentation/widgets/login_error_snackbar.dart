import 'package:flutter/material.dart';

void showLoginErrorSnackBar(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(error),
  ));
}