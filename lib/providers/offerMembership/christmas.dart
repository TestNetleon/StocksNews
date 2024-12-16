import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../modals/membership/membership_info_res.dart';
import '../../modals/user_res.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../home_provider.dart';
import '../user_provider.dart';

class ChristmasProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
  Extra? _extra;
  Extra? get extra => _extra;

  MembershipInfoRes? _membershipInfoRes;
  MembershipInfoRes? get membershipInfoRes => _membershipInfoRes;

  int _faqOpenIndex = -1;
  int get faqOpenIndex => _faqOpenIndex;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  selectedIndex(index) {
    Utils().showLog("Selected index $index");
    for (int i = 0; i < (_membershipInfoRes?.plans?.length ?? 0); i++) {
      _membershipInfoRes?.plans?[i].selected = false;
    }
    _membershipInfoRes?.plans?[index].selected = true;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _faqOpenIndex = index;
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
        url: Apis.christmasMembership,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _membershipInfoRes = membershipInfoResFromJson(
          jsonEncode(response.data),
        );

        RevenueCatKeyRes? keys = navigatorKey.currentContext!
            .read<HomeProvider>()
            .extra
            ?.revenueCatKeys;
        UserRes? userRes = provider.user;

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
              var availablePackage = offering.availablePackages.first;
              var priceString = availablePackage.storeProduct.priceString;

              var introductoryPrice =
                  availablePackage.storeProduct.introductoryPrice;

              // var purchaserInfo = await Purchases.getCustomerInfo();
              // bool isEligibleForIntroOffer = _isEligibleForIntroductoryPrice(
              //     purchaserInfo, _membershipInfoRes?.plans?[i].type ?? '');

              //use if wanna check eligibility && isEligibleForIntroOffer
              if (introductoryPrice != null) {
                priceString = introductoryPrice.priceString;
              } else {
                priceString =
                    offering.availablePackages.first.storeProduct.priceString;
              }

              _membershipInfoRes?.plans?[i].price = priceString;
            } else {
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

bool _isEligibleForIntroductoryPrice(CustomerInfo purchaserInfo, String type) {
  bool isNewUser = !purchaserInfo.entitlements.all.containsKey(type);

  return isNewUser;
}
