import 'package:flutter/material.dart';

InputDecoration passwordInputDecoration({
  required String labelText,
  required bool isPasswordVisible,
  required VoidCallback togglePasswordVisibility,
}) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
    suffixIcon: IconButton(
      icon: Icon(
        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.blueAccent,
      ),
      onPressed: togglePasswordVisibility, 
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
