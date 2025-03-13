import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';

class AdManager extends ChangeNotifier {
  Future callAPI({String? id, bool view = true}) async {
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "ad_id": id ?? "",
      };

      ApiResponse response = await apiRequest(
        url: view ? Apis.adViewed : Apis.adClicked,
        request: request,
        showProgress: false,
        showErrorOnFull: false,
        checkAppUpdate: false,
        removeForceLogin: true,
      );
      if (response.status) {
        //
      } else {
        //
      }
      notifyListeners();

      ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      ApiResponse(status: false);
    }
  }
}
