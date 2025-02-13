import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class FilterProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;

  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;

  FiltersData? _data;
  FiltersData? get data => _data;
  Extra? _extra;
  Extra? get extra => _extra;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getFilterData() async {
    setStatus(Status.loading);
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.filters,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        _data = filtersFromJson(jsonEncode(response.data));
        _extra = response.extra is Extra ? response.extra : null;
      } else {
        _data = null;
        _error = response.message;
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

class FilteredParams {
  FiltersDataItem? exchange_name;
  FiltersDataItem? sector;
  FiltersDataItem? industry;
  FiltersDataItem? analystConsensusParams;
  FiltersDataItem? marketRanks;
  String price;
  FiltersDataItem? market_cap;
  FiltersDataItem? timePeriod;
  String beta;
  String dividend;
  String isEtf;
  String isFund;
  String isActivelyTrading;
  String sorting;

  FilteredParams({
    this.exchange_name,
    this.price = "",
    this.industry,
    this.market_cap,
    this.analystConsensusParams,
    this.marketRanks,
    this.timePeriod,
    this.beta = "",
    this.dividend = "",
    this.isEtf = "",
    this.isFund = "",
    this.isActivelyTrading = "",
    this.sector,
    this.sorting = "",
  });
}
