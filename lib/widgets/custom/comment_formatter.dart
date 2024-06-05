import 'package:flutter/services.dart';

class CustomCommentInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Define the allowed characters (numbers, letters, spaces, full stops, commas)
    final RegExp regExp = RegExp(r'^[0-9a-zA-Z .,]*$');

    // Check if the new value matches the regular expression
    if (regExp.hasMatch(newValue.text)) {
      // If it matches, return the new value
      return newValue;
    } else {
      // If it doesn't match, filter out invalid characters
      final String filteredText =
          newValue.text.replaceAll(RegExp(r"[^0-9a-zA-Z .,':;]"), '');

      return TextEditingValue(
        text: filteredText,
        selection: TextSelection.collapsed(offset: filteredText.length),
      );
    }
  }
}
