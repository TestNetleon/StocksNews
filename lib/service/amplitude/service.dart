import 'package:amplitude_flutter/amplitude.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/appsFlyer/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../firebase/service.dart';

class AmplitudeService {
  static final Amplitude _amplitude = Amplitude.getInstance();

  AmplitudeService._internal();
  static final AmplitudeService _instance = AmplitudeService._internal();
  static AmplitudeService get instance => _instance;

  //INITIALIZE
  Future<void> initialize() async {
    try {
      await _amplitude.init(ApiKeys.amplitudeKey);
      Utils().showLog('Amplitude Initialized Successfully');
    } catch (e) {
      Utils().showLog('Error while initializing $e');
    }
  }

  //MARK:FIRST OPEN
  void logFirstOpenEvent() async {
    // if (kDebugMode) return;
    try {
      String? fcmToken = await Preference.getFcmToken();
      bool getFirstTime = await Preference.getAmplitudeFirstOpen();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      if (getFirstTime) {
        logEvent(
          EventAmplitude.amp_firstopen.name,
          eventProperties: fcmToken != null
              ? {
                  'FCM': fcmToken,
                  "build_version": versionName,
                  "build_code": buildNumber,
                }
              : null,
        );

        AppsFlyerService.instance.appsFlyerLogEvent(
          EventAppsFlyer.af_firstopen.name,
          eventProperties: fcmToken != null
              ? {
                  'FCM': fcmToken,
                  "build_version": versionName,
                  "build_code": buildNumber,
                }
              : null,
        );

        FirebaseService.instance.firebaseLogEvent(
          EventFirebase.f_firstopen.name,
          eventProperties: fcmToken != null
              ? {
                  'FCM': fcmToken,
                  "build_version": versionName,
                  "build_code": buildNumber,
                }
              : null,
        );

        await Preference.setAmplitudeFirstOpen(false);
      }
    } catch (e) {
      //
    }
  }

  //MARK:LOG IN / SIGN UP
  void logLoginSignUpEvent({
    required num isRegistered,
  }) async {
    // if (kDebugMode) return;

    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
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
        logEvent(
          EventAmplitude.amp_signup.name,
          eventProperties: request,
        );
        AppsFlyerService.instance.appsFlyerLogEvent(
          EventAppsFlyer.af_signup.name,
          eventProperties: request,
          userId: provider.user?.userId,
        );

        FirebaseService.instance.firebaseLogEvent(
          EventFirebase.f_signup.name,
          eventProperties: request,
          userId: provider.user?.userId,
        );

        // BrazeService.brazeBaseEvents(
        //   eventName: EventBraze.b_sign_up.name,
        //   eventProperties: request,
        // );
      }
    } catch (e) {
      //
    }
  }

  void logEvent(
    String eventName, {
    Map<String, dynamic>? eventProperties,
  }) {
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
