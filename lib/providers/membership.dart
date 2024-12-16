// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
// import 'package:stocks_news_new/modals/plans_res.dart';
// import '../api/api_response.dart';
// import '../api/apis.dart';
// import '../modals/membership.dart';
// import '../modals/membership_success.dart';
// import '../modals/user_res.dart';
// import '../route/my_app.dart';
// import '../utils/constants.dart';
// import '../utils/utils.dart';
// import 'home_provider.dart';
// import 'user_provider.dart';

// class MembershipProvider extends ChangeNotifier {
//   String? _error;
//   Status _status = Status.ideal;
//   Status get status => _status;
//   bool get isLoading => _status == Status.loading || _status == Status.ideal;
//   String? get error => _error ?? Const.errSomethingWrong;
//   Extra? _extra;
//   Extra? get extra => _extra;

//   List<MembershipRes>? _data;
//   List<MembershipRes>? get data => _data;

//   MembershipInfoRes? _membershipInfoRes;
//   MembershipInfoRes? get membershipInfoRes => _membershipInfoRes;

//   PlansRes? _plansRes;
//   PlansRes? get plansRes => _plansRes;

//   MembershipSuccess? _success;
//   MembershipSuccess? get success => _success;

//   int _faqOpenIndex = -1;
//   int get faqOpenIndex => _faqOpenIndex;

//   void setOpenIndex(index) {
//     _faqOpenIndex = index;
//     notifyListeners();
//   }

//   void setStatus(status) {
//     _status = status;
//     notifyListeners();
//   }

//   Future getData() async {
//     setStatus(Status.loading);

//     try {
//       Map request = {
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
//       };

//       ApiResponse response = await apiRequest(
//         url: Apis.membership,
//         request: request,
//         showProgress: false,
//       );
//       if (response.status) {
//         _data = membershipResFromJson(jsonEncode(response.data));

//         _extra = (response.extra is Extra ? response.extra as Extra : null);
//       } else {
//         _data = null;
//         _error = response.message;
//         _extra = null;
//       }
//       setStatus(Status.loaded);
//     } catch (e) {
//       _data = null;
//       _extra = null;
//       _error = Const.errSomethingWrong;
//       Utils().showLog(e.toString());
//       setStatus(Status.loaded);
//     }
//   }

//   Future getMembershipSuccess({
//     bool isMembership = false,
//     bool sendTrack = false,
//   }) async {
//     notifyListeners();
//     try {
//       FormData request = FormData.fromMap(
//         sendTrack
//             ? {
//                 "token": navigatorKey.currentContext!
//                         .read<UserProvider>()
//                         .user
//                         ?.token ??
//                     "",
//                 "membership": "$isMembership",
//                 // "track_membership_link": memTrack ? "1" : "",
//                 'distributor_code': memCODE ?? '',
//               }
//             : {
//                 "token": navigatorKey.currentContext!
//                         .read<UserProvider>()
//                         .user
//                         ?.token ??
//                     "",
//                 "membership": "$isMembership",
//               },
//       );
//       ApiResponse response = await apiRequest(
//         url: Apis.membershipSuccess,
//         formData: request,
//         showProgress: false,
//       );
//       if (response.status) {
//         _success = membershipSuccessFromJson(jsonEncode(response.data));
//       } else {
//         //
//         _success = null;
//       }
//       notifyListeners();
//     } catch (e) {
//       _success = null;
//       Utils().showLog(e.toString());
//       notifyListeners();
//     }
//   }

//   Future getPlansDetail() async {
//     setStatus(Status.loading);

//     try {
//       FormData request = FormData.fromMap({
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
//         "platform": Platform.operatingSystem,
//       });
//       ApiResponse response = await apiRequest(
//         url: Apis.plansDetail,
//         formData: request,
//         showProgress: true,
//       );
//       if (response.status) {
//         _plansRes = plansResFromJson(jsonEncode(response.data));
//       } else {
//         _plansRes = null;
//       }
//       setStatus(Status.loaded);
//     } catch (e) {
//       _plansRes = null;
//       Utils().showLog(e.toString());
//       setStatus(Status.loaded);
//     }
//   }

//   selectedIndex(index) {
//     Utils().showLog("Selected index $index");
//     for (int i = 0; i < (_membershipInfoRes?.plans?.length ?? 0); i++) {
//       _membershipInfoRes?.plans?[i].selected = false;
//     }
//     _membershipInfoRes?.plans?[index].selected = true;
//     notifyListeners();
//   }

//   Future getMembershipInfo({
//     String? inAppMsgId,
//     String? notificationId,
//     bool showProgress = false,
//   }) async {
//     setStatus(Status.loading);
//     UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
//     try {
//       Map request = {
//         "token": provider.user?.token ?? "",
//       };
//       if (inAppMsgId != null) {
//         request.addAll({"in_app_id": inAppMsgId});
//       }
//       if (notificationId != null) {
//         request.addAll({"notification_id": notificationId});
//       }
//       if (memCODE != null && memCODE != '') {
//         request['distributor_code'] = memCODE;
//       }
//       ApiResponse response = await apiRequest(
//         url: Apis.membershipInfo,
//         request: request,
//         showProgress: showProgress,
//       );

//       //  setStatus(Status.loaded);
//       if (response.status) {
//         _membershipInfoRes = membershipInfoResFromJson(
//           jsonEncode(response.data),
//         );

//         //DEBUG ONLY
//         // if (kDebugMode) {
//         //   if (provider.user != null) {
//         //     _membershipInfoRes?.plans?[0].activeText = "Your current plan";
//         //   }
//         // }

//         RevenueCatKeyRes? keys = navigatorKey.currentContext!
//             .read<HomeProvider>()
//             .extra
//             ?.revenueCatKeys;
//         UserRes? userRes =
//             navigatorKey.currentContext?.read<UserProvider>().user;
//         Utils().showLog("${userRes?.userId}");

//         PurchasesConfiguration? configuration;
//         if (Platform.isAndroid) {
//           configuration =
//               PurchasesConfiguration(keys?.playStore ?? ApiKeys.androidKey)
//                 ..appUserID = userRes?.userId ?? "";
//         } else if (Platform.isIOS) {
//           Utils().showLog("---Platform.isIOS-----");
//           configuration =
//               PurchasesConfiguration(keys?.appStore ?? ApiKeys.iosKey)
//                 ..appUserID = userRes?.userId ?? "";
//         }

//         try {
//           if (configuration != null) {
//             Utils().showLog("--integrating configuration----");
//             await Purchases.configure(configuration);
//             FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//             String? firebaseAppInstanceId = await analytics.appInstanceId;
//             if (firebaseAppInstanceId != null && firebaseAppInstanceId != '') {
//               Purchases.setFirebaseAppInstanceId(firebaseAppInstanceId);
//               Utils().showLog('Set app instance ID => $firebaseAppInstanceId');
//             }
//           }
//           Offerings? offerings;
//           offerings = await Purchases.getOfferings();
//           for (var i = 0; i < (_membershipInfoRes?.plans?.length ?? 0); i++) {
//             Offering? offering = offerings
//                 .getOffering(_membershipInfoRes?.plans?[i].type ?? 'access');

//             if (offering != null) {
//               // List<int> utf8Bytes = utf8.encode(
//               //     offering.availablePackages.first.storeProduct.priceString);

//               // String decodedString = utf8.decode(utf8Bytes);
//               // print('Decoded String: $decodedString');

//               // String price = offering
//               //     .availablePackages.first.storeProduct.priceString
//               //     .replaceAll(RegExp(r'\s+'), '');

//               Utils().showLog(
//                   "--Pricing => ${offering.availablePackages.first.storeProduct.priceString}");

//               _membershipInfoRes?.plans?[i].price =
//                   offering.availablePackages.first.storeProduct.priceString;
//             } else {
//               //
//               Utils().showLog("offering null");
//             }
//           }
//         } catch (e) {
//           Utils().showLog("EXCEPTION $e");
//         }

//         _extra = (response.extra is Extra ? response.extra as Extra : null);
//       } else {
//         _membershipInfoRes = null;
//         _error = response.message;
//         _extra = null;
//       }
//       setStatus(Status.loaded);
//     } catch (e) {
//       _membershipInfoRes = null;
//       _extra = null;
//       _error = Const.errSomethingWrong;
//       Utils().showLog(e.toString());
//       setStatus(Status.loaded);
//     }
//   }
// }

// String formatPrice(double amount, String locale) {
//   // Using simpleCurrency to get the correct symbol for the locale
//   final format = NumberFormat.simpleCurrency(locale: locale);
//   Utils().showLog("--!!!${format.format(amount)}");
//   return format.format(amount);
// }

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/modals/plans_res.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../modals/membership.dart';
import '../modals/membership_success.dart';
import '../modals/user_res.dart';
import '../routes/my_app.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'home_provider.dart';
import 'user_provider.dart';

class MembershipProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
  Extra? _extra;
  Extra? get extra => _extra;

  List<MembershipRes>? _data;
  List<MembershipRes>? get data => _data;

  MembershipInfoRes? _membershipInfoRes;
  MembershipInfoRes? get membershipInfoRes => _membershipInfoRes;

  PlansRes? _plansRes;
  PlansRes? get plansRes => _plansRes;

  MembershipSuccess? _success;
  MembershipSuccess? get success => _success;

  int _faqOpenIndex = -1;
  int get faqOpenIndex => _faqOpenIndex;

  void setOpenIndex(index) {
    _faqOpenIndex = index;
    notifyListeners();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

//Membership Transaction
  int _page = 1;
  bool get canLoadMore => _page <= (_extra?.totalPages ?? 1);

  Future getData({bool loadMore = false}) async {
    // setStatus(Status.loading);

    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        'page': '$_page',
      };

      ApiResponse response = await apiRequest(
        url: Apis.blackFridayTransaction,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        if (_page == 1) {
          _data = membershipResFromJson(jsonEncode(response.data));
          _extra = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(membershipResFromJson(jsonEncode(response.data)));
          notifyListeners();
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _extra = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getMembershipSuccess({
    bool isMembership = false,
    bool sendTrack = false,
  }) async {
    notifyListeners();
    try {
      FormData request = FormData.fromMap(
        sendTrack
            ? {
                "token": navigatorKey.currentContext!
                        .read<UserProvider>()
                        .user
                        ?.token ??
                    "",
                "membership": "$isMembership",
                'distributor_code': memCODE ?? '',
              }
            : {
                "token": navigatorKey.currentContext!
                        .read<UserProvider>()
                        .user
                        ?.token ??
                    "",
                "membership": "$isMembership",
              },
      );
      ApiResponse response = await apiRequest(
        url: Apis.membershipSuccess,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _success = membershipSuccessFromJson(jsonEncode(response.data));
      } else {
        //
        _success = null;
      }
      notifyListeners();
    } catch (e) {
      _success = null;
      Utils().showLog(e.toString());
      notifyListeners();
    }
  }

  // Future getPlansDetail() async {
  //   setStatus(Status.loading);
  //   try {
  //     FormData request = FormData.fromMap({
  //       "token":
  //           navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //       "platform": Platform.operatingSystem,
  //     });
  //     ApiResponse response = await apiRequest(
  //       url: Apis.plansDetail,
  //       formData: request,
  //       showProgress: true,
  //     );
  //     if (response.status) {
  //       _plansRes = plansResFromJson(jsonEncode(response.data));
  //     } else {
  //       _plansRes = null;
  //     }
  //     setStatus(Status.loaded);
  //   } catch (e) {
  //     _plansRes = null;
  //     Utils().showLog(e.toString());
  //     setStatus(Status.loaded);
  //   }
  // }

  selectedIndex(index) {
    Utils().showLog("Selected index $index");
    for (int i = 0; i < (_membershipInfoRes?.plans?.length ?? 0); i++) {
      _membershipInfoRes?.plans?[i].selected = false;
    }
    _membershipInfoRes?.plans?[index].selected = true;
    notifyListeners();
  }

  Future getMembershipInfo({
    String? inAppMsgId,
    String? notificationId,
    bool showProgress = false,
  }) async {
    setStatus(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId});
      }
      if (notificationId != null) {
        request.addAll({"notification_id": notificationId});
      }
      if (memCODE != null && memCODE != '') {
        request['distributor_code'] = memCODE;
      }
      ApiResponse response = await apiRequest(
        url: Apis.membershipInfo,
        request: request,
        showProgress: showProgress,
      );

      //  setStatus(Status.loaded);
      if (response.status) {
        _membershipInfoRes = membershipInfoResFromJson(
          jsonEncode(response.data),
        );

        //DEBUG ONLY
        // if (kDebugMode) {
        //   if (provider.user != null) {
        //     _membershipInfoRes?.plans?[0].activeText = "Your current plan";
        //   }
        // }

        RevenueCatKeyRes? keys = navigatorKey.currentContext!
            .read<HomeProvider>()
            .extra
            ?.revenueCatKeys;
        UserRes? userRes =
            navigatorKey.currentContext?.read<UserProvider>().user;
        Utils().showLog("${userRes?.userId}");

        PurchasesConfiguration? configuration;
        if (Platform.isAndroid) {
          configuration =
              PurchasesConfiguration(keys?.playStore ?? ApiKeys.androidKey)
                ..appUserID = userRes?.userId ?? "";
        } else if (Platform.isIOS) {
          Utils().showLog("---Platform.isIOS-----");
          configuration =
              PurchasesConfiguration(keys?.appStore ?? ApiKeys.iosKey)
                ..appUserID = userRes?.userId ?? "";
        }

        try {
          if (configuration != null) {
            Utils().showLog("--integrating configuration----");
            await Purchases.configure(configuration);
            FirebaseAnalytics analytics = FirebaseAnalytics.instance;
            String? firebaseAppInstanceId = await analytics.appInstanceId;
            if (firebaseAppInstanceId != null && firebaseAppInstanceId != '') {
              Purchases.setFirebaseAppInstanceId(firebaseAppInstanceId);
              Utils().showLog('Set app instance ID => $firebaseAppInstanceId');
            }
          }
          Offerings? offerings;
          offerings = await Purchases.getOfferings();
          for (var i = 0; i < (_membershipInfoRes?.plans?.length ?? 0); i++) {
            Offering? offering = offerings
                .getOffering(_membershipInfoRes?.plans?[i].type ?? 'access');

            if (offering != null) {
              // List<int> utf8Bytes = utf8.encode(
              //     offering.availablePackages.first.storeProduct.priceString);

              // String decodedString = utf8.decode(utf8Bytes);
              // print('Decoded String: $decodedString');

              // String price = offering
              //     .availablePackages.first.storeProduct.priceString
              //     .replaceAll(RegExp(r'\s+'), '');

              Utils().showLog(
                  "--Pricing => ${offering.availablePackages.first.storeProduct.priceString}");

              _membershipInfoRes?.plans?[i].price =
                  offering.availablePackages.first.storeProduct.priceString;
            } else {
              //
              Utils().showLog("offering null");
            }
          }
        } catch (e) {
          Utils().showLog("EXCEPTION $e");
        }

        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _membershipInfoRes = null;
        _error = response.message;
        _extra = null;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _membershipInfoRes = null;
      _extra = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

String formatPrice(double amount, String locale) {
  // Using simpleCurrency to get the correct symbol for the locale
  final format = NumberFormat.simpleCurrency(locale: locale);
  Utils().showLog("--!!!${format.format(amount)}");
  return format.format(amount);
}
