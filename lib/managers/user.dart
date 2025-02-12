import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/account/login.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../database/preference.dart';
import '../fcm/dynamic_links.service.dart';
import '../service/amplitude/service.dart';
import '../service/braze/service.dart';
import '../service/revenue_cat.dart';
import '../utils/constants.dart';
import '../widgets/custom/alert_popup.dart';

class UserManager extends ChangeNotifier {
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  Extra? _extra;
  Extra? get extra => _extra;

  UserRes? _user;
  UserRes? get user => _user;

  askLoginScreen() async {
    await Navigator.push(
      navigatorKey.currentContext!,
      createRoute(
        AccountLoginIndex(),
      ),
    );
  }

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future verifyAccount({Map? extraRequest}) async {
    closeKeyboard();
    setStatus(Status.loading);

    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      String? referralCode = await Preference.getReferral();

      Map request = {
        "platform": Platform.operatingSystem,
        "build_version": versionName,
        "build_code": buildNumber,
      };

      if (memCODE != null && memCODE != '') {
        request['distributor_code'] = memCODE;
      }

      if (referralCode != null && referralCode != '') {
        request['referral_code'] = referralCode;
      }

      if (address != null && address != '') {
        request['address'] = address;
      }

      if (fcmToken != null && fcmToken != '') {
        request['fcm_token'] = fcmToken;
      }

      if (extraRequest != null) {
        request.addAll(extraRequest);
      }

      ApiResponse response = await apiRequest(
        url: Apis.phoneLogin,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        BrazeService.brazeUserEvent();
        if (_user?.signupStatus == true) {
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, Tabs.path);
        } else {
          Utils().showLog('popping back');
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.pop(navigatorKey.currentContext!);
        }

        isSVG = isSvgFromUrl(_user?.image);
        Utils().showLog('IS SVG $isSVG');
        shareUri = await DynamicLinkService.instance.getDynamicLink();

        if ((_user?.membership?.purchased != 1) && withLoginMembership) {
          if (kDebugMode) {
            print('Calling membership page');
          }
          subscribe();
        }

        _extra = (response.extra is Extra ? response.extra as Extra : null);

        if (_user?.signupStatus != null) {
          AmplitudeService.logLoginSignUpEvent(
            isRegistered: (_user?.signupStatus ?? false) ? 1 : 0,
          );
        }
      } else {
        popUpAlert(
          message: "${response.message}",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
      return ApiResponse(status: false);
    }
  }
}
