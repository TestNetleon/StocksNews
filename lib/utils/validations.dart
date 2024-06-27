import 'package:flutter/services.dart';

bool isMobileNumber(String? number) {
  final regExp = RegExp(r'^[4-9]{1}[0-9]{9}$');
  if (number != null && regExp.hasMatch(number)) {
    return true;
  }
  return false;
}

// bool isEmail(String email) {
//   // Define a regular expression for a valid email address
//   final emailRegExp = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//   );
//
//   // Use the regular expression to check if the email is valid
//   return emailRegExp.hasMatch(email);
// }

bool isName(String? name) {
  final regExp = RegExp('[a-zA-Z]');
  if (name != null && name.length > 2 && regExp.hasMatch(name)) {
    return true;
  }
  return false;
}

bool isEmpty(String? name) {
  if (name != null && name.isNotEmpty) {
    return false;
  }
  return true;
}

String validateWithHyphen(String? name) {
  if (name != null && name.isNotEmpty) {
    return name.trim();
  }
  return "-";
}

bool isOTP(String? otp) {
  final regExp = RegExp(r'^[0-9]{4}$');
  if (otp != null && otp.length == 4 && regExp.hasMatch(otp)) {
    return true;
  }
  return false;
}

List<String> hexColors = [
  '#ff6384',
  '#36a2eb',
  '#ffce56',
  '#4bc0c0',
  '#9966ff',
  '#ff9f40',
];

FilteringTextInputFormatter allSpecialSymbolsRemove =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 \w\s\n]'));
// FilteringTextInputFormatter dotSpecialSymbolsallow =
//     FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\.]'));
FilteringTextInputFormatter dotSpecialSymbolsallow =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9. ]'));
FilteringTextInputFormatter emailFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]'));
// FilteringTextInputFormatter.allow(RegExp(r'[ ]'));
FilteringTextInputFormatter mobilrNumberAllow =
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
FilteringTextInputFormatter addressAllow =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ./,-]'));
// FilteringTextInputFormatter zipCodeAllow =
//     FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
FilteringTextInputFormatter vehicleNumberAllow =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'));
FilteringTextInputFormatter socialSecurityCardAllow =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]'));
final FilteringTextInputFormatter jobHistoryFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-., ]+'));

FilteringTextInputFormatter nameFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$'));
FilteringTextInputFormatter usPhoneNumber = FilteringTextInputFormatter.allow(
    RegExp(r'^(\d{3}[-.\s]?\d{3}[-.\s]?\d{4})$'));
