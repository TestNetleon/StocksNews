import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../routes/my_app.dart';
import '../utils/utils.dart';
import 'user_provider.dart';

class AdProvider extends ChangeNotifier {
  Future callAPI({String? id, bool view = true}) async {
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "ad_id": id ?? "",
      };

      ApiResponse response = await apiRequest(
        url: view ? Apis.adViewed : Apis.adClicked,
        request: request,
        showProgress: false,
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
