import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/blogs.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/managers/news.dart';
import 'package:stocks_news_new/managers/search.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/account/login.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../database/preference.dart';
import '../fcm/dynamic_links.service.dart';
import '../service/amplitude/service.dart';
import '../service/braze/service.dart';
import '../utils/constants.dart';

class UserManager extends ChangeNotifier {
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  // Extra? _extra;
  // Extra? get extra => _extra;

  UserRes? _user;
  UserRes? get user => _user;

  Future setUser(UserRes? user) async {
    if (user == null) return;
    _user = user;
    Preference.saveUser(_user);
    notifyListeners();
  }

  askLoginScreen() async {
    if (_user != null) {
      return;
    } else {
      await Navigator.push(
        navigatorKey.currentContext!,
        createRoute(
          AccountLoginIndex(),
        ),
      );
    }
  }

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

//MARK: Phone Login
  Future verifyAccount({Map? extraRequest}) async {
    try {
      ApiResponse response = await _saveData(
        url: Apis.phoneLogin,
        extraRequest: extraRequest,
      );
      if (response.status) {
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
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      return ApiResponse(status: false);
    }
  }

//MARK: Google Login
  Future googleVerification({Map? extraRequest}) async {
    try {
      ApiResponse response = await _saveData(
        url: Apis.googleLogin,
        extraRequest: extraRequest,
      );
      if (response.status) {
        if (_user?.signupStatus == true) {
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, Tabs.path);
        } else {
          Utils().showLog('popping back');
          Navigator.pop(navigatorKey.currentContext!);
        }
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      return ApiResponse(status: false);
    }
  }

//MARK: Apple Login
  Future appleVerification({Map? extraRequest}) async {
    try {
      ApiResponse response = await _saveData(
        url: Apis.appleLogin,
        extraRequest: extraRequest,
      );
      if (response.status) {
        if (_user?.signupStatus == true) {
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, Tabs.path);
        } else {
          Utils().showLog('popping back');
          Navigator.pop(navigatorKey.currentContext!);
        }
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      return ApiResponse(status: false);
    }
  }

//MARK: Save Data
  Future<ApiResponse> _saveData({
    required String url,
    Map? extraRequest,
  }) async {
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
        url: url,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        //set user
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        BrazeService.brazeUserEvent();

        //creating share link
        shareUri = await DynamicLinkService.instance.getDynamicLink();

        if (_user?.membership?.purchased != 1) {
          if (kDebugMode) {
            print('Calling membership page');
          }
          // subscribe();
        }

        if (_user?.signupStatus != null) {
          AmplitudeService.logLoginSignUpEvent(
            isRegistered: (_user?.signupStatus ?? false) ? 1 : 0,
          );
        }
      }
      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );

      return ApiResponse(status: response.status, data: response.data);
    } catch (e) {
      Utils().showLog('Error in $url');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      return ApiResponse(status: false);
    } finally {
      setStatus(Status.loaded);
    }
  }

//MARK: Logout

  Future logoutUser() async {
    try {
      UserManager manager = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        "token": manager.user?.token ?? '',
      };
      ApiResponse response = await apiRequest(
        url: Apis.logout,
        request: request,
        showProgress: true,
      );
      clearUser();
      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
    } catch (e) {
      Utils().showLog('Error in ${Apis.logout}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    } finally {
      setStatus(Status.loaded);
    }
  }

  //MARK: Clear User
  clearUser() {
    Preference.logout();
    _user = null;
    notifyListeners();
    MyHomeManager homeManager =
        navigatorKey.currentContext!.read<MyHomeManager>();

    SignalsManager signalsManager =
        navigatorKey.currentContext!.read<SignalsManager>();

    ToolsManager toolsManager =
        navigatorKey.currentContext!.read<ToolsManager>();

    SearchManager searchManager =
        navigatorKey.currentContext!.read<SearchManager>();

    NewsManager newsManager = navigatorKey.currentContext!.read<NewsManager>();

    BlogsManager blogsManager =
        navigatorKey.currentContext!.read<BlogsManager>();

    homeManager.clearAllData();
    signalsManager.clearAllData();
    toolsManager.clearAllData();
    searchManager.clearAllData();
    newsManager.clearAllData();
    blogsManager.clearAllData();

    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const Tabs()),
    );
  }
}
