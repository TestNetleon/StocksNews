import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class QRcodePRovider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;
  final FocusNode searchFocusNode = FocusNode();

  Extra? _extra;
  Extra? get extra => _extra;

//
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getQRdata({required String qrCode}) async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "qr_token": qrCode,
      };
      ApiResponse response = await apiRequest(
        url: Apis.qrCodeScan,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {}
      Navigator.pop(navigatorKey.currentContext!);
      // showErrorMessage(
      //     message: response.message,
      //     type: response.status ? SnackbarType.info : SnackbarType.error);
      setStatus(Status.ideal);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.ideal);
    }
  }
}
