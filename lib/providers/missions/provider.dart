import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../modals/missions/missions.dart';
import '../../routes/my_app.dart';
import '../../screens/animation/coin_animation.dart';
import '../../utils/constants.dart';

class MissionProvider extends ChangeNotifier {
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  Extra? _extra;
  Extra? get extra => _extra;

  List<ClaimPointsRes>? _data;
  List<ClaimPointsRes>? get data => _data;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getMissions({showProgress = false}) async {
    if (showProgress) {
      notifyListeners();
    } else {
      setStatus(Status.loading);
    }
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
    };
    try {
      if (!showProgress) _data = null;

      ApiResponse response = await apiRequest(
        url: Apis.pointClaimList,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _data = claimPointsResFromJson(jsonEncode(response.data));
        _error = null;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
        _extra = null;
      }
      if (showProgress) {
        notifyListeners();
      } else {
        setStatus(Status.loaded);
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      _extra = null;
      if (showProgress) {
        notifyListeners();
      } else {
        setStatus(Status.loaded);
      }
    }
  }

  // Claim Points
  Future claimPoints({
    String? type,
    num? points,
  }) async {
    notifyListeners();

    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "type": type ?? "",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.pointsClaim,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        showDialog(
          barrierDismissible: false,
          barrierColor: ThemeColors.background.withOpacity(0.6),
          useSafeArea: true,
          context: navigatorKey.currentContext!,
          builder: (context) {
            return CoinAnimationWidget(
              data: CongoClaimRes(
                points: points,
                subtitle: response.message,
              ),
            );
          },
        );
        getMissions(showProgress: true);
      } else {
        popUpAlert(
          title: "Alert",
          message: response.message,
          icon: Images.alertPopGIF,
        );
      }

      notifyListeners();
    } catch (e) {
      popUpAlert(
        title: "Alert",
        message: Const.errSomethingWrong,
        icon: Images.alertPopGIF,
      );
      notifyListeners();
    }
  }
}
