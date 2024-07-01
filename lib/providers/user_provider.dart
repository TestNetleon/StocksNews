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
import 'package:stocks_news_new/screens/auth/bottomSheets/refer/refer_code.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/refer_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_success.dart';
import 'package:stocks_news_new/screens/drawer/widgets/review_app_pop_up.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/phone_email_otp.dart';
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

  String _emailClickText = "Edit";
  String get emailClickText => _emailClickText;

  bool _emailEditable = false;
  bool get emailEditable => _emailEditable;

  String _phoneClickText = "Edit";
  String get phoneClickText => _phoneClickText;

  bool _phoneEditable = false;
  bool get phoneEditable => _phoneEditable;

  DrawerDataRes? _drawerData;
  DrawerDataRes? get drawerData => _drawerData;

  bool emailVerified = false;
  bool phoneVerified = false;

  resetVerification() {
    emailVerified = false;
    phoneVerified = false;
    notifyListeners();
  }

  void onChangeEmail(String value) {
    if ((value == _user?.email) &&
        (_user?.email != null && _user?.email != '')) {
      emailVerified = true;
    } else {
      emailVerified = false;
    }
    notifyListeners();
  }

  void onChangePhone(String value) {
    if ((value == _user?.phone) &&
        (_user?.phone != null && _user?.phone != '')) {
      phoneVerified = true;
    } else {
      phoneVerified = false;
    }
    notifyListeners();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setEmailClickText() {
    _emailClickText = "update";
    _emailEditable = true;
    emailVerified = true;
    notifyListeners();
  }

  void setEmailClickEditText() {
    _emailClickText = "Edit";
    _emailEditable = false;
    notifyListeners();
  }

  void setPhoneClickText() {
    _phoneClickText = "update";
    _phoneEditable = true;
    phoneVerified = true;

    notifyListeners();
  }

  void setPhoneClickEditText() {
    _phoneClickText = "Edit";
    _phoneEditable = false;
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
        removeForceLogin: true,
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
    // Navigator.pushReplacement(navigatorKey.currentContext!, Login.path);
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
    String? email,
    String? id,
  }) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.login,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        // _user = UserRes.fromJson(response.data);
        // Navigator.push(navigatorKey.currentContext!, OTPLogin.path);
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
        }
      } else {
        if (editEmail) {
          // showErrorMessage(message: response.message, snackbar: false);

          Navigator.pop(navigatorKey.currentContext!);
        }
        // showErrorMessage(message: response.message);
        if (response.message ==
            "This email address is not registered with stocks.news.") {
          popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF,
            okText: "Click here to register",
            onTap: () {
              Navigator.pop(navigatorKey.currentContext!);
              Navigator.pop(navigatorKey.currentContext!);

              signupSheet(email: email);
            },
          );
        } else {
          popUpAlert(
              message: "${response.message}",
              title: "Alert",
              icon: Images.alertPopGIF);
        }
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
    String? code,
    bool? alreadySubmitted,
  }) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.sendAppleOtp,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        // if (editEmail) {
        //   Navigator.pop(navigatorKey.currentContext!);
        // } else {
        if (showOtp) {
          appleOtpLoginSheet(
            state: state,
            dontPop: "",
            id: id,
            email: email,
            code: code,
            alreadySubmitted: alreadySubmitted,
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
          icon: Images.alertPopGIF,
        );
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

  Future googleLogin(
    request, {
    String? state,
    String? dontPop,
    bool alreadySubmitted = true,
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
        url: Apis.googleLogin,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);

        shareUri = await DynamicLinkService.instance
            .getDynamicLink(_user?.referralCode);

        // Navigator.popUntil(
        //     navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushAndRemoveUntil(
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
          // Navigator.pushAndRemoveUntil(
          //     navigatorKey.currentContext!, Tabs.path, (route) => false);

          if (_user?.signupStatus ?? false) {
            shareUri = await DynamicLinkService.instance
                .getDynamicLink(_user?.referralCode);

            String? referralCode = await Preference.getReferral();
            if (alreadySubmitted) {
              // (referralCode != null || referralCode != "") &&
              // Only for Sign up
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const SignUpSuccess()),
              );
            } else {
              // Only For Login
              referSheet(
                onReferral: (code) {
                  updateReferralCodeOnlyForApple(code: referralCode ?? code);
                },
              );
            }

            // Navigator.push(
            //   navigatorKey.currentContext!,
            //   MaterialPageRoute(builder: (_) => const SignUpSuccess()),
            // );
          } else {
            navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
            Navigator.popUntil(
                navigatorKey.currentContext!, (route) => route.isFirst);
            Navigator.pushReplacement(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const Tabs()),
            );
          }
        }
        if ((_user?.phone == null || _user?.phone == "") &&
            _user?.signupStatus == false) {
          referLogin();
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
    String? code,
    bool alreadySubmitted = false,
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
        removeForceLogin: true,
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

            String? referralCode = await Preference.getReferral();
            if (alreadySubmitted) {
              // (referralCode != null || referralCode != "") &&
              // Only for Sign up
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const SignUpSuccess()),
              );
            } else {
              // Only For Login
              referSheet(
                onReferral: (code) {
                  updateReferralCodeOnlyForApple(code: referralCode ?? code);
                },
              );
            }
          } else {
            navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
            Navigator.popUntil(
              navigatorKey.currentContext!,
              (route) => route.isFirst,
            );
            Navigator.pushReplacement(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const Tabs()),
            );
          }
        }

        if ((_user?.phone == null || _user?.phone == "") &&
            _user?.signupStatus == false) {
          referLogin();
        }
      } else {
        // showErrorMessage(message: response.message);
        if (response.message == "Invalid email address") {
          showIosEmailError(
            state: state,
            dontPop: dontPop,
            id: id,
            code: code,
            alreadySubmitted: alreadySubmitted,
          );
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

  Future updateReferralCodeOnlyForApple({
    required String? code,
  }) async {
    setStatus(Status.loading);

    Map request = {
      "token": _user?.token ?? "",
      "referral_code": code ?? "",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.updateReferral,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const SignUpSuccess()),
        );
      } else {
        popUpAlert(
          message: response.message ?? Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF,
        );
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
    String? referCode,
  }) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.signup,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        // _user = UserRes.fromJson(response.data);
        // Navigator.push(navigatorKey.currentContext!, OTPSignup.path);
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
          otpSignupSheet(
            email: response.data['username'],
            referCode: referCode,
          );
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
        removeForceLogin: true,
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
        removeForceLogin: true,
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
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        Preference.setShowIntro(false);
        shareUri = await DynamicLinkService.instance
            .getDynamicLink(_user?.referralCode);
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const SignUpSuccess()),
        );

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
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        Preference.saveUser(response.data);
        navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
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

          Navigator.pop(navigatorKey.currentContext!);
          Navigator.pop(navigatorKey.currentContext!);
        } else {
          // kDebugMode ? Preference.setShowIntro(true) : null;
          Preference.setShowIntro(false);
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const Tabs()),
          );
        }

        notifyListeners();
        if ((_user?.phone == null || _user?.phone == "")) {
          referLogin();
        }
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
        removeForceLogin: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        // handleSessionOut();
        if (pop) Navigator.pop(navigatorKey.currentContext!);
        Navigator.pop(navigatorKey.currentContext!);
        // Navigator.pushReplacement(navigatorKey.currentContext!, Tabs.path);
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
        removeForceLogin: true,
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
        removeForceLogin: true,
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

  Future updatePhone({
    required token,
    required phone,
    required name,
    required displayName,
  }) async {
    Map request = {
      "token": token ?? "",
      "phone": phone,
      "name": name,
      "display_name": displayName,
    };

    try {
      ApiResponse res = await apiRequest(
        url: Apis.updateProfile,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        updateUser(name: name, displayName: displayName, phone: phone);
        return ApiResponse(status: true, message: res.message);
      } else {
        setStatus(Status.loaded);
        return ApiResponse(status: false, message: res.message);
      }
    } catch (e) {
      setStatus(Status.loaded);
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
        removeForceLogin: true,
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

  Future referLoginApi(request) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.referLogin,
        request: request,
        showProgress: true,
        removeForceLogin: true,
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
        removeForceLogin: true,
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

  Future emailUpdateOtp(request,
      {bool resendButtonClick = false, String email = ""}) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.updateEmailOtp,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        if (resendButtonClick == false) {
          phoneEmailOTP(text: email.toLowerCase(), screenType: false);
        }

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

  Future phoneUpdateOtp(request,
      {bool resendButtonClick = false, String phone = ""}) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.updatePhoneOtp,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        if (resendButtonClick == false) {
          phoneEmailOTP(text: phone, screenType: true);
        }

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

  Future checkEmailOtp(request) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.checkEmailOtp,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        _emailClickText = "Edit";
        _emailEditable = false;
        notifyListeners();
        closeKeyboard();
        showErrorMessage(message: response.message, type: SnackbarType.info);
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

  Future checkPhoneOtp(request) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.checkUpdatePhoneOtp,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        _phoneClickText = "Edit";
        _phoneEditable = false;
        notifyListeners();
        closeKeyboard();
        showErrorMessage(message: response.message, type: SnackbarType.info);
        //
      } else {
        popUpAlert(
          message: response.message ?? "",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
        //
      }

      return ApiResponse(status: response.status, message: response.message);
    } catch (e) {
      Utils().showLog("$e");
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

//----check phone no---------

  Future checkPhoneNo(phoneNo) async {
    UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
    Map request = {
      'token': user?.token ?? "",
      'phone': phoneNo,
    };

    try {
      ApiResponse response = await apiRequest(
        url: Apis.checkPhoneNo,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        //
      } else {
        popUpAlert(
            message: response.message ?? "",
            title: "Alert",
            icon: Images.alertPopGIF);
      }

      return ApiResponse(status: response.status, message: response.message);
    } catch (e) {
      Utils().showLog("$e");
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }
}
