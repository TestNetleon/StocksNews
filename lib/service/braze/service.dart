import 'dart:io';
import 'package:braze_plugin/braze_plugin.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BrazeService {
  static const MethodChannel _channel = MethodChannel('brazeMethod');
  static final BrazePlugin _braze = BrazePlugin(
    customConfigs: {replayCallbacksConfigKey: true},
    brazeSdkAuthenticationErrorHandler: (e) {
      print('authentication error : $e ');
    },
  );

  Future<void> registerFCM(pushToken) async {
    _braze.registerPushToken(pushToken);
    print("Registering fcm $pushToken");
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
        if (Platform.isAndroid) {
          _braze.changeUser(userId);
        } else {
          await _channel.invokeMethod('changeUser', {'userId': userId});
        }
        Utils().showLog('changeUser $userId');
      }, "change user");
    }

    // Add Alias if aliasName and aliasLabel are provided
    if (aliasName != null &&
        aliasName != '' &&
        aliasLabel != null &&
        aliasLabel != '') {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.addAlias(aliasName, aliasLabel);
        } else {
          await _channel.invokeMethod('addAlias', {
            'aliasName': aliasName,
            'aliasLabel': aliasLabel,
          });
        }
      }, "add alias");
    }

    // Log Custom Event if eventName is provided
    if (eventName != null && eventName != '') {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.logCustomEvent(eventName, properties: eventProperties ?? {});
        } else {
          await _channel.invokeMethod('logCustomEvent', {
            'eventName': eventName,
            'properties': eventProperties ?? {},
          });
        }
      }, "log custom event");
    }

    // Log Purchase if productId, currencyCode, price, and quantity are provided
    if (productId != null &&
        currencyCode != null &&
        price != null &&
        quantity != null) {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.logPurchase(
            productId,
            currencyCode,
            double.parse(price),
            int.parse(quantity),
          );
        } else {
          await _channel.invokeMethod('logPurchase', {
            'productId': productId,
            'currencyCode': currencyCode,
            'price': price,
            'quantity': quantity,
            'properties': eventProperties ?? {},
          });
        }
      }, "log purchase");
    }

    // Set First Name if provided
    if (firstName != null && firstName != '') {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.setFirstName(firstName);
        } else {
          await _channel.invokeMethod('setFirstName', {'firstName': firstName});
          Utils().showLog('setFirstName $firstName');
        }
      }, "set first name");
    }

    // Set Last Name if provided
    if (lastName != null && lastName != '') {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.setLastName(lastName);
        } else {
          await _channel.invokeMethod('setLastName', {'lastName': lastName});
          Utils().showLog('setLastName $lastName');
        }
      }, "set last name");
    }

    // Set Email if provided
    if (email != null && email != '') {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.setEmail(email);
        } else {
          await _channel.invokeMethod('setEmail', {'email': email});
          Utils().showLog('setEmail $email');
        }
      }, "set email");
    }

    // Set Phone Number if provided
    if (phoneNumber != null && phoneNumber != '') {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.setPhoneNumber(phoneNumber);
        } else {
          await _channel
              .invokeMethod('setPhoneNumber', {'phoneNumber': phoneNumber});
          Utils().showLog('setPhoneNumber $phoneNumber');
        }
      }, "set phone number");
    }

    // Set Watchlist or Alerts if provided
    if (alerts != null) {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.setCustomUserAttributeArrayOfStrings('alerts', alerts);
        } else {
          await _channel.invokeMethod('setWatchlistOrAlert', {
            'eventName': 'alerts',
            'tickers': alerts,
          });
          Utils().showLog('setAlerts ${alerts.length}');
        }
      }, "set alerts");
    }

    if (watchlist != null) {
      await executeAction(() async {
        if (Platform.isAndroid) {
          _braze.setCustomUserAttributeArrayOfStrings('watchlists', watchlist);
        } else {
          await _channel.invokeMethod('setWatchlistOrAlert', {
            'eventName': 'watchlists',
            'tickers': watchlist,
          });
          Utils().showLog('setWatchlists ${watchlist.length}');
        }
      }, "set watchlist");
    }

    // Set Custom Attribute if provided
    if (attributionKey != null && attributionKey != '') {
      await executeAction(() async {
        if (Platform.isAndroid) {
          if (attributeValue is String) {
            _braze.setStringCustomUserAttribute(attributionKey, attributeValue);
          } else {
            _braze.setIntCustomUserAttribute(attributionKey, attributeValue);
          }
        } else {
          await _channel.invokeMethod('setCustomAttribute', {
            'key': attributionKey,
            'value': attributeValue,
          });
        }
      }, "set custom attribute");
    }
  }
}
