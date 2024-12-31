import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:braze_plugin/braze_plugin.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../utils/utils.dart';
import 'braze_service.dart';

class NotificationHandler {
  NotificationHandler._internal();

  static final NotificationHandler _instance = NotificationHandler._internal();

  static NotificationHandler get instance => _instance;

  static final BrazePlugin _braze = BrazePlugin(
    customConfigs: {replayCallbacksConfigKey: true},
    brazeSdkAuthenticationErrorHandler: (e) {
      Utils().showLog('authentication error : $e ');
    },
  );

  BrazePlugin get braze => _braze;

  static StreamSubscription? _pushSubscription;
  static StreamSubscription? _inAppSubscription;

  Future<void> initialize() async {
    try {
      _braze.enableSDK();

      setupNotificationListeners(isKilled: true);

      debugPrint('Braze notification system initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Braze: $e');
    }
  }

  void setupNotificationListeners({bool isKilled = false}) {
    _pushSubscription?.cancel();
    _pushSubscription =
        _braze.subscribeToPushNotificationEvents((BrazePushEvent event) {
      debugPrint('Notification event received: ${event.toString()}');

      _handleNotificationPayload(event, isKilled: isKilled);
    });

    _inAppSubscription = _braze.subscribeToInAppMessages(
      (BrazeInAppMessage event) {
        debugPrint('In App Message event received: $event');
        Utils().showLog('In App Message event received: $event');

        _braze.logInAppMessageClicked(event);
        _braze.logInAppMessageImpression(event);

        // for (var button in event.buttons) {
        //   _braze.logInAppMessageButtonClicked(event, button.id);
        // }
      },
    );
  }

  void _handleNotificationPayload(BrazePushEvent event,
      {bool isKilled = false}) {
    if (event.payloadType == 'push_opened') {
      try {
        final Map<String, dynamic> notificationData =
            jsonDecode(event.pushEventJsonString);
        String? type;
        String? slug;
        if (Platform.isIOS) {
          type = notificationData['ios']['raw_payload']['type'];
          slug = notificationData['ios']['raw_payload']['slug'];
        } else {
          type = event.brazeProperties['type'];
          slug = event.brazeProperties['slug'];
        }

        debugPrint('braze listener =>  type $type, slug $slug');

        if (type != null && slug != null) {
          popHome = true;
          BrazeNotificationService.instance.navigateToRequiredScreen(
            type: type,
            slug: slug,
            whenAppKilled: isKilled,
          );
        } else {
          Utils().showLog(
              'Required fields "type" or "slug" not found in notification payload.');
        }
      } catch (e) {
        Utils().showLog('Error parsing notification JSON: $e');
      }
    }
  }

  void dispose() {
    _pushSubscription?.cancel();
    _inAppSubscription?.cancel();
  }
}
