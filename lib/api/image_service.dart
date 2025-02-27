import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

import 'package:stocks_news_new/utils/utils.dart';

var options = BaseOptions(
  baseUrl: Apis.baseUrl,
  connectTimeout: const Duration(milliseconds: 20000),
  receiveTimeout: const Duration(milliseconds: 20000),
);

Dio dio = Dio(options);

void initDio() {
  dio.interceptors
    ..add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
      ),
    )
    ..add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
    ));
}

Future requestUploadImage({
  required String url,
  required FormData request,
  Map<String, dynamic>? header,
  baseUrl = Apis.baseUrl,
}) async {
  showGlobalProgressDialog();
  try {
    Utils().showLog("URL  =  $baseUrl$url");
    Utils().showLog("HEADERS  =  ${getHeaders().toString()}");
    try {
      Utils().showLog("REQUEST  =  ${jsonEncode(request)}");
    } catch (e) {
      // Utils().showLog("Error in showing request");
      //
    }
    Map<String, dynamic> headers = getHeaders();

    if (header != null) headers.addAll(header);
    dio.options.headers = headers;
    Response response = await dio.post((baseUrl + url),
        data: request, options: Options(headers: headers));
    closeGlobalProgressDialog();
    // showErrorMessage(
    //     message: response.data["message"], type: SnackbarType.info);
    return ApiResponse(
      status: true,
      data: response.data["data"]["image"],
      message: response.data["message"],
    );
  } on DioException catch (e) {
    Utils().showLog("dio e $e");
    closeGlobalProgressDialog();
    // throw ExceptionMessage(e.message ?? Const.errSomethingWrong);
    // showErrorMessage(message: Const.errSomethingWrong);

    return ApiResponse(status: false, message: Const.errSomethingWrong);
  } catch (e) {
    Utils().showLog("catch e$e");
    closeGlobalProgressDialog();
    return ApiResponse(status: false, message: Const.errSomethingWrong);
  }
}

Future testCompressAndGetFile(File file) async {
  Uint8List? result = await FlutterImageCompress.compressWithFile(
    file.path,
    quality: 50,
    format: CompressFormat.jpeg,
  );
  return result;
}
