import 'dart:convert';
import 'package:stocks_news_new/api/api_response.dart';
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

  static Future<int> getMinTimeDifferenceMillis() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt("@last_review_timestamp") ?? 0;
  }

  static void saveMinTimeDifferenceMillis(minTimeDifferenceMillis) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("@last_review_timestamp", minTimeDifferenceMillis);
  }

  static Future<String?> getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("@location");
  }

  static void saveLocation(address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("@location", address ?? "");
  }

  static void saveLocalDataBase(response) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("@localDataBase", jsonEncode(response));
  }

  static Future<MessageRes?> getLocalDataBase() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final localDataBaseString = preferences.getString("@localDataBase");
    return localDataBaseString == null
        ? null
        : MessageRes.fromJson(jsonDecode(localDataBaseString));
  }

  static Future<String?> getReferral() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("@referral");
  }

  static void saveReferral(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("@referral", token);
  }
}
