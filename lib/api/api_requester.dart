import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/in_app_msg_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/in_app_messages.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

String? validAuthToken;

Map<String, String> getHeaders() {
  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': '1GLPFYDIPWQi3IPQsM34z5tJpDAcKaOD0Jrvs11F8JmY4J1fJi',
  };

  return headers;
}

Future<ApiResponse> apiRequest({
  RequestType type = RequestType.post,
  required String url,
  Map? request,
  callback,
  header,
  baseUrl = Apis.baseUrl,
  showProgress = true,
  optionalParent = false,
  Duration timeoutDuration = const Duration(seconds: 30),
}) async {
  log("URL  =  ${baseUrl + url}");
  log("HEADERS  =  ${getHeaders().toString()}");
  log("REQUEST  =  ${jsonEncode(request)}");
  Map<String, String> headers = getHeaders();
  if (header != null) {
    headers.addAll(header);
  }
  Future.delayed(
    Duration.zero,
    () {
      if (showProgress) {
        showGlobalProgressDialog(optionalParent: optionalParent);
      }
    },
  );
  try {
    late http.Response response;
    if (type == RequestType.post) {
      response = await http
          .post(
            Uri.parse(baseUrl + url),
            // body: request != null ? jsonEncode(request) : null,
            body: request,
            headers: headers,
          )
          .timeout(timeoutDuration);
    } else if (type == RequestType.get) {
      response = await http
          .get(
            Uri.parse(baseUrl + url),
            headers: headers,
          )
          .timeout(timeoutDuration);
    }
    log("RESPONSE  =  ${response.body}");
    if (response.statusCode == 200) {
      if (showProgress) closeGlobalProgressDialog();

      bool session = jsonDecode(response.body)['status'] == false &&
              jsonDecode(response.body)['message'] ==
                  "User with the provided token does not exist."
          ? false
          : true;
      if (!session) {
        // _showLogout();

        popUpAlert(
          canPop: false,
          message:
              "Someone else has logged into this account. Please log in again.",
          title: "Session Out",
          icon: Images.alertPopGIF,
          okText: "LOGOUT",
          onTap: _handleSessionOut,
        );
      }

      ApiResponse res = ApiResponse.fromJson(jsonDecode(response.body));

      // _checkForInAppMessage((res.extra as Extra).inAppMsg);

      // // if (false) {
      // if ((res.extra as Extra).inAppMsg != null) {
      //   // TODO: Need to apply everywhere
      //   InAppNotification? obj = (res.extra as Extra).inAppMsg;
      //   showAlert(
      //     title: obj?.title,
      //     description: obj?.description,
      //     image: obj?.image,
      //     onClick: () {},
      //   );
      // }

      return res;
    } else {
      log('Status Code Error ${response.statusCode}');
      if (showProgress) closeGlobalProgressDialog();
      return ApiResponse(
        status: false,
        message: Const.errSomethingWrong,
      );
    }
  } on TimeoutException {
    log('Request Timed Out');
    if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(
      status: false,
      message: Const.timedOut,
    );
  } on SocketException {
    log('Internet Error');
    if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(
      status: false,
      message: Const.noInternet,
    );
  } catch (e) {
    log('Catch error');
    log(e.toString());
    if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(
      status: false,
      message: Const.errSomethingWrong,
    );
  }
}

void _handleSessionOut() {
  // Handle session timeout, e.g., by calling logout() or refreshing tokens
  Preference.logout();
  // Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
  Navigator.pushNamedAndRemoveUntil(
    navigatorKey.currentContext!,
    Tabs.path,
    (route) => false,
  );
  navigatorKey.currentContext!.read<UserProvider>().clearUser();
}

void _checkForInAppMessage(InAppNotification? inAppMsg) {
  if (inAppMsg != null) {
    showAlert(
      title: inAppMsg.title,
      description: inAppMsg.description,
      image: inAppMsg.image,
      onClick: () {},
    );
  }
}
