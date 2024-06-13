import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/congress_member_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class CongressionalDetailProvider extends ChangeNotifier with AuthProviderBase {
  CongressMemberRes? _data;
  CongressMemberRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  int _page = 1;
  int _openIndex = -1;

  bool get isLoading => _status == Status.loading;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

  int get openIndex => _openIndex;

  String? title;
  String? subTitle;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void reset() {
    _openIndex = -1;
    _data = null;
    _error = null;
    _extra = null;
    notifyListeners();
  }

  Future onRefresh({slug}) async {
    getData(slug: slug);
  }

  Future getData({
    showProgress = false,
    loadMore = false,
    required slug,
  }) async {
    _openIndex = -1;
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
        "page": "$_page",
        "slug": slug,
      };

      ApiResponse response = await apiRequest(
        url: Apis.congressMember,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );
      if (response.status) {
        _error = null;
        // canLoadMore = _page < (response.extra.totalPages ?? 1);
        _data = congressMemberResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        // if (_page == 1) {
        //   title = response.extra?.title;
        //   subTitle = response.extra?.subTitle;
        //   _data = congressMemberResFromJson(jsonEncode(response.data));
        //   _extra = (response.extra is Extra ? response.extra as Extra : null);
        // } else {
        //   List<CongressionalRes> parsedData = List<CongressionalRes>.from(
        //     (response.data as List).map((x) => CongressionalRes.fromJson(x)),
        //   );
        //   _data?.addAll(parsedData);
        // }
      } else {
        // if (_page == 1) {
        _error = response.message;
        _data = null;
        // }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
