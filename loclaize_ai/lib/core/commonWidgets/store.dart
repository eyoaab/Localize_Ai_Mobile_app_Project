import 'package:flutter/material.dart';

void showMessage(BuildContext context, Icon title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Center(child: title),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// InputDecoration customInputDecoration({
//   required String labelText,
//   required Icon prefixIcon,
// }) {
//   return InputDecoration(
//     labelText: labelText,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10.0),
//     ),
//     prefixIcon: prefixIcon,
//   );
// }

InputDecoration customInputDecoration({
  required String labelText,
  required Icon prefixIcon,
  Color enabledBorderColor = Colors.grey,
  Color focusedBorderColor = Colors.blue,
  Color errorBorderColor = Colors.red,
}) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: enabledBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: focusedBorderColor),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorBorderColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorBorderColor),
    ),
  );
}
