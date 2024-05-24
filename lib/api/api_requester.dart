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
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/screens/errorScreens/server_error.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/stocks/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

import 'package:stocks_news_new/utils/in_app_messages.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
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
  showProgress = false,
  optionalParent = false,
  Duration timeoutDuration = const Duration(seconds: 40),
}) async {
  Map<String, String> headers = getHeaders();
  if (header != null) {
    headers.addAll(header);
  }
  String? fcmToken = await Preference.getFcmToken();
  if (fcmToken != null) {
    Map<String, String> fcmHeaders = {"fcmToken": fcmToken};
    headers.addAll(fcmHeaders);
  }

  Utils().showLog("URL  =  ${baseUrl + url}");
  Utils().showLog("HEADERS  =  ${headers.toString()}");
  Utils().showLog("REQUEST  =  ${jsonEncode(request)}");

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
    Utils().showLog("RESPONSE  =  ${response.body}");
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

      // TO show in app messages only, comment this if want to hide
      if (res.extra is Extra) {
        InAppNotification? inAppMsg = (res.extra as Extra).inAppMsg;
        checkForInAppMessage(inAppMsg);
      }

      return res;
    } else if (response.statusCode == 429 || response.statusCode == 500) {
      Utils().showLog('Status Code Error ${response.statusCode}');
      if (showProgress) closeGlobalProgressDialog();
      // Timer(const Duration(milliseconds: 200), () {
      //   Navigator.popUntil(
      //       navigatorKey.currentContext!, (route) => route.isFirst);
      //   Navigator.pushNamed(
      //       navigatorKey.currentContext!, ServerErrorWidget.path);
      // });
      return ApiResponse(
        status: false,
        message: Const.errSomethingWrong,
      );
    } else {
      Utils().showLog('Status Code Error ${response.statusCode}');
      if (showProgress) closeGlobalProgressDialog();
      return ApiResponse(
        status: false,
        message: Const.errSomethingWrong,
      );
    }
  } on TimeoutException {
    Utils().showLog('Request Timed Out');
    if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(
      status: false,
      message: Const.timedOut,
    );
  } on SocketException {
    Utils().showLog('Internet Error');
    if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(
      status: false,
      message: Const.noInternet,
    );
  } catch (e) {
    Utils().showLog('Catch error => ${e.toString()}');
    Utils().showLog(e.toString());
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

void checkForInAppMessage(InAppNotification? inAppMsg) {
  if (inAppMsg == null) return;
  Utils().showLog("in Message ");
  if (inAppMsg.popupType == InAppMsgType.card.name) {
    Utils().showLog("Type Card ");
    showInAppCard(
      title: inAppMsg.title,
      description: inAppMsg.description,
      image: inAppMsg.image,
      onClick: () => navigateToRequiredScreen(inAppMsg),
    );
  } else if (inAppMsg.popupType == InAppMsgType.modal.name) {
    showInAppModal(
      title: inAppMsg.title,
      description: inAppMsg.description,
      image: inAppMsg.image,
      onClick: () => navigateToRequiredScreen(inAppMsg),
    );
  } else if (inAppMsg.popupType == InAppMsgType.image_only.name) {
    showInAppImageOnly(
      image: inAppMsg.image,
      onClick: () => navigateToRequiredScreen(inAppMsg),
    );
  } else if (inAppMsg.popupType == InAppMsgType.top_banner.name) {
    showInAppTopBanner(
      title: inAppMsg.title,
      description: inAppMsg.description,
      image: inAppMsg.image,
      onClick: () => navigateToRequiredScreen(inAppMsg),
    );
  }
}

void navigateToRequiredScreen(InAppNotification? inAppMsg) {
  log("Clicked");
  if (inAppMsg?.redirectOn == "none" || inAppMsg?.redirectOn == null) {
    Navigator.pop(navigatorKey.currentContext!);
    return;
  }

  if (inAppMsg?.redirectOn == 'home') {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => Tabs(
          index: 0,
          inAppMsgId: inAppMsg?.id,
        ),
      ),
    );
  } else if (inAppMsg?.redirectOn == 'stock') {
    log("Navigating to Stocks");
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      StocksIndex.path,
      arguments: inAppMsg?.id,
    );
  } else if (inAppMsg?.redirectOn == 'stock_detail') {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      StockDetails.path,
      arguments: {"slug": inAppMsg?.slug, "inAppMsgId": inAppMsg?.id},
    );
  } else if (inAppMsg?.redirectOn == 'news') {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => Tabs(
          index: 4,
          inAppMsgId: inAppMsg?.id,
        ),
      ),
    );
  } else if (inAppMsg?.redirectOn == 'news_detail') {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      NewsDetails.path,
      arguments: {"slug": inAppMsg?.slug, "inAppMsgId": inAppMsg?.id},
    );
  } else if (inAppMsg?.redirectOn == 'blog') {
    log("message");
    Navigator.pop(navigatorKey.currentContext!);
    log("message");
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      Blog.path,
      arguments: {"type": BlogsType.blog, "id": "", "inAppMsgId": inAppMsg?.id},
    );
  } else if (inAppMsg?.redirectOn == 'blog_detail') {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      BlogDetail.path,
      arguments: {"slug": inAppMsg?.slug, "inAppMsgId": inAppMsg?.id},
    );
  }
}
