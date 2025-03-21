import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/maintenance/box.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/in_app_msg_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/more/articles/detail.dart';
import 'package:stocks_news_new/ui/tabs/more/articles/index.dart';
import 'package:stocks_news_new/ui/tabs/more/news/detail.dart';

import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/in_app_messages.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import '../ui/AdManager/item.dart';
import '../ui/tabs/tabs.dart';

String? validAuthToken;

Map<String, String> getHeaders() {
  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': '1GLPFYDIPWQi3IPQsM34z5tJpDAcKaOD0Jrvs11F8JmY4J1fJi',
  };
  return headers;
}

Future<ConnectivityResult> _isConnected() async {
  try {
    List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();
    return connectivityResults.first;
  } catch (e) {
    return ConnectivityResult.none;
  }
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
  checkAppUpdate = true,
  removeForceLogin = false,
  updateDatabase = true,
  Future Function()? onAddClick,
  Future Function()? callAgain,
}) async {
  // ConnectivityResult type = await _isConnected();
  // if (type == ConnectivityResult.none) {
  //   popUpAlert();
  //   return ApiResponse(status: false, message: Const.noInternet);
  // }

  Map<String, String> headers = getHeaders();
  if (header != null) headers.addAll(header);
  String? fcmToken = fcmTokenGlobal;
  fcmToken ??= await Preference.getFcmToken();

  if (fcmToken != null) {
    Map<String, String> fcmHeaders = {"fcmToken": fcmToken};
    headers.addAll(fcmHeaders);
  }

  if (appVersion != null) {
    Map<String, String> versionHeader = {
      "appVersion": "$appVersion",
      "platform": Platform.operatingSystem,
    };
    headers.addAll(versionHeader);
  }

  // *********** debug prints only **********
  Utils().showLog("URL  =  ${baseUrl + url}");
  Utils().showLog("HEADERS  =  ${headers.toString()}");

  if (request != null) {
    request["token"] =
        navigatorKey.currentContext!.read<UserManager>().user?.token ?? "";
  }

  if (formData != null) {
    Utils().showLog(
      "REQUEST $url  =  ${formData.fields.map((entry) => '${entry.key}: ${entry.value}').join(', ')}",
    );
  } else {
    Utils().showLog("REQUEST  =  ${jsonEncode(request)}");
  }

  // *********** debug prints only **********
  // Future.delayed(Duration.zero, () {
  if (showProgress) {
    showGlobalProgressDialog(optionalParent: optionalParent);
  }
  // });

  try {
    late http.Response response;
    if (formData != null) {
      var request = http.MultipartRequest("POST", Uri.parse(baseUrl + url));
      request.headers.addAll(headers);
      request.fields.addAll(Map.fromEntries(formData.fields));

      // Add files
      for (var file in formData.files) {
        if (file.value is String) {
          request.files.add(
            await http.MultipartFile.fromPath(file.key, file.value as String),
          );
        } else if (file.value is List<int>) {
          request.files.add(
            http.MultipartFile.fromBytes(file.key, file.value as List<int>),
          );
        }
      }
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } else {
      if (type == RequestType.post) {
        response = await http
            .post(Uri.parse(baseUrl + url), body: request, headers: headers)
            .timeout(timeoutDuration);
      } else {
        response = await http
            .get(Uri.parse(baseUrl + url), headers: headers)
            .timeout(timeoutDuration);
      }
    }

    Utils().showLog("RESPONSE  =  ${response.body}");
    ApiResponse res = ApiResponse.fromJson(jsonDecode(response.body));

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

      if (res.extra is Extra && session) {
        InAppNotification? inAppMsg = (res.extra as Extra).inAppMsg;
        MaintenanceDialog? maintenanceDialog = (res.extra as Extra).maintenance;
        MaintenanceDialog? maintenanceDialogNew;

        if (url == Apis.checkServer) {
          if (res.data is! List && !res.status) {
            maintenanceDialogNew = MaintenanceDialog.fromJson(res.data);
          } else {
            // print('set empty maintenanceDialog data');
          }
        }

        AdManagersRes? adManagerRes = (res.extra as Extra).adManagers;
        if (adManagerRes != null && adManagerRes.popUp != null) {
          addOnSheetManagers(popUp: adManagerRes.popUp);
        }

        // AdManagerRes? adManagerRes = (res.extra as Extra).adManager;

        // if (adManagerRes != null &&
        //     (adManagerRes.popUpImage != null &&
        //         adManagerRes.popUpImage != '')) {
        //   addOnSheet(
        //     adManager: adManagerRes,
        //     onTap: onAddClick,
        //   );
        // }

        if (checkAppUpdate) {
          _checkForNewVersion(
            res.extra,
            removeForceLogin: removeForceLogin,
          );
        }
        // TO show in app messages only, comment this if want to hide
        // OR
        // DO NOT REMOVE THIS

        if ((maintenanceDialog != null || maintenanceDialogNew != null) &&
            !isShowingError &&
            showErrorOnFull) {
          isShowingError = true;
          //TODO: show maintenance
          showMaintenanceDialog(
            title: maintenanceDialog?.title ?? maintenanceDialogNew?.title,
            description: maintenanceDialog?.description ??
                maintenanceDialogNew?.description,
          );
        } else if (inAppMsg != null) {
          checkForInAppMessage(inAppMsg);
        }
      }

      return res;
    } else {
      if (showProgress) closeGlobalProgressDialog();

      bool isUnderMaintenance = false;
      if (!callCheckServer) {
        callCheckServer = true;
        isUnderMaintenance = false;
      }
      Utils().showLog("is UnderMaintenance $isUnderMaintenance");
      if (isUnderMaintenance) {
        MaintenanceDialog? maintenanceDialog;

        if (url == Apis.checkServer) {
          if (res.data is! List && !res.status) {
            maintenanceDialog = MaintenanceDialog.fromJson(res.data);
          } else {
            // print('Data is a list, not a MaintenanceDialog');
          }
        }
        if (maintenanceDialog != null && !isShowingError && showErrorOnFull) {
          isShowingError = true;
          //TODO: show maintenance
          showMaintenanceDialog(
            title: maintenanceDialog.title,
            description: maintenanceDialog.description,
          );
        }
      }

      Utils().showLog('Status Code Error ${response.statusCode}');

      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  } catch (e) {
    if (callAgain != null) {
      callAgain();
    }

    if (!callCheckServer) {
      callCheckServer = true;
      //
    }

    Utils().showLog('Catch error =>> ${e.toString()}  \n ERROR ON => $url');
    if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(status: false, message: Const.errSomethingWrong);
  }
}

void _checkForNewVersion(Extra extra, {removeForceLogin = false}) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String buildCode = packageInfo.buildNumber;
  if ((Platform.isAndroid &&
          (extra.androidBuildCode ?? 0) > int.parse(buildCode)) &&
      !isAppUpdating) {
    isAppUpdating = true;
    //app update
  } else if ((Platform.isIOS &&
          (extra.iOSBuildCode ?? 0) > int.parse(buildCode)) &&
      !isAppUpdating) {
    isAppUpdating = true;
    //app update
  }
}

void _handleSessionOut() {
  navigatorKey.currentContext!.read<UserManager>().clearUser();
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
  } else if (inAppMsg?.redirectOn == 'stock_detail') {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => SDIndex(
          symbol: inAppMsg?.slug ?? '',
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
      MaterialPageRoute(
        builder: (_) => NewsDetailIndex(
          slug: inAppMsg?.slug ?? '',
        ),
      ),
    );
  } else if (inAppMsg?.redirectOn == 'blog') {
    Utils().showLog("message");
    Navigator.pop(navigatorKey.currentContext!);
    Utils().showLog("message");

    Navigator.push(
      navigatorKey.currentContext!,
      // BlogIndexNew.path,
      MaterialPageRoute(
        builder: (_) => BlogsIndex(),
      ),
      // arguments: {"inAppMsgId": inAppMsg?.id},
    );
  } else if (inAppMsg?.redirectOn == 'blog_detail') {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.push(
      navigatorKey.currentContext!,
      // BlogDetail.path,
      MaterialPageRoute(
        builder: (_) => BlogsDetailIndex(
          slug: inAppMsg?.slug ?? '',
        ),
      ),
      // arguments: {"slug": inAppMsg?.slug, "inAppMsgId": inAppMsg?.id},
    );
  } else if (inAppMsg?.redirectOn == 'membership') {
    Navigator.pop(navigatorKey.currentContext!);
    //
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
