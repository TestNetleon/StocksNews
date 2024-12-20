// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/database/database_helper.dart';
import 'package:stocks_news_new/modals/drawer_data_res.dart';
import 'package:stocks_news_new/modals/refer.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/refer_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/otp_sheet_login.dart';
import 'package:stocks_news_new/screens/auth/signup/otp_sheet_signup.dart';
import 'package:stocks_news_new/screens/auth/signup/apple_otp_sheet_login.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_success.dart';
import 'package:stocks_news_new/screens/drawer/widgets/review_app_pop_up.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/phone_email_otp.dart';
import 'package:stocks_news_new/screens/offerMembership/christmas/index.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

import '../fcm/dynamic_links.service.dart';
import '../modals/advertiser.dart';
import '../screens/offerMembership/blackFriday/index.dart';
import '../screens/membership_new/membership.dart';
import '../service/amplitude/service.dart';
import '../utils/dialogs.dart';
import '../widgets/ios_emailerror.dart';

class UserProvider extends ChangeNotifier {
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

  Extra? _extra;
  Extra? get extra => _extra;

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

  void onChangePhoneAndCode({
    required String phone,
    required String countryCode,
  }) {
    if (((phone == _user?.phone) &&
            (_user?.phone != null && _user?.phone != '')) &&
        ((countryCode == _user?.phoneCode) &&
            (_user?.phoneCode != null && _user?.phoneCode != ''))) {
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

  void updateBalance(newBalance) {
    _user?.pointEarn = newBalance;
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

  void keyboardVisibility(BuildContext context) {
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
    isSVG = isSvgFromUrl(user.image);
    shareUri = await DynamicLinkService.instance.getDynamicLink();
    // shareUri =
    //     await DynamicLinkService.instance.getDynamicLink(_user?.referralCode);
    notifyListeners();
  }

  Future updateUser({
    String? image,
    String? name,
    String? email,
    String? displayName,
    String? phone,
    String? referralCode,
    String? referralUrl,
    int? affiliateStatus,
    String? countryCode,
  }) async {
    if (image != null) _user?.image = image;
    if (email != null) _user?.email = email;
    if (name != null) _user?.name = name;
    if (displayName != null) _user?.displayName = displayName;
    if (phone != null) _user?.phone = phone;
    if (referralCode != null) _user?.referralCode = referralCode;
    if (referralUrl != null) _user?.referralUrl = referralUrl;
    if (affiliateStatus != null) _user?.affiliateStatus = affiliateStatus;
    if (countryCode != null) _user?.phoneCode = countryCode;

    Preference.saveUser(_user);
    isSVG = isSvgFromUrl(_user?.image);
    shareUri = await DynamicLinkService.instance.getDynamicLink();
    // shareUri =
    //     await DynamicLinkService.instance.getDynamicLink(_user?.referralCode);
    // Utils().showLog("Updating user..");
    notifyListeners();
  }

  Future<bool> checkForUser() async {
    _user = null;
    navigatorKey.currentContext!.read<LeaderBoardProvider>().clearData();

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

  void clearUser() async {
    _user = null;
    callAdvertiserAPI();

    Preference.logout();
    // Reset some data related to user
    navigatorKey.currentContext!.read<LeaderBoardProvider>().clearData();
    HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();
    provider.setTotalsAlerts(0);
    provider.setTotalsWatchList(0);
    provider.refreshData(null);
    // Reset login dialog visibility count
    isSVG = false;
    DatabaseHelper helper = DatabaseHelper();
    helper.resetVisibilityCount();
    // Back to home and refresh Home and User
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const Tabs()),
    );

    notifyListeners();
  }

  Future login(
    request, {
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
        if (editEmail) {
          Navigator.pop(navigatorKey.currentContext!);
        } else {
          otpLoginSheet(id: id, userName: response.data['username']);
        }
      } else {
        if (editEmail) {
          Navigator.pop(navigatorKey.currentContext!);
        }
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
    bool alreadySubmitted = true,
    bool direct = false,
  }) async {
    setStatus(Status.loading);

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

        _extra = (response.extra is Extra ? response.extra as Extra : null);

        if (_user?.signupStatus != null) {
          AmplitudeService.logLoginSignUpEvent(
            isRegistered: (_user?.signupStatus ?? false) ? 1 : 0,
          );
        }
        isSVG = isSvgFromUrl(_user?.image);

        shareUri = await DynamicLinkService.instance.getDynamicLink();
        Preference.setShowIntro(false);
        var tags = {
          'email': "${_user?.email}",
          'phone': "${_user?.phoneCode} ${_user?.phone}"
        };
        // OneSignal.User.addTags(tags);
        // Navigator.pushAndRemoveUntil(
        //     navigatorKey.currentContext!, Tabs.path, (route) => false);

        if (_user?.signupStatus ?? false) {
          shareUri = await DynamicLinkService.instance.getDynamicLink();
          // shareUri = await DynamicLinkService.instance
          //     .getDynamicLink(_user?.referralCode);
          String? referralCode = await Preference.getReferral();
          // if (alreadySubmitted) {
          if (referralCode != null && referralCode != "") {
            // Sign up from referral link
            Preference.clearReferral();

            _optionalNavigation(direct: direct);
          } else {
            // Sign up but not from referral link

            if (await Preference.isReferInput()) {
              final result = await referSheet(
                onReferral: (code) {
                  if (code == null || code == "") {
                    Navigator.pop(navigatorKey.currentContext!);
                    _optionalNavigation(direct: direct);
                  } else {
                    updateReferralCodeOnlyForApple(code: referralCode ?? code);
                  }
                },
              );
              if (result == null) {
                // Navigator.push(
                //   navigatorKey.currentContext!,
                //   MaterialPageRoute(builder: (_) => const SignUpSuccess()),
                // );
                _optionalNavigation(direct: direct);
              }
            } else {
              // Navigator.push(
              //   navigatorKey.currentContext!,
              //   MaterialPageRoute(builder: (_) => const SignUpSuccess()),
              // );
              _optionalNavigation(direct: direct);
            }
          }

          // Navigator.push(
          //   navigatorKey.currentContext!,
          //   MaterialPageRoute(builder: (_) => const SignUpSuccess()),
          // );
        } else {
          // navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
          Navigator.pop(navigatorKey.currentContext!);

          if ((_user?.membership?.purchased != null &&
                  _user?.membership?.purchased == 0) &&
              withLoginMembership) {
            Utils().showLog("----navigating from login verify---");
            // Navigator.push(
            //   navigatorKey.currentContext!,
            //   createRoute(
            //     NewMembership(cancel: true),
            //   ),
            // );

            closeKeyboard();
            if (_user?.showBlackFriday == true) {
              Navigator.push(
                navigatorKey.currentContext!,
                createRoute(
                  const BlackFridayMembershipIndex(cancel: true),
                ),
              );
            } else if (_user?.christmasMembership == true) {
              Navigator.push(
                navigatorKey.currentContext!,
                createRoute(
                  const ChristmasMembershipIndex(cancel: true),
                ),
              );
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                createRoute(
                  const NewMembership(cancel: true),
                ),
              );
            }
          }

          // Navigator.popUntil(
          //     navigatorKey.currentContext!, (route) => route.isFirst);
          // Navigator.pushReplacement(
          //   navigatorKey.currentContext!,
          //   MaterialPageRoute(builder: (_) => const Tabs()),
          // );
        }
        // }
        // if ((_user?.phone == null || _user?.phone == "") &&
        //     _user?.signupStatus == false) {
        //   referLogin();
        // }
        callSliderTrendingAPI();

        configureRevenueCatAttribute();
      } else {
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
      _extra = (response.extra is Extra ? response.extra as Extra : null);

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

  _optionalNavigation({bool direct = false}) {
    if (direct) {
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => const Tabs(
              // showRef: false,
              // showMembership: true,
              ),
        ),
      );
    } else {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const SignUpSuccess()),
      );
    }
  }

  Future appleLogin(
    request, {
    String? id,
    String? code,
    bool alreadySubmitted = false,
    bool direct = false,
  }) async {
    setStatus(Status.loading);

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

        _extra = (response.extra is Extra ? response.extra as Extra : null);

        if (_user?.signupStatus != null) {
          AmplitudeService.logLoginSignUpEvent(
            isRegistered: (_user?.signupStatus ?? false) ? 1 : 0,
          );
        }

        isSVG = isSvgFromUrl(_user?.image);
        var tags = {
          'email': "${_user?.email}",
          'phone': "${_user?.phoneCode} ${_user?.phone}"
        };
        // OneSignal.User.addTags(tags);
        shareUri = await DynamicLinkService.instance.getDynamicLink();
        // shareUri = await DynamicLinkService.instance
        //     .getDynamicLink(_user?.referralCode);
        Preference.setShowIntro(false);
        if (_user?.signupStatus ?? false) {
          String? referralCode = await Preference.getReferral();
          // if (alreadySubmitted) {
          if (referralCode != null && referralCode != "") {
            // Sign up from referral link
            Preference.clearReferral();
            // Navigator.push(
            //   navigatorKey.currentContext!,
            //   MaterialPageRoute(builder: (_) => const SignUpSuccess()),
            // );
            _optionalNavigation(direct: direct);
          } else {
            // Sign up but not from referral link
            if (await Preference.isReferInput()) {
              final result = await referSheet(
                onReferral: (code) {
                  if (code == null || code == "") {
                    Navigator.pop(navigatorKey.currentContext!);
                    // Navigator.push(
                    //   navigatorKey.currentContext!,
                    //   MaterialPageRoute(builder: (_) => const SignUpSuccess()),
                    // );
                    _optionalNavigation(direct: direct);
                  } else {
                    updateReferralCodeOnlyForApple(code: referralCode ?? code);
                  }
                },
              );
              if (result == null) {
                // Navigator.push(
                //   navigatorKey.currentContext!,
                //   MaterialPageRoute(builder: (_) => const SignUpSuccess()),
                // );
                _optionalNavigation(direct: direct);
              }
            } else {
              // Navigator.push(
              //   navigatorKey.currentContext!,
              //   MaterialPageRoute(builder: (_) => const SignUpSuccess()),
              // );
              _optionalNavigation(direct: direct);
            }
          }
        } else {
          Navigator.pop(navigatorKey.currentContext!);
          if ((_user?.membership?.purchased != null &&
                  _user?.membership?.purchased == 0) &&
              withLoginMembership) {
            Utils().showLog("----navigating from login verify---");

            // Navigator.push(
            //   navigatorKey.currentContext!,
            //   createRoute(
            //     NewMembership(cancel: true),
            //   ),
            // );
            closeKeyboard();
            if (_user?.showBlackFriday == true) {
              Navigator.push(
                navigatorKey.currentContext!,
                createRoute(
                  const BlackFridayMembershipIndex(cancel: true),
                ),
              );
            } else if (_user?.christmasMembership == true) {
              Navigator.push(
                navigatorKey.currentContext!,
                createRoute(
                  const ChristmasMembershipIndex(cancel: true),
                ),
              );
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                createRoute(
                  const NewMembership(cancel: true),
                ),
              );
            }
          }
          // Navigator.popUntil(
          //   navigatorKey.currentContext!,
          //   (route) => route.isFirst,
          // );
          // Navigator.pushReplacement(
          //   navigatorKey.currentContext!,
          //   MaterialPageRoute(builder: (_) => const Tabs()),
          // );
        }
        // }

        // if ((_user?.phone == null || _user?.phone == "") &&
        //     _user?.signupStatus == false) {
        //   referLogin();
        // }
        // navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
        callSliderTrendingAPI();

        configureRevenueCatAttribute();
      } else {
        // showErrorMessage(message: response.message);
        if (response.message == "Invalid email address") {
          showIosEmailError(
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
      _extra = (response.extra is Extra ? response.extra as Extra : null);

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
        Navigator.pop(navigatorKey.currentContext!);
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

  Future signup(request, {bool editEmail = false, String? referCode}) async {
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
      // ApiResponse response =
      await apiRequest(
        url: Apis.resendOtp,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      // if (response.status) {
      //   popUpAlert(message: response.message ?? "", title: "Success");
      // } else {
      //   popUpAlert(message: response.message ?? "", title: "Alert");
      // }
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
      // ApiResponse response =
      await apiRequest(
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
        isSVG = isSvgFromUrl(_user?.image);

        Preference.setShowIntro(false);
        Preference.clearReferral();
        shareUri = await DynamicLinkService.instance.getDynamicLink();

        // shareUri = await DynamicLinkService.instance
        //     .getDynamicLink(_user?.referralCode);
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const SignUpSuccess()),
        );

        notifyListeners();
        configureRevenueCatAttribute();
      } else {
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
      _extra = (response.extra is Extra ? response.extra as Extra : null);
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
    }
  }

  Future verifyLoginOtp(request) async {
    setStatus(Status.loading);

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
        isSVG = isSvgFromUrl(_user?.image);
        // navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
        shareUri = await DynamicLinkService.instance.getDynamicLink();
        Navigator.pop(navigatorKey.currentContext!);
        Navigator.pop(navigatorKey.currentContext!);
        callSliderTrendingAPI();

        Preference.setShowIntro(false);
        //--------
        var tags = {
          'email': "${_user?.email}",
          'phone': "${_user?.phoneCode} ${_user?.phone}"
        };
        // OneSignal.User.addTags(tags);
        //--------

        //CHECK MEMBERSHIP
        if ((_user?.membership?.purchased != null &&
                _user?.membership?.purchased == 0) &&
            withLoginMembership) {
          Utils().showLog("----navigating from login verify---");
          // Navigator.push(
          //   navigatorKey.currentContext!,
          //   createRoute(
          //     NewMembership(cancel: true),
          //   ),
          // );
          closeKeyboard();
          if (_user?.showBlackFriday == true) {
            Navigator.push(
              navigatorKey.currentContext!,
              createRoute(
                const BlackFridayMembershipIndex(cancel: true),
              ),
            );
          } else if (_user?.christmasMembership == true) {
            Navigator.push(
              navigatorKey.currentContext!,
              createRoute(
                const ChristmasMembershipIndex(cancel: true),
              ),
            );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              createRoute(
                const NewMembership(cancel: true),
              ),
            );
          }
        }
        notifyListeners();
        configureRevenueCatAttribute();
      } else {
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
      _extra = (response.extra is Extra ? response.extra as Extra : null);
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
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        // if (pop) Navigator.pop(navigatorKey.currentContext!);
        // Navigator.pop(navigatorKey.currentContext!);
        // Preference.logout();
        clearUser();
        isSVG = false;
        // provider.setTotalsAlerts(0);
        // provider.setTotalsWatchList(0);
        // DatabaseHelper helper = DatabaseHelper();
        // helper.resetVisibilityCount();

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
        // Navigator.popUntil(
        //     navigatorKey.currentContext!, (route) => route.isFirst);
        clearUser();
        // Preference.logout();
        // HomeProvider provider =
        //     navigatorKey.currentContext!.read<HomeProvider>();
        // provider.setTotalsAlerts(0);
        // provider.setTotalsWatchList(0);
        // DatabaseHelper helper = DatabaseHelper();
        // helper.resetVisibilityCount();
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
    String? phone,
    String? countryCode,
    bool verifyOTP = false,
  }) async {
    Utils().showLog('got phone $phone');
    Map request = verifyOTP
        ? {
            "token": token,
            "email": email,
            "otp": otp,
          }
        : {
            "token": token,
            "name": name,
            "display_name": displayName ?? '',
            "email": email,
          };

    if (phone != null && phone.isNotEmpty) {
      request['phone'] = phone;
    }
    if (countryCode != null && countryCode.isNotEmpty) {
      request['phone_code'] = countryCode;
    }

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
      Utils().showLog('$e');
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
    affiliateStatus,
    countryCode,
  }) async {
    Map request = {
      "token": token ?? "",
      "phone": phone,
      "name": name,
      "display_name": displayName,
    };

    if (affiliateStatus != null) {
      request.addAll({"affiliate_status": "1"});
    }
    if (countryCode != null) {
      request.addAll({"phone_code": countryCode});
    }

    try {
      ApiResponse res = await apiRequest(
        url: Apis.updateProfile,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        updateUser(
          name: name,
          displayName: displayName,
          phone: phone,
          affiliateStatus: affiliateStatus,
          countryCode: countryCode,
        );
        try {
          if (countryCode != null &&
              countryCode != '' &&
              phone != null &&
              phone != '') {
            navigatorKey.currentContext!
                .read<HomeProvider>()
                .clearExtraCountryCodeError();
          }
        } catch (e) {
          //
        }
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
        shareUri = await DynamicLinkService.instance.getDynamicLink();
        // shareUri = await DynamicLinkService.instance
        //     .getDynamicLink(_user?.referralCode);
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
          phoneEmailOTP(
            text: email.toLowerCase(),
            screenType: false,
          );
        } else {}

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
        // navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
        callSliderTrendingAPI();
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

  Future checkLogin(request) async {
    // UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;

    try {
      ApiResponse response = await apiRequest(
        url: Apis.loginNew,
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

  Future completeRegistration(request) async {
    // UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;

    try {
      ApiResponse response = await apiRequest(
        url: Apis.loginNew,
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

  //BASE AUTH

  Future checkPhoneExist({
    required String phone,
    required String countryCode,
  }) async {
    try {
      Map request = {
        'token': _user?.token ?? '',
        'phone': phone,
        'phone_code': countryCode,
      };

      ApiResponse response = await apiRequest(
        url: Apis.checkPhoneExist,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        //
      } else {
        popUpAlert(
          title: 'Alert',
          message: response.message,
          icon: Images.alertPopGIF,
        );
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      popUpAlert(
        title: 'Alert',
        message: Const.errSomethingWrong,
        icon: Images.alertPopGIF,
      );
      return ApiResponse(status: false);
    }
  }

  // Final OTP
  Future finalVerifyOTP(
    request, {
    bool doublePop = true,
    bool skipPop = false,
  }) async {
    setStatus(Status.loading);

    try {
      ApiResponse response = await apiRequest(
        url: Apis.phoneLogin,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      setStatus(Status.loaded);
      if (response.status) {
        _user = UserRes.fromJson(response.data);
        // BrazeService().startSession();
        // BrazeService.brazeUserEvent();

        Preference.saveUser(response.data);
        isSVG = isSvgFromUrl(_user?.image);
        Utils().showLog('IS SVG $isSVG');
        // navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider();
        shareUri = await DynamicLinkService.instance.getDynamicLink();
        HomeProvider provider =
            navigatorKey.currentContext!.read<HomeProvider>();
        provider.getHomeSlider(sendPublisher: true);

        if (!skipPop) {
          if (doublePop) {
            Navigator.pop(navigatorKey.currentContext!);
            Navigator.pop(navigatorKey.currentContext!);
          } else {
            Navigator.pop(navigatorKey.currentContext!);
          }
        } else {}

        Preference.setShowIntro(false);
        //--------
        var tags = {
          'email': "${_user?.email}",
          'phone': "${_user?.phoneCode} ${_user?.phone}"
        };

        // OneSignal.User.addTags(tags);
        //--------

        //CHECK MEMBERSHIP
        if ((_user?.membership?.purchased != null &&
                _user?.membership?.purchased == 0) &&
            withLoginMembership) {
          Utils().showLog("----navigating from login verify---");
          // Navigator.push(
          //   navigatorKey.currentContext!,
          //   createRoute(
          //     NewMembership(cancel: true),
          //   ),
          // );
          closeKeyboard();
          if (_user?.showBlackFriday == true) {
            Navigator.push(
              navigatorKey.currentContext!,
              createRoute(
                const BlackFridayMembershipIndex(cancel: true),
              ),
            );
          } else if (_user?.christmasMembership == true) {
            Navigator.push(
              navigatorKey.currentContext!,
              createRoute(
                const ChristmasMembershipIndex(cancel: true),
              ),
            );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              createRoute(
                const NewMembership(cancel: true),
              ),
            );
          }
        }
        notifyListeners();
        configureRevenueCatAttribute();
        _extra = (response.extra is Extra ? response.extra as Extra : null);

        if (_user?.signupStatus != null) {
          AmplitudeService.logLoginSignUpEvent(
            isRegistered: (_user?.signupStatus ?? false) ? 1 : 0,
          );
        }
      } else {
        // showErrorMessage(message: response.message);
        popUpAlert(
            message: "${response.message}",
            title: "Alert",
            icon: Images.alertPopGIF);
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

  AdvertiserRes? _advertiserRes;
  AdvertiserRes? get advertiserRes => _advertiserRes;

  callSliderTrendingAPI() {
    HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();
    provider.getHomeSlider();
    // provider.getHomeTrendingData();
  }

  void callAdvertiserAPI() async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.proxyAdvertiser,
        type: RequestType.get,
        checkAppUpdate: false,
      );
      if (response.status) {
        _advertiserRes = advertiserResFromJson(jsonEncode(response.data));
      } else {
        _advertiserRes = null;
      }
      notifyListeners();
    } catch (e) {
      _advertiserRes = null;
      notifyListeners();
    }
  }
}
