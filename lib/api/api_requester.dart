import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/in_app_msg_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/blogNew/blogsNew/index.dart';
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

import '../screens/stockDetail/index.dart';

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
  FormData? formData,
  callback,
  header,
  baseUrl = Apis.baseUrl,
  showProgress = false,
  optionalParent = false,
  Duration timeoutDuration = const Duration(seconds: 40),
  onRefresh,
  showErrorOnFull = true,
}) async {
  Map<String, String> headers = getHeaders();
  if (header != null) headers.addAll(header);

  String? fcmToken = fcmTokenGlobal;
  fcmToken ??= await Preference.getFcmToken();
  if (fcmToken != null) {
    Map<String, String> fcmHeaders = {"fcmToken": fcmToken};
    headers.addAll(fcmHeaders);
  }
  if (appVersion != null) {
    Map<String, String> versionHeader = {"appVersion": "$appVersion"};
    headers.addAll(versionHeader);
  }

  // *********** debug prints only **********
  Utils().showLog("URL  =  ${baseUrl + url}");
  Utils().showLog("HEADERS  =  ${headers.toString()}");
  if (formData != null) {
    Utils().showLog(
      "REQUEST  =  ${formData.fields.map((entry) => '${entry.key}: ${entry.value}').join(', ')}",
    );
  } else {
    Utils().showLog("REQUEST  =  ${jsonEncode(request)}");
  }
  // *********** debug prints only **********

  Future.delayed(Duration.zero, () {
    if (showProgress) {
      showGlobalProgressDialog(optionalParent: optionalParent);
    }
  });

  try {
    late http.Response response;
    if (formData != null) {
      var request = http.MultipartRequest("POST", Uri.parse(baseUrl + url));
      request.headers.addAll(headers);
      request.fields.addAll(Map.fromEntries(formData.fields));

      if (formData.files.isNotEmpty) {
        for (var file in formData.files) {
          request.files.add(await http.MultipartFile.fromPath(
              file.key, file.value as String));
        }
      }
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } else {
      response = await http
          .post(
            Uri.parse(baseUrl + url),
            body: request,
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
      if (res.extra is Extra && session) {
        InAppNotification? inAppMsg = (res.extra as Extra).inAppMsg;
        MaintenanceDialog? maintenanceDialog = (res.extra as Extra).maintenance;
        // MaintenanceDialog? maintenanceDialog = MaintenanceDialog(
        //     title: "App Under Maintenance",
        //     description:
        //         "Scheduled maintenance in progress.\nWe'll be back soon. Thanks for your support!");
        // TO show in app messages only, comment this if want to hide
        // OR
        // DO NOT REMOVE THIS
        if (maintenanceDialog != null && !isShowingError) {
          isShowingError = true;
          showMaintenanceDialog(
            title: maintenanceDialog.title,
            description: maintenanceDialog.description,
          );
        } else if (inAppMsg != null) {
          checkForInAppMessage(inAppMsg);
        }
      }

      return res;
    } else {
      Utils().showLog('Status Code Error ${response.statusCode}');
      if (showProgress) closeGlobalProgressDialog();
      if (!isShowingError && showErrorOnFull) {}
      return ApiResponse(
        status: false,
        message: Const.errSomethingWrong,
      );
    }
  } catch (e) {
    Utils().showLog('Catch error => ${e.toString()}');
    Utils().showLog(e.toString());
    if (showProgress) closeGlobalProgressDialog();
    if (!isShowingError && showErrorOnFull) {}
    return ApiResponse(
      status: false,
      message: Const.errSomethingWrong,
    );
  }
}

void _handleSessionOut() {
  // Handle session timeout, e.g., by calling logout() or refreshing tokens
  Preference.logout();
  Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
  Navigator.pushReplacement(
    navigatorKey.currentContext!,
    MaterialPageRoute(builder: (_) => const Tabs()),
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
    Utils().showLog("Navigating to Stocks");
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => StocksIndex(inAppMsgId: inAppMsg?.id),
      ),
    );
  } else if (inAppMsg?.redirectOn == 'stock_detail') {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => StockDetail(
          symbol: inAppMsg!.slug!,
          inAppMsgId: inAppMsg.id,
        ),
      ),
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
    Navigator.push(
      navigatorKey.currentContext!,
      // NewsDetails.path,
      MaterialPageRoute(
        builder: (_) => NewsDetails(
          inAppMsgId: inAppMsg?.id,
          slug: inAppMsg!.slug,
        ),
      ),
      // arguments: {"slug": inAppMsg?.slug, "inAppMsgId": inAppMsg?.id},
    );
  } else if (inAppMsg?.redirectOn == 'blog') {
    Utils().showLog("message");
    Navigator.pop(navigatorKey.currentContext!);
    Utils().showLog("message");

    Navigator.push(
      navigatorKey.currentContext!,
      // BlogIndexNew.path,
      MaterialPageRoute(
        builder: (_) => BlogIndexNew(inAppMsgId: inAppMsg?.id),
      ),
      // arguments: {"inAppMsgId": inAppMsg?.id},
    );
  } else if (inAppMsg?.redirectOn == 'blog_detail') {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.push(
      navigatorKey.currentContext!,
      // BlogDetail.path,
      MaterialPageRoute(
        builder: (_) => BlogDetail(
          slug: inAppMsg!.slug!,
          inAppMsgId: inAppMsg.id,
        ),
      ),
      // arguments: {"slug": inAppMsg?.slug, "inAppMsgId": inAppMsg?.id},
    );
  }
}

FormData mapToFormData(Map<String, dynamic>? map) {
  FormData formData = FormData();
  map?.forEach((key, value) {
    if (value is List) {
      for (var listItem in value) {
        formData.fields.add(MapEntry(key, listItem));
      }
    } else if (value is Map) {
      for (var entry in value.entries) {
        formData.fields.add(MapEntry('$key[${entry.key}]', entry.value));
      }
    } else {
      formData.fields.add(MapEntry(key, value));
    }
  });

  return formData;
}
