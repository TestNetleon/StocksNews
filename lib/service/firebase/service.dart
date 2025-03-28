import 'package:firebase_analytics/firebase_analytics.dart';
import '../../utils/utils.dart';

class FirebaseService {
  FirebaseService._internal();
  static final FirebaseService _instance = FirebaseService._internal();
  static FirebaseService get instance => _instance;

  void firebaseLogEvent(
    String eventName, {
    Map<String, dynamic>? eventProperties,
    String? userId,
  }) {
    try {
      final formattedProperties =
          eventProperties?.map((key, value) => MapEntry(key, value as Object));

      FirebaseAnalytics.instance.logEvent(
        name: eventName,
        parameters: formattedProperties,
      );
      Utils().showLog('Logging event: Firebase $eventName');
    } catch (e) {
      Utils().showLog('Error while logging event: $e');
    }
  }
}
