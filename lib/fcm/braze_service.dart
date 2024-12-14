// import 'dart:async';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:braze_plugin/braze_plugin.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// import '../api/api_requester.dart';
// import '../api/api_response.dart';
// import '../api/apis.dart';
// import '../database/preference.dart';
// import '../providers/home_provider.dart';
// import '../providers/user_provider.dart';
// import '../service/braze/service.dart';
// import '../utils/constants.dart';

// class BrazeNotificationService {
//   final BrazePlugin _braze =
//       BrazePlugin(customConfigs: {replayCallbacksConfigKey: true});
//   StreamSubscription? _pushEventsStreamSubscription;
//   StreamSubscription? _inAppMessageStreamSubscription;
//   static final BrazeNotificationService _instance =
//       BrazeNotificationService._internal();

//   factory BrazeNotificationService() {
//     return _instance;
//   }

//   BrazeNotificationService._internal();

//   Future<void> setupPushNotifications() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     await messaging.requestPermission();

//     String? fcmToken;
//     await messaging.getToken().then((value) async {
//       if (value != null) {
//         BrazeService().startSession();
//         _braze.registerPushToken(value);
//         fcmToken = value;
//         Utils().showLog("FCM Token registered with Braze: $value");
//       }
//     });

//     String? address = await _getUserLocation();
//     saveFcmAPI(address: address, value: fcmToken);
//   }

//   void _initializeBraze() {}

//   void initialize() async {
//     await BrazeService.initialize();

//     setupPushNotifications();

//     _pushEventsStreamSubscription =
//         _braze.subscribeToPushNotificationEvents((BrazePushEvent pushEvent) {
//       _handlePushEvent(pushEvent);

//       Utils().showLog('isPaused? ${_pushEventsStreamSubscription?.isPaused}');
//     });

//     _inAppMessageStreamSubscription =
//         _braze.subscribeToInAppMessages((BrazeInAppMessage inAppMessage) {
//       _braze.logInAppMessageClicked(inAppMessage);
//       _braze.logInAppMessageImpression(inAppMessage);
//       _braze.logInAppMessageButtonClicked(inAppMessage, 0);
//     });

//     Utils().showLog("Braze push notification listener initialized.");
//   }

//   void _handlePushEvent(BrazePushEvent pushEvent) {
//     Utils()
//         .showLog("Push Notification event of type: ${pushEvent.payloadType}");
//     Utils().showLog("Title: ${pushEvent.title}");
//     Utils().showLog("Deep link: ${pushEvent.url}");
//   }

//   void cancelSubscription() {
//     _pushEventsStreamSubscription?.cancel();
//     _inAppMessageStreamSubscription?.cancel();
//     Utils().showLog("Braze push notification listener canceled.");
//   }

//   void dispose() {
//     cancelSubscription();
//   }

//   Future<String?> _getUserLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return null;
//       }
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
//       );
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       geoCountryCode = place.isoCountryCode;
//       String address =
//           '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
//       Utils().showLog("Address:  $address  $geoCountryCode");
//       return address;
//     } catch (e) {
//       Utils().showLog('Error: $e');
//       return null;
//     }
//   }

//   Future saveFcmAPI({String? value, String? address}) async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String versionName = packageInfo.version;
//     String buildNumber = packageInfo.buildNumber;
//     bool granted = await Permission.notification.isGranted;

//     try {
//       Map request = {
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
//         "fcm_token": value ?? "",
//         "platform": Platform.operatingSystem,
//         "address": address ?? "",
//         "build_version": versionName,
//         "build_code": buildNumber,
//         "fcm_permission": "$granted",
//       };

//       ApiResponse response = await apiRequest(
//         url: Apis.saveFCM,
//         request: request,
//         showProgress: false,
//         showErrorOnFull: false,
//         checkAppUpdate: false,
//         removeForceLogin: true,
//       );

//       if (response.status) {
//         navigatorKey.currentContext!.read<HomeProvider>().setSheetText(
//               loginText: response.extra?.loginText,
//               signupText: response.extra?.signUpText,
//             );
//         Preference.saveFcmToken(value);
//         Preference.saveLocation(address);
//       } else {
//         //
//       }
//     } catch (e) {
//       Utils().showLog("Catch error $e");
//     }
//   }
// }
