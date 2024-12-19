import 'dart:io';
import 'package:braze_plugin/braze_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../database/preference.dart';
import '../../utils/constants.dart';

class BrazeService {
  // static const MethodChannel _channel = MethodChannel('brazeMethod');
  static final BrazePlugin _braze = BrazePlugin(
    customConfigs: {replayCallbacksConfigKey: true},
    brazeSdkAuthenticationErrorHandler: (e) {
      Utils().showLog('authentication error : $e ');
    },
  );

  Future<void> registerFCM(pushToken) async {
    _braze.registerPushToken(pushToken);
  }

  // INITIALIZE SDK Android
  Future<void> initialize() async {
    try {
      _braze.enableSDK();
      Utils().showLog('Braze SDK Initialized Successfully');
    } catch (e) {
      Utils().showLog('Error while initializing Braze: $e');
    }
  }

  static Future<void> brazeUserEvent() async {
    UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
    if (user != null) {
      String? firstName;
      String? lastName;
      String? phoneNumber;

      //Creating string for name
      if (user.name != null && user.name != '') {
        List<String> nameParts = user.name!.split(' ');

        if (nameParts.length > 1) {
          firstName = nameParts[0];
          lastName = nameParts.sublist(1).join(' ');
        } else {
          firstName = nameParts[0];
        }
      }

      //Creating string for phone number
      if (user.phoneCode != null &&
          user.phoneCode != '' &&
          user.phone != null &&
          user.phone != '') {
        phoneNumber = '${user.phoneCode}${user.phone}';
        // country = CountryCode.fromDialCode(user.phoneCode!).name;
        // if (user.phoneCode == '+1') {
        //   country = 'United States';
        // }
      } else if (user.phone != null && user.phone != '') {
        phoneNumber = '${user.phone}';
      }

      brazeBaseEvents(
        userId: user.userId,
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        phoneNumber: phoneNumber,
      );

      brazeBaseEvents(
        attributionKey: 'user_type',
        attributeValue: user.membership?.productID == null ||
                user.membership?.productID == ''
            ? 'free'
            : user.membership?.productID,
      );

      if (user.pointEarn != null) {
        brazeBaseEvents(
          attributionKey: 'points_balance',
          attributeValue: user.pointEarn,
        );
      }
    }
  }

  static Future<void> membershipVisit() async {
    UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
    if (user?.membership?.purchased == 1) return;
    String? fcmToken = await Preference.getFcmToken();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String? referralCode = await Preference.getReferral();

    Map<String, dynamic> request = {
      "build_version": versionName,
      "build_code": buildNumber,
      "platform": Platform.operatingSystem,
    };
    if (user?.userId != null && user?.userId != '') {
      request['external_id'] = user?.userId;
    }
    if (memCODE != null && memCODE != '') {
      request['distributor_code'] = memCODE;
    }
    if (referralCode != null && referralCode != '') {
      request['referral_code'] = referralCode;
    }
    if (fcmToken != null && fcmToken != '') {
      request['fcm_token'] = fcmToken;
    }

    brazeBaseEvents(
      eventName: EventBraze.upgrade_screen_view.name,
      eventProperties: request,
    );
  }

  static Future<void> eventContentView({
    required String screenType,
    String? source,
    List<String>? featuredStocks,
  }) async {
    UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;

    Map<String, dynamic> request = {};

    request['type'] = screenType;

    if (user?.userId != null && user?.userId != '') {
      request['id'] = user?.userId;
    }

    if (source != null && source != '') {
      request['source'] = source;
    }

    if (featuredStocks != null && featuredStocks.isNotEmpty) {
      request['featured_stocks'] = featuredStocks;
    }

    brazeBaseEvents(
      eventName: EventBraze.content_view.name,
      eventProperties: request,
    );
  }

  static Future<void> brazeBaseEvents({
    String? userId,
    String? aliasName,
    String? aliasLabel,
    String? eventName,
    Map<String, dynamic>? eventProperties,
    String? productId,
    String? currencyCode,
    String? price,
    String? quantity,
    String? firstName,
    String? lastName,
    String? country,
    String? email,
    String? phoneNumber,
    List<String>? watchlist,
    List<String>? alerts,
    dynamic attributeValue,
    String? attributionKey,
  }) async {
    // Helper function to execute the action with error handling
    Future<void> executeAction(
        Future<void> Function() action, String actionName) async {
      try {
        await action();
      } catch (e) {
        Utils().showLog("Failed to $actionName: ${e.toString()}");
      }
    }

    // Change User if userId is provided
    if (userId != null && userId != '') {
      await executeAction(() async {
        _braze.changeUser(userId);
        Utils().showLog('changeUser: $userId');
      }, "change user");
    }

    // Add Alias if aliasName and aliasLabel are provided
    if (aliasName != null &&
        aliasName != '' &&
        aliasLabel != null &&
        aliasLabel != '') {
      await executeAction(() async {
        _braze.addAlias(aliasName, aliasLabel);
        Utils().showLog('addAlias: name?$aliasName, label?$aliasLabel');
      }, "add alias");
    }

    // Log Custom Event if eventName is provided
    if (eventName != null && eventName != '') {
      await executeAction(() async {
        _braze.logCustomEvent(eventName, properties: eventProperties ?? {});
        Utils().showLog(
            'logCustomEvent: eventName?$eventName, properties?$eventProperties');
      }, "log custom event");
    }

    // Log Purchase if productId, currencyCode, price, and quantity are provided
    // if (productId != null &&
    //     currencyCode != null &&
    //     price != null &&
    //     quantity != null) {
    //   await executeAction(() async {
    //     _braze.logPurchase(
    //       productId,
    //       currencyCode,
    //       double.parse(price),
    //       int.parse(quantity),
    //     );
    //   }, "log purchase");
    // }

    // Set First Name if provided
    if (firstName != null && firstName != '') {
      await executeAction(() async {
        _braze.setFirstName(firstName);
        Utils().showLog('setFirstName: $firstName');
      }, "set first name");
    }

    // Set Last Name if provided
    if (lastName != null && lastName != '') {
      await executeAction(() async {
        _braze.setLastName(lastName);
        Utils().showLog('setLastName: $lastName');
      }, "set last name");
    }

    // Set Email if provided
    if (email != null && email != '') {
      await executeAction(() async {
        _braze.setEmail(email);
        Utils().showLog('setEmail: $email');
      }, "set email");
    }

    // Set Phone Number if provided
    if (phoneNumber != null && phoneNumber != '') {
      await executeAction(() async {
        _braze.setPhoneNumber(phoneNumber);
        Utils().showLog('setPhoneNumber: $phoneNumber');
      }, "set phone number");
    }

    // Set Watchlist or Alerts if provided
    if (alerts != null) {
      await executeAction(() async {
        _braze.setCustomUserAttributeArrayOfStrings('alerts', alerts);
        Utils().showLog('alerts: $alerts');
      }, "set alerts");
    }

    if (watchlist != null) {
      await executeAction(() async {
        _braze.setCustomUserAttributeArrayOfStrings('watchlists', watchlist);
        Utils().showLog('watchlists: $watchlist');
      }, "set watchlist");
    }

    // Set Custom Attribute if provided
    if (attributionKey != null && attributionKey != '') {
      await executeAction(() async {
        if (attributeValue is String) {
          _braze.setStringCustomUserAttribute(attributionKey, attributeValue);
          Utils().showLog('string: key?$attributionKey,value?$attributeValue');
        } else {
          _braze.setIntCustomUserAttribute(attributionKey, attributeValue);
          Utils().showLog('int: key?$attributionKey,value?$attributeValue');
        }
      }, "set custom attribute");
    }
  }
}
