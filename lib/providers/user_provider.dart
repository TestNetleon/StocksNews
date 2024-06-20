// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/drawer_data_res.dart';
import 'package:stocks_news_new/modals/refer.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/alert_provider.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/providers/notification_provider.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/apple_otp_sheet_login.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/otp_sheet_login.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/otp_sheet_signup.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_success.dart';
import 'package:stocks_news_new/screens/drawer/widgets/review_app_pop_up.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

import '../fcm/dynamic_links.service.dart';
import '../utils/dialogs.dart';
import '../widgets/ios_emailerror.dart';

//
class UserProvider extends ChangeNotifier with AuthProviderBase {
  UserRes? _user;
  Status _status = Status.loaded;
  Status get status => _status;
  UserRes? get user => _user;
  bool isKeyboardVisible = false;

  DrawerDataRes? _drawerData;
  DrawerDataRes? get drawerData => _drawerData;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void keyboardVisiblity(BuildContext context) {
    final bottomInset = View.of(context).viewInsets.bottom;
    isKeyboardVisible = bottomInset > 0;
    notifyListeners();
  }

  // void setMessageObject() async {
  //   MessageRes? messageObject = await Preference.getLocalDataBase();
  //   if (messageObject?.error != null) {
  //     Const.errSomethingWrong = messageObject!.error!;
  //   }
  //   notifyListeners();
  // }

  Future setUser(UserRes user) async {
    _user = user;
    _status = Status.loaded;
    Preference.saveUser(_user);
    shareUri =
        await DynamicLinkService.instance.getDynamicLink(_user?.referralCode);
    notifyListeners();
  }

  void updateUser(
      {String? image,
      String? name,
      String? email,
      String? displayName,
      String? phone,
      String? referralCode,
      String? referralUrl}) async {
    if (image != null) _user?.image = image;
    if (email != null) _user?.email = email;
    if (name != null) _user?.name = name;
    if (displayName != null) _user?.displayName = displayName;
    if (phone != null) _user?.phone = phone;
    if (referralCode != null) _user?.referralCode = referralCode;
    if (referralUrl != null) _user?.referralUrl = referralUrl;

    Preference.saveUser(_user);
    shareUri =
        await DynamicLinkService.instance.getDynamicLink(_user?.referralCode);
    Utils().showLog("Updating user..");
    notifyListeners();
  }

  Future<bool> checkForUser() async {
    clearUser();
    final UserRes? tempUser = await Preference.getUser();
    if (tempUser != null) {
      _user = tempUser;
      // _authToken = authToken;
      // validAuthToken = authToken;
      notifyListeners();
    }
    return _user != null;
  }

  void updateEmail(value) {
    _user?.username = value;
    notifyListeners();
  }

  Future getReviewTextDetail(request) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.drawerData,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        _drawerData = drawerDataResFromJson(jsonEncode(response.data));
        showDialog(
          context: navigatorKey.currentContext!,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) {
            return const ReviewAppPopUp();
          },
        );
      } else {
        _drawerData = null;
      }
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: response.message,
      //   type: response.status ? SnackbarType.info : SnackbarType.error,
      // );
    } catch (e) {
      _drawerData = null;
      setStatus(Status.loaded);
    }
  }

  void logout() async {
    showConfirmAlertDialog(
      context: navigatorKey.currentContext,
      message: "Do you want to logout?",
      onclick: () => handleSessionOut(),
    );
    // Preference.logout();
    // _user = null;
    // notifyListeners();
    // Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Login.path);
  }

  void clearUser() async {
    _user = null;
    navigatorKey.currentContext!.read<LeaderBoardProvider>().clearData();
    notifyListeners();
  }

  Future login(
    request, {
    String? state,
    String? dontPop,
    bool editEmail = false,
    String? id,
  }) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.login,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        // _user = UserRes.fromJson(response.data);
        // Navigator.pushNamed(navigatorKey.currentContext!, OTPLogin.path);
        // Navigator.push(
        //   navigatorKey.currentContext!,
        //   createRoute(OTPLogin(
        //     state: state,
        //     dontPop: dontPop,
        //   )),
        // );
        if (editEmail) {
          Navigator.pop(navigatorKey.currentContext!);
          // showErrorMessage(message: response.message, snackbar: false);
        } else {
          otpLoginSheet(
              state: state,
              dontPop: dontPop,
              id: id,
              userName: response.data['username']);
          Timer(const Duration(seconds: 1), () {
            // popUpAlert(
            //     message: "${response.message}",
            //     title: "Alert",
            //     icon: Images.otpSuccessGIT);
          });
        }
      } else {
        if (editEmail) {
          // showErrorMessage(message: response.message, snackbar: false);

          Navigator.pop(navigatorKey.currentContext!);
        }
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
    }
  }

  Future sendEmailOTP(
    request, {
    String? state,
    String? dontPop,
    bool editEmail = false,
    String? id,
    String? email,
    bool showOtp = false,
  }) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.sendAppleOtp,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        // if (editEmail) {
        //   Navigator.pop(navigatorKey.currentContext!);
        // } else {
        if (showOtp) {
          appleOtpLoginSheet(
            state: state,
            dontPop: dontPop,
            id: id,
            email: email,
          );
        } else {
          popUpAlert(
            message: "${response.message}",
            title: "OTP Sent",
            icon: Images.otpSuccessGIT,
          );
        }
        // Timer(const Duration(seconds: 1), () {
        // }
      } else {
        // if (editEmail) {
        //   // showErrorMessage(message: response.message, snackbar: false);
        //   Navigator.pop(navigatorKey.currentContext!);
        // }
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
        message: Const.errSomethingWrong,
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      setStatus(Status.loaded);
    }
  }

  Future googleLogin(request, {String? state, String? dontPop}) async {
    setStatus(Status.loading);
    CompareStocksProvider compareProvider =
        navigatorKey.currentContext!.read<CompareStocksProvider>();

    AlertProvider alertProvider =
        navigatorKey.currentContext!.read<AlertProvider>();

    WatchlistProvider watchlistProvider =
        navigatorKey.currentContext!.read<WatchlistProvider>();

    NotificationProvider notificationProvider =
        navigatorKey.currentContext!.read<NotificationProvider>();

    if (request["fcm_token"].isEmpty) {
      String? fcm = await FirebaseMessaging.instance.getToken();
      request["fcm_token"] = fcm ?? "";
    }

    try {
      ApiResponse response = await apiRequest(
        url: Apis.googleLogin,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);

        shareUri = await DynamicLinkService.instance
            .getDynamicLink(_user?.referralCode);

        // Navigator.popUntil(
        //     navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushNamedAndRemoveUntil(
        //     navigatorKey.currentContext!, Tabs.path, (route) => false);
        if (dontPop == null) {
          Navigator.pop(navigatorKey.currentContext!);

          if (state == "compare") {
            await compareProvider.getCompareStock();
          } else if (state == "alert") {
            await alertProvider.getAlerts(showProgress: false);
          } else if (state == "watchList") {
            await watchlistProvider.getData(showProgress: false);
          } else if (state == "notification") {
            await notificationProvider.getData(showProgress: false);
          }
        } else {
          // kDebugMode ? Preference.setShowIntro(true) : null;
          Preference.setShowIntro(false);
          // Navigator.pushNamedAndRemoveUntil(
          //     navigatorKey.currentContext!, Tabs.path, (route) => false);
          if (_user?.signupStatus ?? false) {
            shareUri = await DynamicLinkService.instance
                .getDynamicLink(_user?.referralCode);
            Navigator.pushNamed(
                navigatorKey.currentContext!, SignUpSuccess.path);
          } else {
            Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!,
              Tabs.path,
              (route) => false,
            );
          }
        }
      } else {
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
    }
  }

  Future appleLogin(
    request, {
    String? state,
    String? dontPop,
    String? id,
  }) async {
    setStatus(Status.loading);
    CompareStocksProvider compareProvider =
        navigatorKey.currentContext!.read<CompareStocksProvider>();

    AlertProvider alertProvider =
        navigatorKey.currentContext!.read<AlertProvider>();

    WatchlistProvider watchlistProvider =
        navigatorKey.currentContext!.read<WatchlistProvider>();

    NotificationProvider notificationProvider =
        navigatorKey.currentContext!.read<NotificationProvider>();

    if (request["fcm_token"].isEmpty) {
      String? fcm = await FirebaseMessaging.instance.getToken();
      request["fcm_token"] = fcm ?? "";
    }

    try {
      ApiResponse response = await apiRequest(
        url: Apis.appleLogin,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        shareUri = await DynamicLinkService.instance
            .getDynamicLink(_user?.referralCode);
        if (dontPop == null) {
          Navigator.pop(navigatorKey.currentContext!);
          if (state == "compare") {
            await compareProvider.getCompareStock();
          } else if (state == "alert") {
            await alertProvider.getAlerts(showProgress: false);
          } else if (state == "watchList") {
            await watchlistProvider.getData(showProgress: false);
          } else if (state == "notification") {
            await notificationProvider.getData(showProgress: false);
          }
        } else {
          Preference.setShowIntro(false);

          if (_user?.signupStatus ?? false) {
            shareUri = await DynamicLinkService.instance
                .getDynamicLink(_user?.referralCode);
            Navigator.pushNamed(
                navigatorKey.currentContext!, SignUpSuccess.path);
          } else {
            Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!,
              Tabs.path,
              (route) => false,
            );
          }
        }
      } else {
        // showErrorMessage(message: response.message);
        if (response.message == "Invalid email address") {
          Utils().showLog("Apple ID => $id");
          showIosEmailError(state: state, dontPop: dontPop, id: id);
        } else {
          popUpAlert(
            message: response.message ?? Const.errSomethingWrong,
            title: "Alert",
            icon: Images.alertPopGIF,
          );
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
    }
  }

  Future signup(
    request, {
    bool editEmail = false,
  }) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.signup,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        // _user = UserRes.fromJson(response.data);
        // Navigator.pushNamed(navigatorKey.currentContext!, OTPSignup.path);
        if (editEmail) {
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.pop(navigatorKey.currentContext!);
          otpSignupSheet(email: response.data['username']);
          // showErrorMessage(message: response.message, snackbar: false);
          // popUpAlert(
          //     message: "${response.message}",
          //     title: "Alert",
          //     icon: Images.otpSuccessGIT);
        } else {
          otpSignupSheet(email: response.data['username']);
        }
      } else {
        if (editEmail) {
          Navigator.pop(navigatorKey.currentContext!);
          // showErrorMessage(message: response.message, snackbar: false);
        } else {
          // showErrorMessage(message: response.message);
        }
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
    }
  }

  Future resendOtp(request) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.resendOtp,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: response.message,
      //   type: response.status ? SnackbarType.info : SnackbarType.error,
      // );
    } catch (e) {
      setStatus(Status.loaded);
    }
  }

  Future signupResendOtp(request) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.signupResendOtp,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: response.message,
      //   type: response.status ? SnackbarType.info : SnackbarType.error,
      // );
    } catch (e) {
      setStatus(Status.loaded);
    }
  }

  Future verifySignupOtp(request) async {
    setStatus(Status.loading);

    if (request["fcm_token"].isEmpty) {
      String? fcm = await FirebaseMessaging.instance.getToken();
      request["fcm_token"] = fcm ?? "";
    }

    try {
      ApiResponse response = await apiRequest(
        url: Apis.verifySignupOtp,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        Preference.setShowIntro(false);
        shareUri = await DynamicLinkService.instance
            .getDynamicLink(_user?.referralCode);
        Navigator.pushNamed(navigatorKey.currentContext!, SignUpSuccess.path);
        notifyListeners();
      } else {
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
    }
  }

  Future verifyLoginOtp(request, {String? state, String? dontPop}) async {
    setStatus(Status.loading);
    CompareStocksProvider compareProvider =
        navigatorKey.currentContext!.read<CompareStocksProvider>();

    AlertProvider alertProvider =
        navigatorKey.currentContext!.read<AlertProvider>();

    WatchlistProvider watchlistProvider =
        navigatorKey.currentContext!.read<WatchlistProvider>();

    NotificationProvider notificationProvider =
        navigatorKey.currentContext!.read<NotificationProvider>();

    if (request["fcm_token"].isEmpty) {
      String? fcm = await FirebaseMessaging.instance.getToken();
      request["fcm_token"] = fcm ?? "";
    }

    try {
      ApiResponse response = await apiRequest(
        url: Apis.verifyLoginOtp,
        request: request,
        showProgress: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        shareUri = await DynamicLinkService.instance
            .getDynamicLink(_user?.referralCode);
        if (dontPop == null) {
          if (state == "compare") {
            await compareProvider.getCompareStock();
          } else if (state == "alert") {
            await alertProvider.getAlerts(showProgress: false);
          } else if (state == "watchList") {
            await watchlistProvider.getData(showProgress: false);
          } else if (state == "notification") {
            await notificationProvider.getData(showProgress: false);
          }

          // Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path);
          // Navigator.pushNamedAndRemoveUntil(
          //     navigatorKey.currentContext!, Tabs.path, (route) => false);
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.pop(navigatorKey.currentContext!);
        } else {
          // kDebugMode ? Preference.setShowIntro(true) : null;
          Preference.setShowIntro(false);

          Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!, Tabs.path, (route) => false);
        }

        notifyListeners();
      } else {
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
    }
  }

  Future logoutUser(request, pop) async {
    HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();

    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
        showProgress: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        // handleSessionOut();
        if (pop) Navigator.pop(navigatorKey.currentContext!);
        Navigator.pop(navigatorKey.currentContext!);
        // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);
        Preference.logout();
        clearUser();
        provider.setTotalsAlerts(0);
        provider.setTotalsWatchList(0);

        // showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        // showErrorMessage(
        //   message: res.message,
        // );
      }
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }

  Future deleteUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.deleteUser,
        request: request,
        showProgress: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        // showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        // showErrorMessage(
        //   message: res.message,
        // );
      }
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }

  Future updateProfile({
    required String token,
    required String name,
    required String email,
    String? otp,
    String? displayName,
    bool verifyOTP = false,
  }) async {
    Map request = verifyOTP
        ? {
            "token": token,
            "email": email,
            "otp": otp,
          }
        : {
            "token": token,
            "name": name,
            "display_name": displayName,
            "email": email,
          };
    try {
      ApiResponse res = await apiRequest(
        url: verifyOTP ? Apis.updateProfileEmail : Apis.updateProfile,
        request: request,
        showProgress: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        // showErrorMessage(message: res.message, type: SnackbarType.info);
        if (verifyOTP) Navigator.pop(navigatorKey.currentContext!);

        return ApiResponse(status: true, data: res.data, message: res.message);
      } else {
        setStatus(Status.loaded);
        // showErrorMessage(
        //   message: res.message,
        // );
        if (verifyOTP) Navigator.pop(navigatorKey.currentContext!);

        return ApiResponse(
          status: false,
          message: res.message,
        );
      }
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
      if (verifyOTP) Navigator.pop(navigatorKey.currentContext!);

      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

  Future resendUpdateEmailOtp(request) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.updateProfileOTP,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        setStatus(Status.loaded);
        // showErrorMessage(message: response.message, snackbar: false);

        return ApiResponse(status: true, data: response.data);
      } else {
        setStatus(Status.loaded);
        Navigator.pop(navigatorKey.currentContext!);
        // showErrorMessage(message: response.message);
        return ApiResponse(status: false);
      }
    } catch (e) {
      setStatus(Status.loaded);
      Navigator.pop(navigatorKey.currentContext!);
      return ApiResponse(status: false);
    }
  }

//-------------------------------------------------

  Future referLogin(request) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.referLogin,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        //
      } else {
        popUpAlert(
            message: response.message ?? "",
            title: "Alert",
            icon: Images.alertPopGIF);
        //
      }

      return ApiResponse(status: response.status, message: response.message);
    } catch (e) {
      Utils().showLog("$e");
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

  ReferSuccessRes? _refer;
  ReferSuccessRes? get refer => _refer;

  Future verifyReferLogin(request) async {
    notifyListeners();
    try {
      ApiResponse response = await apiRequest(
        url: Apis.checkPhone,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        _refer = referSuccessResFromJson(jsonEncode(response.data));
        updateUser(
          referralCode: _refer?.referralCode,
          referralUrl: _refer?.referralUrl,
        );

        shareUri = await DynamicLinkService.instance
            .getDynamicLink(_user?.referralCode);
      } else {
        //
        popUpAlert(
            message: response.message ?? "",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
      notifyListeners();

      return ApiResponse(
        status: response.status,
        message: response.message,
        extra: response.extra,
      );
    } catch (e) {
      Utils().showLog("$e");
      notifyListeners();

      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }
}
