import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:http/http.dart' as http;
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
  baseUrl = "https://financialmodelingprep.com/api/v3/",
  showProgress = false,
  Duration timeoutDuration = const Duration(seconds: 30),
}) async {
  Utils().showLog("URL  =  ${baseUrl + url}");
  Utils().showLog("REQUEST  =  ${jsonEncode(request)}");

  // Future.delayed(Duration.zero, () {
  //   if (showProgress) showGlobalProgressDialog();
  // });

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
    // Utils().showLog("RESPONSE  =  ${response.body}");
    if (response.statusCode == 200) {
      // if (showProgress) closeGlobalProgressDialog();
      final data = jsonDecode(response.body);
      if (data != null && data.isNotEmpty) {
        ApiResponse res = ApiResponse(status: true, data: data);
        return res;
      }
      return ApiResponse(
        status: false,
        message: Const.errSomethingWrong,
      );
      // } else if (response.statusCode == 429 || response.statusCode == 500) {
      //   Utils().showLog('Status Code Error ${response.statusCode}');
      //   if (showProgress) closeGlobalProgressDialog();
      // Timer(const Duration(milliseconds: 200), () {
      //   isServerError = true;
      //   Navigator.popUntil(
      //       navigatorKey.currentContext!, (route) => route.isFirst);
      //   Navigator.pushNamed(
      //       navigatorKey.currentContext!, ServerErrorWidget.path);
      // });
      //   return ApiResponse(
      //     status: false,
      //     message: Const.errSomethingWrong,
      //   );
    } else {
      Utils().showLog('Status Code Error ${response.statusCode}');
      // if (showProgress) closeGlobalProgressDialog();
      return ApiResponse(
        status: false,
        message: Const.errSomethingWrong,
      );
    }
  } on TimeoutException {
    Utils().showLog('Request Timed Out');
    // if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(
      status: false,
      message: Const.timedOut,
    );
  } on SocketException {
    Utils().showLog('Internet Error');
    // if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(
      status: false,
      message: Const.noInternet,
    );
  } catch (e) {
    Utils().showLog('Catch error => ${e.toString()}');
    Utils().showLog(e.toString());
    // if (showProgress) closeGlobalProgressDialog();
    return ApiResponse(
      status: false,
      message: Const.errSomethingWrong,
    );
  }
}
