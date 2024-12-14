import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/service/appsFlyer/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../utils/dialogs.dart';
import '../braze/service.dart';
import '../firebase/service.dart';

class AmplitudeService {
  static final Amplitude _amplitude = Amplitude.getInstance();
  // Initialize AppsFlyerService instance
  static final AppsFlyerService _appsFlyerService = AppsFlyerService(
    ApiKeys.appsFlyerKey,
    ApiKeys.iosAppID,
  );

  static final FirebaseService _firebaseService = FirebaseService();

  //INITIALIZE
  static Future<void> initialize() async {
    try {
      await _amplitude.init(ApiKeys.amplitudeKey);
      Utils().showLog('Amplitude Initialized Successfully');
    } catch (e) {
      Utils().showLog('Error while initializing $e');
    }
  }

  //FIRST OPEN
  static void logFirstOpenEvent() async {
    // if (kDebugMode) return;
    try {
      String? fcmToken = await Preference.getFcmToken();
      bool getFirstTime = await Preference.getAmplitudeFirstOpen();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      if (getFirstTime) {
        _logEvent(
          EventAmplitude.amp_firstopen.name,
          eventProperties: fcmToken != null
              ? {
                  'FCM': fcmToken,
                  "build_version": versionName,
                  "build_code": buildNumber,
                }
              : null,
        );

        _appsFlyerService.appsFlyerLogEvent(
          EventAppsFlyer.af_firstopen.name,
          eventProperties: fcmToken != null
              ? {
                  'FCM': fcmToken,
                  "build_version": versionName,
                  "build_code": buildNumber,
                }
              : null,
        );

        _firebaseService.firebaseLogEvent(
          EventFirebase.f_firstopen.name,
          eventProperties: fcmToken != null
              ? {
                  'FCM': fcmToken,
                  "build_version": versionName,
                  "build_code": buildNumber,
                }
              : null,
        );

        // _brazeService.logEvent(
        //   EventBraze.b_firstopen.name,
        //   eventProperties: fcmToken != null
        //       ? {
        //           'FCM': fcmToken,
        //           "build_version": versionName,
        //           "build_code": buildNumber,
        //         }
        //       : null,
        // );

        await Preference.setAmplitudeFirstOpen(false);
      }
    } catch (e) {
      //
    }
  }

  //LOG IN / SIGN UP
  static void logLoginSignUpEvent({
    required num isRegistered,
  }) async {
    // if (kDebugMode) return;

    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      String? referralCode = await Preference.getReferral();

      Map<String, dynamic> request = {
        "build_version": versionName,
        "build_code": buildNumber,
      };

      if (provider.user?.phone != null && provider.user?.phone != '') {
        request['phone'] = provider.user?.phone;
      }
      if (provider.user?.name != null && provider.user?.name != '') {
        request['user_name'] = provider.user?.name;
      }
      if (provider.user?.phoneCode != null && provider.user?.phoneCode != '') {
        request['country_code'] = provider.user?.phoneCode;
      }
      if (provider.user?.email != null && provider.user?.email != '') {
        request['email'] = provider.user?.email;
      }
      if (memCODE != null && memCODE != '') {
        request['distributor_code'] = memCODE;
      }
      if (referralCode != null && referralCode != '') {
        request['referral_code'] = referralCode;
      }
      if (address != null && address != '') {
        request['address'] = address;
      }
      if (fcmToken != null && fcmToken != '') {
        request['fcm_token'] = fcmToken;
      }
      if (provider.user != null) {
        request['membership'] = provider.user?.membership?.purchased == 1
            ? 'Purchased'
            : 'Not Purchased';
      }

      if (provider.user?.userId != null && provider.user?.userId != '') {
        _amplitude.setUserId(provider.user?.userId ?? '');
      }

      if (isRegistered == 1) {
        _logEvent(
          EventAmplitude.amp_signup.name,
          eventProperties: request,
        );
        _appsFlyerService.appsFlyerLogEvent(
          EventAppsFlyer.af_signup.name,
          eventProperties: request,
          userId: provider.user?.userId,
        );

        _firebaseService.firebaseLogEvent(
          EventFirebase.f_signup.name,
          eventProperties: request,
          userId: provider.user?.userId,
        );

        BrazeService.brazeBaseEvents(
          eventName: EventBraze.b_sign_up.name,
          eventProperties: request,
        );
      }
    } catch (e) {
      //
    }
  }

  //NOTIFICATION ENABLED
  static void logPushNotificationEnabledEvent(
    Map<String, dynamic>? request,
    String? userId,
  ) async {
    try {
      bool notReceived = await openNotificationsSettings();
      // Utils().showLog('Logging event: got permission ${!notReceived}');
      if (!notReceived) {
        _logEvent(
          'Push Notification Enabled',
          eventProperties: request,
        );
        _appsFlyerService.appsFlyerLogEvent(
          'Push Notification Enabled',
          eventProperties: request,
          userId: userId,
        );
      }
    } catch (e) {
      //
    }
  }

  //WATCHLIST UPDATED
  static void logWatchlistUpdateEvent({
    required bool added,
    required String symbol,
    required String companyName,
  }) async {
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      Map<String, dynamic> request = {
        "build_version": versionName,
        "build_code": buildNumber,
        "ticker_symbol": symbol,
        "company_name": companyName,
      };
      if (provider.user?.phone != null && provider.user?.phone != '') {
        request['phone'] = provider.user?.phone;
      }
      if (provider.user?.name != null && provider.user?.name != '') {
        request['user_name'] = provider.user?.name;
      }
      if (provider.user?.phoneCode != null && provider.user?.phoneCode != '') {
        request['country_code'] = provider.user?.phoneCode;
      }
      if (provider.user?.email != null && provider.user?.email != '') {
        request['email'] = provider.user?.email;
      }
      if (provider.user != null) {
        request['membership'] = provider.user?.membership?.purchased == 1
            ? 'Purchased'
            : 'Not Purchased';
      }
      if (provider.user?.userId != null && provider.user?.userId != '') {
        _amplitude.setUserId(provider.user?.userId ?? '');
      }
      _logEvent(
        added ? 'Added in Watchlist' : 'Removed from Watchlist',
        eventProperties: request,
      );
      _appsFlyerService.appsFlyerLogEvent(
        added ? 'Added in Watchlist' : 'Removed from Watchlist',
        eventProperties: request,
        userId: provider.user?.userId,
      );
    } catch (e) {
      //
    }
  }

  //ALERT UPDATED
  static void logAlertUpdateEvent({
    required bool added,
    required String symbol,
    required String companyName,
  }) async {
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      Map<String, dynamic> request = {
        "build_version": versionName,
        "build_code": buildNumber,
        "ticker_symbol": symbol,
        "company_name": companyName,
      };
      if (provider.user?.phone != null && provider.user?.phone != '') {
        request['phone'] = provider.user?.phone;
      }
      if (provider.user?.name != null && provider.user?.name != '') {
        request['user_name'] = provider.user?.name;
      }
      if (provider.user?.phoneCode != null && provider.user?.phoneCode != '') {
        request['country_code'] = provider.user?.phoneCode;
      }
      if (provider.user?.email != null && provider.user?.email != '') {
        request['email'] = provider.user?.email;
      }
      if (provider.user != null) {
        request['membership'] = provider.user?.membership?.purchased == 1
            ? 'Purchased'
            : 'Not Purchased';
      }
      if (provider.user?.userId != null && provider.user?.userId != '') {
        _amplitude.setUserId(provider.user?.userId ?? '');
      }
      _logEvent(
        added ? 'Added $symbol in Alerts' : 'Removed $symbol from Alerts',
        eventProperties: request,
      );
      _appsFlyerService.appsFlyerLogEvent(
        added ? 'Added $symbol in Alerts' : 'Removed $symbol from Alerts',
        eventProperties: request,
        userId: provider.user?.userId,
      );
    } catch (e) {
      //
    }
  }

  //USER INTERACTION
  static void logUserInteractionEvent({
    required String type,
    String? selfText,
  }) async {
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      Map<String, dynamic> request = {
        "build_version": versionName,
        "build_code": buildNumber,
      };
      if (selfText != null && selfText != '') {
        request['landed_on'] = selfText;
      }

      if (provider.user?.phone != null && provider.user?.phone != '') {
        request['phone'] = provider.user?.phone;
      }
      if (provider.user?.name != null && provider.user?.name != '') {
        request['user_name'] = provider.user?.name;
      }
      if (provider.user?.phoneCode != null && provider.user?.phoneCode != '') {
        request['country_code'] = provider.user?.phoneCode;
      }
      if (provider.user?.email != null && provider.user?.email != '') {
        request['email'] = provider.user?.email;
      }
      if (provider.user != null) {
        request['membership'] = provider.user?.membership?.purchased == 1
            ? 'Purchased'
            : 'Not Purchased';
      }
      if (provider.user?.userId != null && provider.user?.userId != '') {
        _amplitude.setUserId(provider.user?.userId ?? '');
      }

      _logEvent(
        type,
        eventProperties: request,
      );
      _appsFlyerService.appsFlyerLogEvent(
        type,
        eventProperties: request,
        userId: provider.user?.userId,
      );
    } catch (e) {
      //
    }
  }

  static void _logEvent(
    String eventName, {
    Map<String, dynamic>? eventProperties,
  }) {
    if (kDebugMode) return;
    try {
      Utils().showLog('Logging event:Amplitude $eventName');
      if (eventProperties != null) {
        // Utils().showLog('Event properties:Amplitude $eventProperties');
      }

      _amplitude.logEvent(
        eventName,
        eventProperties: eventProperties,
      );
    } catch (e) {
      Utils().showLog('Error while logEvent $e');
    }
  }
}
