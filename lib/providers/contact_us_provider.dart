import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class ContactUsProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future contactUS({
    required TextEditingController name,
    required TextEditingController email,
    required TextEditingController message,
  }) async {
    setStatus(Status.loading);
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "name": name.text,
      "email": email.text,
      "message": message.text,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.contactUs,
        request: request,
        showProgress: true,
        onRefresh: () {},
      );

      // showErrorMessage(
      //   message: response.message,
      //   type: response.status ? SnackbarType.info : SnackbarType.error,
      // );

      if (response.status) {
        // name.clear();
        // email.clear();
        message.clear();
        popUpAlert(
          message: response.message ?? "",
          title: "",
          onTap: () {
            Navigator.pop(navigatorKey.currentContext!);
            // Navigator.pop(navigatorKey.currentContext!);
          },
        );
      } else {
        popUpAlert(message: response.message ?? "", title: "Alert");
      }
      setStatus(Status.loaded);
      // return ApiResponse(status: response.status);
    } catch (e) {
      popUpAlert(message: Const.errSomethingWrong, title: "Alert");
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
