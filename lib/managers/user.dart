import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/blogs.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/managers/news.dart';
import 'package:stocks_news_new/managers/search.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/appsFlyer/service.dart';
import 'package:stocks_news_new/socket/socket.dart';
import 'package:stocks_news_new/ui/account/auth/login.dart';
import 'package:stocks_news_new/ui/account/error/apple_login.dart';
import 'package:stocks_news_new/ui/account/update/index.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/tabs/more/alerts/index.dart';
import 'package:stocks_news_new/ui/tabs/more/articles/index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/index.dart';
import 'package:stocks_news_new/ui/tabs/more/faq/index.dart';
import 'package:stocks_news_new/ui/tabs/more/feedback/index.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/front/index.dart';
import 'package:stocks_news_new/ui/tabs/more/notificationSettings/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/joinRefer/index.dart';
import 'package:stocks_news_new/ui/tabs/more/watchlist/index.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../api/image_service.dart';
import '../database/preference.dart';
import '../models/delete.dart';
import '../service/amplitude/service.dart';
import '../service/braze/service.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

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
    shareUrl = user.referralUrl;
    Preference.saveUser(_user);
    updateShareUrl();
    notifyListeners();
  }

  notificationSaw(value) {
    _user?.seenNotification = value;
    notifyListeners();
  }

  Future updateShareUrl() async {
    if (shareUrl == null) {
      AppsFlyerService.instance.createUserInvitationLink();
    }
    // shareUri ??= await DynamicLinkService.instance.getDynamicLink();
  }

  Future<bool> checkForUser() async {
    _user = null;
    final UserRes? tempUser = await Preference.getUser();
    if (tempUser != null) {
      _user = tempUser;
      shareUrl = _user?.referralUrl;
      notifyListeners();
    }
    return _user != null;
  }

  askLoginScreen() async {
    if (_user != null) {
      return;
    } else {
      await Navigator.push(
        navigatorKey.currentContext!,
        createRoute(AccountLoginIndex()),
      );
    }
  }

  referJoinScreen() async {
    // referLogin();
    await Navigator.push(
      navigatorKey.currentContext!,
      createRoute(JoinReferralIndex()),
    );
  }

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future navigateToPersonalDetail() async {
    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    await manager.askLoginScreen();
    if (manager.user == null) return;
    Navigator.pop(navigatorKey.currentContext!);
    await Navigator.pushNamed(
      navigatorKey.currentContext!,
      UpdatePersonalDetailIndex.path,
    );
  }

  Future navigateToAlerts() async {
    await askLoginScreen();
    if (_user == null) return;
    Navigator.pop(navigatorKey.currentContext!);
    await Navigator.pushNamed(
      navigatorKey.currentContext!,
      AlertIndex.path,
    );
  }

  Future navigateToWatchList() async {
    await askLoginScreen();
    if (_user == null) return;
    Navigator.pop(navigatorKey.currentContext!);
    await Navigator.pushNamed(
      navigatorKey.currentContext!,
      WatchListIndex.path,
    );
  }

  Future navigateToMySubscription({bool viewPlans = true}) async {
    await askLoginScreen();
    if (_user == null) return;
    SubscriptionManager manager =
        navigatorKey.currentContext!.read<SubscriptionManager>();
    await manager.startProcess(viewPlans: viewPlans);
  }

  void navigateToReferral() async {
    await askLoginScreen();
    if (_user == null) return;
    Navigator.pop(navigatorKey.currentContext!);
    await Navigator.pushNamed(
      navigatorKey.currentContext!,
      ReferralIndex.path,
    );
  }

  void navigateToBillionaires() async {
    await askLoginScreen();
    if (_user == null) return;
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(navigatorKey.currentContext!, BillionairesIndex.path);
  }

  void navigateToNotificationSettings() {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(
        navigatorKey.currentContext!, NotificationSettings.path);
  }

  void navigateToNews() {
    // Navigator.pop(navigatorKey.currentContext!);
    // Navigator.pushNamed(navigatorKey.currentContext!, CategoriesNewsIndex.path);
    Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path, arguments: {
      'index': 3,
    });
  }

  void navigateToBlogs() {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(navigatorKey.currentContext!, BlogsIndex.path);
  }

  void navigateToFaq() {
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(navigatorKey.currentContext!, FaqIndex.path);
  }

  Future navigateToHelpDesk() async {
    askLoginScreen();
    if (_user == null) return;
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(navigatorKey.currentContext!, HelpDeskIndex.path);
  }

  Future navigateToFeedback() async {
    askLoginScreen();
    if (_user == null) return;
    Navigator.pop(navigatorKey.currentContext!);
    Navigator.pushNamed(navigatorKey.currentContext!, FeedbackIndex.path);
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
            navigatorKey.currentContext!,
            Tabs.path,
          );
        } else {
          Utils().showLog('popping back');
          Navigator.pop(navigatorKey.currentContext!);
        }
      } else {
        ReferLogin? data = ReferLogin.fromJson(response.data);

        if (data.title != null && data.title != '') {
          BaseBottomSheet().bottomSheet(
            child: AppleLoginErrorIndex(
              extraRequest: extraRequest,
              data: data,
            ),
          );
        }
      }

      return ApiResponse(
        status: response.status,
      );
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
        Preference.clearReferral();
        BrazeService.brazeUserEvent();

        shareUrl = _user?.referralUrl;

        if (_user?.signupStatus != null) {
          AmplitudeService.instance.logLoginSignUpEvent(
            isRegistered: (_user?.signupStatus ?? false) ? 1 : 0,
          );
        }

        navigatorKey.currentContext!
            .read<MyHomeManager>()
            .getHomeData(fromAdvertiserID: true);
      }
      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );

      return ApiResponse(
        status: response.status,
        data: response.data,
        message: response.message,
      );
    } catch (e) {
      Utils().showLog('Error in $url');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      return ApiResponse(
        status: false,
        message: Const.errSomethingWrong,
      );
    } finally {
      setStatus(Status.loaded);
    }
  }

  bool _emailVerified = false;
  bool _phoneVerified = false;

  bool get emailVerified => _emailVerified;
  bool get phoneVerified => _phoneVerified;

  void onChangeEmail(String value) {
    if ((value == _user?.email) &&
        (_user?.email != null && _user?.email != '')) {
      _emailVerified = true;
    } else {
      _emailVerified = false;
    }
    notifyListeners();
  }

  void onChangePhone({
    required String phone,
    required String countryCode,
  }) {
    if (((phone == _user?.phone) &&
            (_user?.phone != null && _user?.phone != '')) &&
        ((countryCode == _user?.phoneCode) &&
            (_user?.phoneCode != null && _user?.phoneCode != ''))) {
      _phoneVerified = true;
    } else {
      _phoneVerified = false;
    }
    notifyListeners();
  }

//MARK: Update Profile
  Future updatePersonalDetails({
    File? image,
    String? name,
    String? displayName,
    String? phone,
    String? phoneCode,
    String? email,
    String? OTP,
    String? affiliateStatus,
    String? referralUrl,
    showProgress = true,
    showSuccess = true,
  }) async {
    MultipartFile? multipartFile;
    if (image != null) {
      Uint8List? result = await testCompressAndGetFile(image);

      if (result != null) {
        multipartFile = MultipartFile.fromBytes(
          result,
          filename: image.path.substring(image.path.lastIndexOf("/") + 1),
        );
      }
    }

    FormData request = FormData.fromMap({
      "token": _user?.token ?? '',
    });

    if (multipartFile != null) {
      request.files.add(MapEntry('image', multipartFile));
    }

    if (name != null && name.isNotEmpty) {
      request.fields.add(MapEntry('name', name));
    }
    if (displayName != null && displayName.isNotEmpty) {
      request.fields.add(MapEntry('display_name', displayName));
    }
    if (phone != null && phone.isNotEmpty) {
      request.fields.add(MapEntry('phone', phone));
    }
    if (affiliateStatus != null && affiliateStatus.isNotEmpty) {
      request.fields.add(MapEntry('affiliate_status', affiliateStatus));
    }
    if (phoneCode != null && phoneCode.isNotEmpty) {
      request.fields.add(MapEntry('phone_code', phoneCode));
    }
    if (referralUrl != null && referralUrl.isNotEmpty) {
      request.fields.add(MapEntry('referral_url', referralUrl));
    }
    if (email != null && email.isNotEmpty && OTP != null && OTP.isNotEmpty) {
      request.fields.add(MapEntry('email', email));
      request.fields.add(MapEntry('otp', OTP));
    }

    try {
      ApiResponse response = image != null
          ? await requestUploadImage(
              url: Apis.updateProfile,
              request: request,
            )
          : await apiRequest(
              url: Apis.updateProfile,
              formData: request,
              showProgress: showProgress,
            );
      if (response.status) {
        if (image != null) {
          updateUser(image: response.data);
          _user?.image = response.data;
        } else {
          updateUser(
            name: name,
            displayName: displayName,
            countryCode: phoneCode,
            phone: phone,
            email: email,
            affiliateStatus: int.tryParse(affiliateStatus ?? "0") ?? 0,
            referralUrl: referralUrl,
          );
        }
      }
      if (showSuccess) {
        TopSnackbar.show(
          message: response.message ?? '',
          type: response.status ? ToasterEnum.success : ToasterEnum.error,
        );
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog("Error $e");
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      return ApiResponse(status: false);
    } finally {
      notifyListeners();
    }
  }

//MARK: Check Email Exist
  Future checkEmailExist(String email) async {
    try {
      Map request = {
        "token": _user?.token ?? '',
        "email": email,
      };

      ApiResponse response = await apiRequest(
        url: Apis.checkEmailExist,
        request: request,
        showProgress: true,
      );

      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );

      return ApiResponse(status: response.status);
    } catch (e) {
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );

      return ApiResponse(status: false);
    }
  }

//MARK: Check Phone Exist
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

      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
      return ApiResponse(status: response.status);
    } catch (e) {
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      return ApiResponse(status: false);
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

//MARK: Update User
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
    if (image != null && image != '') _user?.image = image;
    if (email != null && email != '') {
      _user?.email = email;
      _emailVerified = true;
    }

    if (name != null && name != '') _user?.name = name;
    if (displayName != null && displayName != '') {
      _user?.displayName = displayName;
    }
    if (phone != null && phone != '') _user?.phone = phone;
    if (referralCode != null && referralCode != '') {
      _user?.referralCode = referralCode;
    }
    if (referralUrl != null && referralUrl != '') {
      _user?.referralUrl = referralUrl;
      shareUrl = referralUrl;
    }
    if (affiliateStatus != null) {
      _user?.affiliateStatus = affiliateStatus;
    }
    if (countryCode != null && countryCode != '') {
      _user?.phoneCode = countryCode;
      _phoneVerified = true;
    }
    notifyListeners();
    Preference.saveUser(_user);
  }

//MARK: Delete

  DeleteUserRes? _delete;
  DeleteUserRes? get delete => _delete;

  String? _errorDelete;
  String? get errorDelete => _errorDelete ?? Const.errSomethingWrong;

  Status _statusDelete = Status.ideal;
  Status get statusDelete => _statusDelete;

  bool get isLoadingDelete =>
      _statusDelete == Status.loading || _statusDelete == Status.ideal;

  setStatusDelete(status) {
    _statusDelete = status;
    notifyListeners();
  }

  Future deleteUser({String? text, reset = false}) async {
    if (reset) {
      _delete = null;
    }
    try {
      setStatusDelete(Status.loading);

      UserManager manager = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        "token": manager.user?.token ?? '',
      };
      if (text != null && text != '') {
        request['delete_request'] = text;
      }
      ApiResponse response = await apiRequest(
        url: Apis.deleteUser,
        request: request,
        showProgress: text != null && text != '',
      );
      if (text == null || text == '') {
        _delete = deleteUserResFromJson(jsonEncode(response.data));
      } else {
        clearUser();
        TopSnackbar.show(
          message: response.message ?? '',
          type: response.status ? ToasterEnum.success : ToasterEnum.error,
        );
      }
    } catch (e) {
      Utils().showLog('Error in ${Apis.deleteUser}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    } finally {
      setStatusDelete(Status.loaded);
    }
  }

  //MARK: Clear User
  clearUser({bool gotoOverview = false}) {
    Preference.logout();
    Preference.clearChecks();
    // try {
    //   Purchases.logOut();
    // } catch (e) {
    //   //
    // }

    _user = null;
    shareUrl = null;
    notifyListeners();
    MyHomeManager homeManager =
        navigatorKey.currentContext!.read<MyHomeManager>();

    // TODO:
    // SignalsManager signalsManager =
    //     navigatorKey.currentContext!.read<SignalsManager>();

    ToolsManager toolsManager =
        navigatorKey.currentContext!.read<ToolsManager>();

    SearchManager searchManager =
        navigatorKey.currentContext!.read<SearchManager>();

    NewsManager newsManager = navigatorKey.currentContext!.read<NewsManager>();

    BlogsManager blogsManager =
        navigatorKey.currentContext!.read<BlogsManager>();

    SDManager sdManager = navigatorKey.currentContext!.read<SDManager>();

    homeManager.clearAllData();
    // signalsManager.clearAllData();
    toolsManager.clearAllData();
    searchManager.clearAllData();
    newsManager.clearAllData();
    blogsManager.clearAllData();
    sdManager.clearAllData();

    if (gotoOverview) {
      //
    } else {
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Tabs()),
      );
    }
  }
}

//MARK: Ping
Future<void> pingApi(SocketEnum type) async {
  const url = 'https://api.stocks.news/v1/ping';
  UserRes? user = await Preference.getUser();
  String apiToken = '${user?.userId ?? ''}:${user?.token ?? ''}';
  String? fcmToken = await Preference.getFcmToken();
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'X-API-Token $apiToken',
  };

  final body = jsonEncode({
    'fcm_token': fcmToken ?? '',
    'page': type.name,
  });
  Utils().showLog('PING->  Headers: $headers');
  Utils().showLog('PING->  Body: $body');

  try {
    final response = await http
        .post(
          Uri.parse(url),
          headers: headers,
          body: body,
        )
        .timeout(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      Utils().showLog('PING->  Success: ${response.body}');
    } else {
      Utils()
          .showLog('PING->  Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    Utils().showLog('PING->  Exception: $e');
  }
}
