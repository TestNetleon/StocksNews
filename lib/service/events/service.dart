import 'package:firebase_analytics/firebase_analytics.dart';
import '../../utils/utils.dart';

class EventsService {
  EventsService._internal();
  static final EventsService _instance = EventsService._internal();
  static EventsService get instance => _instance;

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


///Events
///allow_notifications
///dont_allow_notifications
///allow_once_to_use_your_location
///allow_while_using_app_to_use_your_location
///dont_allow_to_use_your_location
///click_skip_onboarding_page
///click_try_premium_7days_for_free_onboarding_page
///ask_app_not_to_track_track_activity_across_other_companies
///allow_track_activity_across_other_companies
///close_welcome_page
///select_country_welcome_page
///enter_phone_number_welcome_page
///check_box_welcome_page
///read_more_welcome_page
///click_continue_welcome_page
///continue_with_google_welcome_page
///continue_with_apple_welcome_page
///enter_code_otp_verification
///resend_code_otp_verification
///close_select_plan_page
///select_monthly_basic_plan_select_plan_page
///select_yearly_basic_plan_select_plan_page
///unlock_basic_plan_basic_plan_select_plan_page
///montly_basic_plan_clicked
///montly_basic_plan_received
///montly_basic_plan_clicked : to know if user click to buy
///montly_basic_plan_received: to know if you received the transition
///monthly_basic_plan_clicked
///annual_basic_plan_received
///select_monthly_pro_plan_select_plan_page
///select_yearly_pro_plan_select_plan_page
///unlock_pro_plan_pro_plan_select_plan_page
///montly_pro_plan_clicked
///montly_pro_plan_received
///montly_pro_plan_clicked : to know if user click to buy
///montly_pro_plan_received: to know if you received the transition
///monthly_pro_plan_clicked
///annual_pro_plan_received