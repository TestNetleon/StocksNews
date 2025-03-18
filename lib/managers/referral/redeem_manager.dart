import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/referral/redeem_list_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/animation/coin.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class RedeemManager extends ChangeNotifier {
  RedeemListRes? _data;
  RedeemListRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData() async {
    try {
      _error = null;
      setStatus(Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.redeemList,
        request: {},
      );
      if (response.status) {
        _data = redeemListResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog("Error => $e");
      _data = null;
      _error = Const.errSomethingWrong;
      setStatus(Status.loaded);
    }
  }

  Future requestClaimReward({type = ""}) async {
    try {
      // setStatus(Status.loading);

      // ApiResponse response = await apiRequest(
      //   url: Apis.pointClaim,
      //   request: {"type": type},
      // );

      // if (response.status) {
      showDialog(
        barrierDismissible: false,
        barrierColor: ThemeColors.background.withValues(alpha: 0.6),
        useSafeArea: true,
        context: navigatorKey.currentContext!,
        builder: (context) {
          return CoinAnimationWidget(
            data: CongoClaimRes(
              points: 0,
              subtitle: "response.message",
            ),
          );
        },
      );
      getData();
      // } else {
      //   TopSnackbar.show(
      //     message: response.message ?? '',
      //     type: response.status ? ToasterEnum.success : ToasterEnum.error,
      //   );
      // }
      // setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog("Error => $e");
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatus(Status.loaded);
    }
  }
}
