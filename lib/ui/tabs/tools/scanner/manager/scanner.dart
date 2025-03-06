import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import '../../../../../api/apis.dart';
import '../../../../../utils/constants.dart';
import '../models/scanner_port.dart';

class ScannerManager extends ChangeNotifier {
  ScannerPortsRes? _port;
  ScannerPortsRes? get port => _port;
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getScannerPorts({bool showProgress = false, reset = false}) async {
    if (reset) _port = null;
    setStatus(Status.loading);

    try {
      Map request = {
        // 'token':
        //     navigatorKey.currentContext!.read<UserManager>().user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
          baseUrl: 'https://app.stocks.news/api/v1',
          url: Apis.stockScannerPort,
          showProgress: showProgress,
          request: request);

      if (response.status) {
        _port = scannerPortsResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _port = null;
        _error = response.message;
      }

      return ApiResponse(
        status: response.status,
        data: _port,
      );
    } catch (e) {
      _port = null;
      _error = Const.errSomethingWrong;
      return ApiResponse(status: false);
    } finally {
      setStatus(Status.loaded);
    }
  }
}
