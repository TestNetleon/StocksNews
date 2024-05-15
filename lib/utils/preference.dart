import 'dart:convert';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Future<bool> setFirstTime(bool isFirstTime) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("@firstTime", isFirstTime);
  }

  static Future<bool> getFirstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("@firstTime") ?? true;
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.containsKey("@userlogin");
  }

  static void saveUser(response) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("@userlogin", jsonEncode(response));
  }

  static Future<UserRes?> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userString = preferences.getString("@userlogin");
    return userString == null ? null : UserRes.fromJson(jsonDecode(userString));
  } //

  static void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("@userlogin");
  }

  static Future<String?> getFcmToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("@fcmToken");
  }

  static void saveFcmToken(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("@fcmToken", token);
  }

  static Future<String?> getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("@location");
  }

  static void saveLocation(address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("@location", address);
  }
}
