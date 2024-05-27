import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/in_app_msg_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
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
  RequestType type = RequestType.get,
  required String url,
  Map? request,
  header,
  baseUrl = "https://financialmodelingprep.com/api/v3/historical-chart/",
  showProgress = false,
  Duration timeoutDuration = const Duration(seconds: 30),
}) async {
  Utils().showLog("URL  =  ${baseUrl + url}");
  Utils().showLog("REQUEST  =  ${jsonEncode(request)}");

  Future.delayed(Duration.zero, () {
    if (showProgress) showGlobalProgressDialog();
  });

  try {
    late http.Response response;
    if (type == RequestType.post) {
      response = await http
          .post(Uri.parse(baseUrl + url), body: request)
          .timeout(timeoutDuration);
    } else if (type == RequestType.get) {
      response =
          await http.get(Uri.parse(baseUrl + url)).timeout(timeoutDuration);
    }
    Utils().showLog("RESPONSE  =  ${response.body}");
    if (response.statusCode == 200) {
      if (showProgress) closeGlobalProgressDialog();
      final data = jsonDecode(response.body);
      if (data != null && data.isNotEmpty) {
        ApiResponse res = ApiResponse(status: true, data: data);
        return res;
      }
      return ApiResponse(
        status: false,
        message: Const.errSomethingWrong,
      );
    } else if (response.statusCode == 429 || response.statusCode == 500) {
      Utils().showLog('Status Code Error ${response.statusCode}');
      if (showProgress) closeGlobalProgressDialog();
      // Timer(const Duration(milliseconds: 200), () {
      //   isServerError = true;
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
