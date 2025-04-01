import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/service/events/service.dart';

Future requestATT() async {
  if (!Platform.isIOS) return;
  // Request the ATT permission
  try {
    final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();

    // Handle the status
    switch (status) {
      case TrackingStatus.authorized:
        if (kDebugMode) {
          print('User granted permission to track.');
        }
        EventsService.instance.onATTpermissionAllow();
        break;
      case TrackingStatus.denied:
        if (kDebugMode) {
          print('User denied permission to track.');
        }
        EventsService.instance.onATTpermissionDontAllow();
        break;
      case TrackingStatus.notDetermined:
        if (kDebugMode) {
          print('User has not made a decision.');
        }
        break;
      case TrackingStatus.restricted:
        if (kDebugMode) {
          print('Tracking is restricted.');
        }
        break;
      case TrackingStatus.notSupported:
        if (kDebugMode) {
          print('Tracking is notSupported.');
        }
        throw UnimplementedError();
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error $e');
    }
  }
}
