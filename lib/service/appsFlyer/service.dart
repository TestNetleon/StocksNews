import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:validators/validators.dart';
import '../../api/apis.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

class AppsFlyerService {
  AppsFlyerService._internal();

  static final AppsFlyerService _instance = AppsFlyerService._internal();

  static AppsFlyerService get instance => _instance;

  AppsflyerSdk? _appsFlyerSdk;

  // Future<void> getDeviceID() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     String deviceId = androidInfo.id;
  //     print("Android Device ID: $deviceId");
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     String? deviceId = iosInfo.identifierForVendor;
  //     print("iOS Device ID: $deviceId");
  //   }
  // }

  Future<void> initializeSdk() async {
    try {
      final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: ApiKeys.appsFlyerKey,
        appId: Platform.isIOS ? ApiKeys.iosAppID : '',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 30,
        disableCollectASA: false,
        disableAdvertisingIdentifier: false,
      );

      _appsFlyerSdk = AppsflyerSdk(options);
      _appsFlyerSdk?.enableTCFDataCollection(true);

      await _appsFlyerSdk?.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );

      final appsFlyerId = await _appsFlyerSdk?.getAppsFlyerUID();

      Utils().showLog("UID => $appsFlyerId");

      appsFlyerUID = appsFlyerId;
      try {
        _appsFlyerSdk?.setOneLinkCustomDomain(['pagelink.stocks.news']);
      } catch (e) {
        //
      }

      if (appsFlyerId != null) {
        try {
          _appsFlyerSdk?.setCustomerUserId(appsFlyerId);
        } catch (e) {
          //
        }

        // await Purchases.setAppsflyerID(appsFlyerId);
        appsFlyerUID = appsFlyerId;
      }

      handleDeepLinking();
      Utils().showLog("AppsFlyer ID: $appsFlyerId");

      Timer(const Duration(seconds: 5), () {
        // createUserInvitationLink();
      });
    } catch (e) {
      Utils().showLog("failed: $e");
      handleDeepLinking();
    }
  }

  appsFlyerLogEvent(
    String eventName, {
    Map<String, dynamic>? eventProperties,
    String? userId,
  }) {
    try {
      if (userId != null && userId != '') {
        _appsFlyerSdk?.setCustomerUserId(userId);
      }
      _appsFlyerSdk?.logEvent(
        eventName,
        eventProperties,
      );
      Utils().showLog('Logging event:Apps Flyer $eventName');
    } catch (e) {
      Utils().showLog('Error while logEvent $e');
    }
  }

  handleDeepLinking() {
    _appsFlyerSdk?.onDeepLinking(
      (result) {
        String? deepLinkUrl;
        if (result.deepLink?.clickEvent != null) {
          final clickEventMap = result.deepLink?.clickEvent;
          deepLinkUrl = clickEventMap?['link'];
        }

        Utils().showLog('Deep Link URL: ${deepLinkUrl ?? "No link found"}');

        // Map data = {
        //   'afSub1': result.deepLink?.afSub1 ?? 'N/A',
        //   'afSub2': result.deepLink?.afSub2 ?? 'N/A',
        //   'afSub3': result.deepLink?.afSub3 ?? 'N/A',
        //   'afSub4': result.deepLink?.afSub4 ?? 'N/A',
        //   'afSub5': result.deepLink?.afSub5 ?? 'N/A',
        //   'campaign': result.deepLink?.campaign ?? 'N/A',
        //   'campaignId': result.deepLink?.campaignId ?? 'N/A',
        //   'clickEvent': '${result.deepLink?.clickEvent.entries}',
        //   'clickHttpReferrer': '${result.deepLink?.clickHttpReferrer}',
        //   'deepLinkValue': '${result.deepLink?.deepLinkValue}',
        //   'isDeferred': '${result.deepLink?.isDeferred}',
        //   'matchType': '${result.deepLink?.matchType}',
        //   'mediaSource': '${result.deepLink?.mediaSource}',
        // };
        // Utils().showLog('AppsFlyer Deep Link Data ${jsonEncode(data)}');
        sendReferralData(jsonEncode(result));
        if (kDebugMode) {
          print(
            "C = ${result.deepLink?.campaign}\nMT = ${result.deepLink?.matchType}\nCode = ${result.deepLink?.deepLinkValue}\nLink = $deepLinkUrl",
          );
        }

        if (result.deepLink?.campaign == "Referral" ||
            result.deepLink?.matchType == "referrer") {
          Utils().showLog('HI IF');
          getReferralCodeIfAny(result.deepLink?.deepLinkValue);
          return;
        } else if (deepLinkUrl != null && deepLinkUrl != '') {
          Utils().showLog('HI ELSE IF');

          if (result.deepLink?.campaign == "Referral" ||
              result.deepLink?.matchType == "referrer") {
            getReferralCodeIfAny(result.deepLink?.deepLinkValue);
            return;
          }
          if ((!(deepLinkUrl.startsWith('http') ||
                  deepLinkUrl.startsWith('https')) ||
              deepLinkUrl.contains(
                  'app.stocks.news://google/link/?request_ip_version='))) {
            return;
          }

          final clickEventMap = result.deepLink?.clickEvent;
          if (clickEventMap != null) {
            getDistributorCode(clickEventMap);
          }
          // getDistributorCodeIfAny(deepLinkUrl);
          handleDeepLinkNavigation(uri: Uri.tryParse(deepLinkUrl));
        }
      },
    );
  }

  // getDistributorCodeIfAny(url) {
  //   Uri? uri = Uri.tryParse(url);
  //   if (uri != null && uri.queryParameters.containsKey('distributor_code')) {
  //     String fullQuery = uri.query;
  //     int index = fullQuery.indexOf('distributor_code=');
  //     if (index != -1) {
  //       String result = fullQuery.substring(index + 'distributor_code='.length);
  //       memCODE = result;
  //       Utils().showLog(memCODE);
  //     }
  //   }
  // }

  String getDistributorCode(Map<String, dynamic>? clickEvent) {
    try {
      if (clickEvent == null || clickEvent.isEmpty) {
        if (kDebugMode) {
          print('No click event data found.');
        }
        return '';
      }

      // Convert MapEntries to key-value pairs
      Map<String, String> queryParams = {};

      // Iterate over the map and add all entries to queryParams
      clickEvent.forEach((key, value) {
        queryParams[key] = value.toString();
        if (kDebugMode) {
          print('Key: $key, Value: $value');
        }
      });

      // Check if distributor_code is present
      if (!queryParams.containsKey('distributor_code')) {
        if (kDebugMode) {
          print('No distributor_code found.');
        }
        return '';
      }

      // Prepare the list of key-value pairs
      List<String> keyValuePairs = [];

      // Add distributor_code first
      String distributorCode = queryParams['distributor_code'] ?? '';
      keyValuePairs.add(distributorCode);
      if (kDebugMode) {
        print('Distributor Code: $distributorCode');
      }

      // Add other query parameters
      queryParams.forEach((key, value) {
        if (key != 'distributor_code') {
          keyValuePairs.add('$key=$value');
          if (kDebugMode) {
            print('Added: $key=$value');
          }
        }
      });

      // Combine into a single string
      String result = keyValuePairs.join('&');
      memCODE = result;
      Utils().showLog('Final Combined String: $result');
      return result;
    } catch (e) {
      return '';
    }
  }

  getReferralCodeIfAny(referralCode) async {
    bool isFirstOpen = await Preference.isFirstOpen();
    String? code = await Preference.getReferral();
    if (referralCode != null &&
        referralCode != "" &&
        (code == null || code == '') &&
        isFirstOpen) {
      Preference.saveReferral(referralCode);
      Timer(const Duration(seconds: 4), () {
        UserManager manager = navigatorKey.currentContext!.read<UserManager>();
        if (manager.user == null && !signUpVisible) {
          manager.askLoginScreen();
        }
      });
      FirebaseAnalytics.instance.logEvent(
        name: 'referrals',
        parameters: {'referral_code': referralCode},
      );
    }
    onDeepLinking = false;
  }

  // Future createUserInvitationLink() async {
  //   UserManager manager = navigatorKey.currentContext!.read<UserManager>();
  //   Utils().showLog('HIIIII1');
  //   if (manager.user == null) {
  //     return;
  //   }

  //   AppsFlyerInviteLinkParams params = AppsFlyerInviteLinkParams(
  //     brandDomain: 'pagelink.stocks.news',
  //     referrerName: 'User Invitation',
  //     campaign: 'Referral',
  //     customerID: manager.user?.userId ?? '',
  //     channel: "referral",
  //     customParams: {
  //       "deep_link_value": manager.user?.referralCode,
  //       "type": 'referral',
  //     },
  //   );
  //   Utils().showLog('HIIIII2');

  //   _appsFlyerSdk?.setAppInviteOneLinkID("Zsdh", (dynamic) {
  //     if (kDebugMode) {
  //       print('generateInviteLink SUCCESS $dynamic');
  //     }
  //     Utils().showLog('HIIIII3 $dynamic');
  //   });
  //   Utils().showLog('HIIIII31');

  //   try {
  //     Utils().showLog('HIIIII41');
  //     Future.delayed(
  //       Duration(milliseconds: 300),
  //       () {
  //         _appsFlyerSdk?.generateInviteLink(params, (data) {
  //           Utils().showLog('HIIIII4');

  //           Utils().showLog('generateInviteLink SUCCESS $data');
  //           try {
  //             final inviteLink = data["payload"]["userInviteURL"];
  //             if (isURL(inviteLink)) {
  //               Utils()
  //                   .showLog('HIIIII4 *** THIS IS A VALID URL *** $inviteLink');
  //               manager.updatePersonalDetails(
  //                 referralUrl: inviteLink,
  //                 showProgress: false,
  //                 showSuccess: false,
  //               );
  //             }
  //           } catch (e) {
  //             Utils().showLog(data);
  //           }
  //         }, (data) {
  //           Utils().showLog('generateInviteLink ERROR $data');
  //         });
  //       },
  //     );
  //   } catch (e) {
  //     Utils().showLog('HIIIII4 $e');
  //   }
  // }

  Future<String?> createUserInvitationLink() async {
    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    if (manager.user == null) {
      return null;
    }
    Completer<String?> completer = Completer<String?>();
    AppsFlyerInviteLinkParams params = AppsFlyerInviteLinkParams(
      brandDomain: 'pagelink.stocks.news',
      referrerName: 'User Invitation',
      campaign: 'Referral',
      customerID: manager.user?.userId ?? '',
      channel: "referral",
      customParams: {
        "deep_link_value": manager.user?.referralCode,
        "type": 'referral',
      },
    );
    _appsFlyerSdk?.setAppInviteOneLinkID("Zsdh", (dynamic) {
      if (kDebugMode) {
        print('generateInviteLink SUCCESS $dynamic');
      }
      Utils().showLog('HIIIII3 $dynamic');
    });
    try {
      Future.delayed(
        Duration(milliseconds: 300),
        () {
          _appsFlyerSdk?.generateInviteLink(params, (data) async {
            if (kDebugMode) {
              print('generateInviteLink SUCCESS $data');
            }
            try {
              final inviteLink = data["payload"]["userInviteURL"];
              if (isURL(inviteLink)) {
                shareUrl = inviteLink;
                Utils().showLog(' *** THIS IS A VALID URL *** $inviteLink');
                // Update manager with the invite link
                await manager.updatePersonalDetails(
                  referralUrl: inviteLink,
                  showProgress: false,
                  showSuccess: false,
                );
                // Complete with the invite link
                completer.complete(inviteLink);
              } else {
                completer.complete(null);
              }
            } catch (e) {
              Utils().showLog(data);
              completer.complete(null);
            }
          }, (error) {
            if (kDebugMode) {
              print('generateInviteLink ERROR $error');
            }
            completer.complete(null);
          });
        },
      );
    } catch (e) {
      Utils().showLog('HIIIII4 error $e');
    }

    return completer.future;
  }
}

Future<void> sendReferralData(data, {fromLogin = false}) async {
  const url = 'https://app.stocks.news/api/v2/store-request-all-data';
  String? fcmToken = await Preference.getFcmToken();
  Map<String, String> headers = getHeaders();

  if (fcmToken != null) {
    Map<String, String> fcmHeaders = {"fcmToken": fcmToken};
    headers.addAll(fcmHeaders);
  }

  if (appVersion != null) {
    Map<String, String> versionHeader = {
      "appVersion": "$appVersion",
      "platform": Platform.operatingSystem,
    };
    headers.addAll(versionHeader);
  }

  final body = jsonEncode({
    'fcm_token': fcmToken ?? '',
    'data': data,
    'on_login': '$fromLogin',
  });
  Utils().showLog('REF->  REQUEST: $body');

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      Utils().showLog('REF->  Success: ${response.body}');
    } else {
      Utils()
          .showLog('REF->  Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    Utils().showLog('REF->  Exception: $e');
  }
}
