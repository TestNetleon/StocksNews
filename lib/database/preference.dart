import 'dart:convert';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Future<bool> setShowIntro(bool isFirstTime) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("@firstTime", isFirstTime);
  }

  static Future<bool> getShowIntro() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("@firstTime") ?? true;
  }

  static Future<bool> setIsFirstOpen(bool isFirstTime) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("@firstOpen", isFirstTime);
  }

  static Future<bool> isFirstOpen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("@firstOpen") ?? true;
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.containsKey("@userLogin");
  }

  static void saveUser(response) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("@userLogin", jsonEncode(response));
  }

  static Future<UserRes?> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userString = preferences.getString("@userLogin");
    if (userString == null) return null;

    try {
      UserRes? user = UserRes.fromJson(jsonDecode(userString));
      return user;
    } catch (e) {
      return null;
    }
    // return userString == null ? null : UserRes.fromJson(jsonDecode(userString));
  } //

  static void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("@userLogin");
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
    if (preferences.containsKey("@localDataBase")) {
      final localDataBaseString = preferences.getString("@localDataBase");
      return localDataBaseString == null || localDataBaseString == "null"
          ? null
          : MessageRes.fromJson(jsonDecode(localDataBaseString));
    } else {
      return null;
    }
  }

  static Future<String?> getReferral() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("@referral");
  }

  static void saveReferral(code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("@referral", code);
  }

  static void clearReferral() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("@referral");
  }

  static Future<bool> isReferInput() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("@referralInput") ?? false;
  }

  static void saveReferInput(bool? value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("@referralInput", value ?? true);
  }

  static Future<bool> setAmplitudeFirstOpen(bool isFirstTime) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("@amplitudeFirstOpen", isFirstTime);
  }

  static Future<bool> getAmplitudeFirstOpen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("@amplitudeFirstOpen") ?? true;
  }

  //App Tracking
  static const _trackingKey = 'app_tracking_allowed';

  static Future<void> setTrackingPreference(bool isAllowed) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_trackingKey, isAllowed);
  }

  static Future<bool?> isTrackingAllowed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_trackingKey);
  }
}
