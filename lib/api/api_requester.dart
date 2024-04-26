import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_alert_dialog.dart';

String? validAuthToken;

Map<String, String> getHeaders() {
  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': '1GLPFYDIPWQi3IPQsM34z5tJpDAcKaOD0Jrvs11F8JmY4J1fJi',
  };

  return headers;
}

// Future apiRequest({
//   RequestType type = RequestType.post,
//   required String url,
//   Map? request,
//   callback,
//   header,
//   baseUrl = Apis.baseUrl,
//   showProgress = true,
// }) async {
//   Utils().showLog("URL  =  $baseUrl$url");
//   Utils().showLog("HEADERS  =  ${getHeaders().toString()}");
//   try {
//     Utils().showLog("REQUEST  =  ${jsonEncode(request)}");
//   } catch (e) {
//     // log("Error in showing request");
//     //
//   }

//   // UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
//   // if (request != null && user != null && user.token != null) {
//   //   request["token"] = user.token;
//   // }

//   Map<String, String> headers = getHeaders();
//   if (header != null) {
//     headers.addAll(header);
//   }

//   Future.delayed(Duration.zero, () {
//     if (showProgress) showGlobalProgressDialog();
//   });

//   try {
//     late http.Response response;
//     if (type == RequestType.post) {
//       response = await http.post(
//         Uri.parse(baseUrl + url),
//         // body: request != null ? jsonEncode(request) : null,
//         body: request,
//         headers: headers,
//       );
//     } else if (type == RequestType.get) {
//       response = await http.get(
//         Uri.parse(baseUrl + url),
//         headers: headers,
//       );
//     }
//     Utils().showLog("RESPONSE  =  ${response.body}");
//     if (jsonDecode(response.body)['data'] != null) {
//       if (jsonDecode(response.body)['data'] is! List &&
//           jsonDecode(response.body)['data']["login_status"] != null &&
//           jsonDecode(response.body)['data']["login_status"] == false) {
//         log("ENTERED HERE");
//         showSessionOutDialog(
//           jsonDecode(response.body)['message'],
//           () => {
//             if (true) showGlobalProgressDialog(),
//             Future.delayed(const Duration(seconds: 1), () {
//               if (true) closeGlobalProgressDialog();
//               _handleSessionOut();
//             })
//           },
//         );
//       } else if (response.statusCode == 200) {
//         if (showProgress) closeGlobalProgressDialog();
//         bool session = jsonDecode(response.body)['status'] == false &&
//                 jsonDecode(response.body)['message'] ==
//                     "User with the provided token does not exist."
//             ? false
//             : true;

//         log("SESSION $session");
//         if (!session) {
//           _showLogout();
//         }
//         return ApiResponse.fromJson(jsonDecode(response.body));
//       } else {
//         if (showProgress) closeGlobalProgressDialog();
//         bool session = jsonDecode(response.body)['status'] == false &&
//                 jsonDecode(response.body)['message'] ==
//                     "User with the provided token does not exist."
//             ? false
//             : true;

//         log("SESSION $session");
//         // if (!session) {
//         //   _showLogout();
//         // }

//         return ApiResponse(
//           status: false,
//           message: session
//               ? jsonDecode(response.body)['error'] ?? Const.errSomethingWrong
//               : Const.errSomethingWrong,
//           session: session,
//         );
//       }
//     } else if (response.statusCode == 200) {
//       if (showProgress) closeGlobalProgressDialog();
//       bool session = jsonDecode(response.body)['status'] == false &&
//               jsonDecode(response.body)['message'] ==
//                   "User with the provided token does not exist."
//           ? false
//           : true;
//       // if (session) {
//       //   _refreshToken();
//       // }

//       log("SESSION $session");
//       return ApiResponse.fromJson(jsonDecode(response.body));
//     } else {
//       if (showProgress) closeGlobalProgressDialog();
//       bool session = jsonDecode(response.body)['status'] == false &&
//               jsonDecode(response.body)['message'] ==
//                   "User with the provided token does not exist."
//           ? false
//           : true;

//       log("SESSION $session");
//       // if (!session) {
//       //   _showLogout();
//       // }
//       return ApiResponse(
//         status: false,
//         message: session
//             ? jsonDecode(response.body)['error'] ?? Const.errSomethingWrong
//             : Const.errSomethingWrong,
//         session: session,
//       );
//     }
//   } on SocketException {
//     // Internet error
//     if (showProgress) closeGlobalProgressDialog();
//     return ApiResponse(status: false, message: Const.noInternet);
//   } catch (e) {
//     // Unexpected Error
//     Utils().showLog(e.toString());
//     if (showProgress) closeGlobalProgressDialog();
//     return ApiResponse(status: false, message: Const.errSomethingWrong);
//   }
// }

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
  Future.delayed(Duration.zero, () {
    if (showProgress) {
      showGlobalProgressDialog(optionalParent: optionalParent);
    }
  });
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
        _showLogout();
      }

      return ApiResponse.fromJson(jsonDecode(response.body));
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

Future<dynamic> _showLogout() => showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => PopScope(
        canPop: false,
        child: ThemeAlertDialog(
          contentPadding: EdgeInsets.fromLTRB(18.sp, 16.sp, 10.sp, 10.sp),
          children: [
            Text(
              "Session Out",
              style: stylePTSansBold(fontSize: 19),
            ),
            const SpacerVerticel(height: 10),
            Text(
              "Someone else has logged into this account. Please log in again.",
              style: stylePTSansRegular(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _handleSessionOut,
                child: Text(
                  "LOGOUT",
                  style: stylePTSansRegular(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
