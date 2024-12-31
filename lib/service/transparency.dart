import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';

Future requestATT() async {
  if (!Platform.isIOS) return;
  // Request the ATT permission
  try {
    final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();

    // Handle the status
    switch (status) {
      case TrackingStatus.authorized:
        print('User granted permission to track.');
        break;
      case TrackingStatus.denied:
        print('User denied permission to track.');
        break;
      case TrackingStatus.notDetermined:
        print('User has not made a decision.');
        break;
      case TrackingStatus.restricted:
        print('Tracking is restricted.');
        break;
      case TrackingStatus.notSupported:
        print('Tracking is notSupported.');
        throw UnimplementedError();
    }
  } catch (e) {
    print('Error $e');
  }
}
