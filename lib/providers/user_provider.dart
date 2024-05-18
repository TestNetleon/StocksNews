import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/alert_provider.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/notification_provider.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/otp_sheet_login.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/otp_sheet_signup.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_success.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

import '../widgets/ios_emailerror.dart';

//
class UserProvider extends ChangeNotifier with AuthProviderBase {
  UserRes? _user;
  Status _status = Status.loaded;
  Status get status => _status;
  UserRes? get user => _user;
  bool isKeyboardVisible = false;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void keyboardVisiblity(BuildContext context) {
    final bottomInset = View.of(context).viewInsets.bottom;
    isKeyboardVisible = bottomInset > 0;
    notifyListeners();
  }

  void setUser(UserRes user) {
    _user = user;
    _status = Status.loaded;
    Preference.saveUser(_user);
    notifyListeners();
  }

  void updateUser({String? image, String? name, String? email}) {
    if (image != null) _user?.image = image;
    if (email != null) _user?.email = email;
    if (name != null) _user?.name = name;
    Preference.saveUser(_user);
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
    notifyListeners();
  }

  Future login(
    request, {
    String? state,
    String? dontPop,
    bool editEmail = false,
  }) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.login,
        request: request,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        // Navigator.pushNamed(navigatorKey.currentContext!, OTPLogin.path);
        // Navigator.push(
        //   navigatorKey.currentContext!,
        //   createRoute(OTPLogin(
        //     state: state,
        //     dontPop: dontPop,
        //   )),
        // );
        if (editEmail) {
          log("****************");
          Navigator.pop(navigatorKey.currentContext!);
          // showErrorMessage(message: response.message, snackbar: false);
        } else {
          otpLoginSheet(state: state, dontPop: dontPop);
          Timer(const Duration(seconds: 1), () {
            popUpAlert(
                message: "${response.message}",
                title: "Alert",
                icon: Images.otpSuccessGIT);
          });
        }
      } else {
        if (editEmail) {
          // showErrorMessage(message: response.message, snackbar: false);

          Navigator.pop(navigatorKey.currentContext!);
        }
        showErrorMessage(message: response.message);
      }
    } catch (e) {
      log(e.toString());
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
    try {
      ApiResponse response = await apiRequest(
        url: Apis.googleLogin,
        request: request,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        // Navigator.popUntil(
        //     navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushNamedAndRemoveUntil(
        //     navigatorKey.currentContext!, Tabs.path, (route) => false);
        if (dontPop == null) {
          Navigator.pop(navigatorKey.currentContext!);

          if (state == "compare") {
            await compareProvider.getCompareStock();
          } else if (state == "alert") {
            await alertProvider.getAlerts(showProgress: true);
          } else if (state == "watchList") {
            await watchlistProvider.getData(showProgress: true);
          } else if (state == "notification") {
            await notificationProvider.getData(showProgress: true);
          }
        } else {
          // kDebugMode ? Preference.setFirstTime(true) : null;
          Preference.setFirstTime(false);

          Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!, Tabs.path, (route) => false);
        }
      } else {
        showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future appleLogin(request, {String? state, String? dontPop}) async {
    setStatus(Status.loading);
    CompareStocksProvider compareProvider =
        navigatorKey.currentContext!.read<CompareStocksProvider>();

    AlertProvider alertProvider =
        navigatorKey.currentContext!.read<AlertProvider>();

    WatchlistProvider watchlistProvider =
        navigatorKey.currentContext!.read<WatchlistProvider>();

    NotificationProvider notificationProvider =
        navigatorKey.currentContext!.read<NotificationProvider>();
    try {
      ApiResponse response = await apiRequest(
        url: Apis.appleLogin,
        request: request,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        // Navigator.pushNamedAndRemoveUntil(
        //     navigatorKey.currentContext!, Tabs.path, (route) => false);
        if (dontPop == null) {
          Navigator.pop(navigatorKey.currentContext!);
          if (state == "compare") {
            await compareProvider.getCompareStock();
          } else if (state == "alert") {
            await alertProvider.getAlerts(showProgress: true);
          } else if (state == "watchList") {
            await watchlistProvider.getData(showProgress: true);
          } else if (state == "notification") {
            await notificationProvider.getData(showProgress: true);
          }
        } else {
          // kDebugMode ? Preference.setFirstTime(true) : null;
          Preference.setFirstTime(false);

          Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!, Tabs.path, (route) => false);
        }
      } else {
        // showErrorMessage(message: response.message);
        if (response.message == "Invalid email address") {
          showIosEmailError(state: state, dontPop: dontPop);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      log(e.toString());
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
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        // Navigator.pushNamed(navigatorKey.currentContext!, OTPSignup.path);
        if (editEmail) {
          Navigator.pop(navigatorKey.currentContext!);
          // showErrorMessage(message: response.message, snackbar: false);
          popUpAlert(
              message: "${response.message}",
              title: "Alert",
              icon: Images.otpSuccessGIT);
        } else {
          otpSignupSheet();
        }
      } else {
        if (editEmail) {
          Navigator.pop(navigatorKey.currentContext!);
          // showErrorMessage(message: response.message, snackbar: false);
          popUpAlert(
              message: "${response.message}",
              title: "Alert",
              icon: Images.alertPopGIF);
        } else {
          // showErrorMessage(message: response.message);
          popUpAlert(
              message: "${response.message}",
              title: "Alert",
              icon: Images.alertPopGIF);
        }
      }
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future resendOtp(request) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.resendOtp,
        request: request,
      );
      setStatus(Status.loaded);
      showErrorMessage(
        message: response.message,
        type: response.status ? SnackbarType.info : SnackbarType.error,
      );
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
      );
      setStatus(Status.loaded);
      showErrorMessage(
        message: response.message,
        type: response.status ? SnackbarType.info : SnackbarType.error,
      );
    } catch (e) {
      setStatus(Status.loaded);
    }
  }

  Future verifySignupOtp(request) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.verifySignupOtp,
        request: request,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        // Preference.saveUser(response.data);
        // _navigateToRequiredScreen(response);
        Preference.saveUser(response.data);

        // kDebugMode ? Preference.setFirstTime(true) : null;
        Preference.setFirstTime(false);

        Navigator.pushNamed(navigatorKey.currentContext!, SignUpSuccess.path);
        notifyListeners();
      } else {
        showErrorMessage(message: response.message);
      }
    } catch (e) {
      log(e.toString());
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
    try {
      ApiResponse response = await apiRequest(
        url: Apis.verifyLoginOtp,
        request: request,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);

        if (dontPop == null) {
          if (state == "compare") {
            await compareProvider.getCompareStock();
          } else if (state == "alert") {
            await alertProvider.getAlerts(showProgress: true);
          } else if (state == "watchList") {
            await watchlistProvider.getData(showProgress: true);
          } else if (state == "notification") {
            await notificationProvider.getData(showProgress: true);
          }

          // Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path);
          // Navigator.pushNamedAndRemoveUntil(
          //     navigatorKey.currentContext!, Tabs.path, (route) => false);
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.pop(navigatorKey.currentContext!);
        } else {
          // kDebugMode ? Preference.setFirstTime(true) : null;
          Preference.setFirstTime(false);

          Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!, Tabs.path, (route) => false);
        }

        notifyListeners();
      } else {
        showErrorMessage(message: response.message);
      }
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future logoutUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
      );
      if (res.status) {
        setStatus(Status.loaded);
        // handleSessionOut();
        Navigator.pop(navigatorKey.currentContext!);
        // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);
        Preference.logout();
        clearUser();
        showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        showErrorMessage(
          message: res.message,
        );
      }
    } catch (e) {
      setStatus(Status.loaded);
      showErrorMessage(
        message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      );
    }
  }

  Future deleteUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.deleteUser,
        request: request,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        showErrorMessage(
          message: res.message,
        );
      }
    } catch (e) {
      setStatus(Status.loaded);
      showErrorMessage(
        message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      );
    }
  }

  Future updateProfile({
    required String token,
    required String name,
    required String email,
    String? otp,
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
            "email": email,
          };
    try {
      ApiResponse res = await apiRequest(
        url: verifyOTP ? Apis.updateProfileEmail : Apis.updateProfile,
        request: request,
      );
      if (res.status) {
        setStatus(Status.loaded);
        showErrorMessage(message: res.message, type: SnackbarType.info);
        if (verifyOTP) Navigator.pop(navigatorKey.currentContext!);

        return ApiResponse(status: true, data: res.data);
      } else {
        setStatus(Status.loaded);
        showErrorMessage(
          message: res.message,
        );
        if (verifyOTP) Navigator.pop(navigatorKey.currentContext!);

        return ApiResponse(status: false);
      }
    } catch (e) {
      setStatus(Status.loaded);
      showErrorMessage(
        message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      );
      if (verifyOTP) Navigator.pop(navigatorKey.currentContext!);

      return ApiResponse(status: false);
    }
  }

  Future resendUpdateEmailOtp(request) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.updateProfileOTP,
        request: request,
      );
      if (response.status) {
        setStatus(Status.loaded);
        showErrorMessage(message: response.message, snackbar: false);

        return ApiResponse(status: true, data: response.data);
      } else {
        setStatus(Status.loaded);
        Navigator.pop(navigatorKey.currentContext!);
        showErrorMessage(message: response.message);
        return ApiResponse(status: false);
      }
    } catch (e) {
      setStatus(Status.loaded);
      Navigator.pop(navigatorKey.currentContext!);
      return ApiResponse(status: false);
    }
  }

  // Future verifyEmailOTP(request) async {
  //   setStatus(Status.loading);

  //   Map request={
  //     "token":,
  //   }
  //   try {
  //     ApiResponse response = await apiRequest(
  //       url: Apis.updateProfileEmail,
  //       request: request,
  //     );
  //     setStatus(Status.loaded);
  //     if (response.status) {
  //       showErrorMessage(message: response.message, type: SnackbarType.info);
  //     } else {
  //       showErrorMessage(message: response.message);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     setStatus(Status.loaded);
  //   }
  // }
}
