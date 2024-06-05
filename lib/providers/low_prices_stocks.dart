import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/low_price_stocks_tab.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../modals/low_price_stocks_res.dart';

class LowPriceStocksProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status _tabStatus = Status.ideal;
  int selectedIndex = 0;
  int _typeIndex = 0;
  int get typeIndex => _typeIndex;

  List<LowPriceStocksTabRes>? _tabs;

  List<LowPriceStocksTabRes>? get tabs => _tabs;

  List<LowPriceStocksRes>? _data;
  List<LowPriceStocksRes>? get data => _data;

  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
  bool get tabLoading => _tabStatus == Status.loading;

  String? title;
  String? subTitle;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  // bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
  int _page = 1;
  // int _pageDown = 1;
  Extra? _extraUp;
  Extra? get extraUp => _extraUp;
  // Extra? _extraDown;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStocksOnSaleData(status) {
    _status = status;
    notifyListeners();
  }

  void setTabStatus(status) {
    _tabStatus = status;
    notifyListeners();
  }

  void tabChange(index) {
    if (tabs?[index].name == "Stocks On Sale") {
      if (selectedIndex != index) {
        selectedIndex = index;
        notifyListeners();
        getLowPriceData(type: 1);
      }
      return;
    } else {
      if (selectedIndex != index) {
        selectedIndex = index;
        notifyListeners();
        getLowPriceData(type: 0);
      }
    }
  }

  Future onRefresh() async {
    getTabsData();
  }

  Future getTabsData({showProgress = false}) async {
    _tabs == null;
    setTabStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.lowPricesTab,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
      );
      if (response.status) {
        _tabs = lowPriceStocksTabResFromJson(jsonEncode(response.data));
        if (_tabs != null) {
          getLowPriceData(type: 0);
        }
      } else {
        _error = response.message;
        _tabs = null;
        // showErrorMessage(message: response.message);
      }
      setTabStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      _tabs = null;

      Utils().showLog(e.toString());
      setTabStatus(Status.loaded);
    }
  }

  // Future getLowPriceData({showProgress = false}) async {
  //   setStatus(Status.loading);

  //   try {
  //     Map request = {
  //       "token":
  //           navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //       "slug": _tabs?[selectedIndex].key,
  //     };

  //     ApiResponse response = await apiRequest(
  //       url: Apis.lowPricesStocks,
  //       request: request,
  //       showProgress: showProgress,
  //     );

  //     if (response.status) {
  //       _error = null;
  //       _data = lowPriceStocksResFromJson(jsonEncode(response.data));
  //       title = response.extra?.title;
  //       subTitle = response.extra?.subTitle;
  //     } else {
  //       _data = null;
  //       _error = response.message;
  //     }

  //     setStatus(Status.loaded);
  //   } catch (e) {
  //     _data = null;
  //     Utils().showLog(e.toString());

  //     setStatus(Status.loaded);
  //   }
  // }

  Future getLowPriceData({loadMore = false, type}) async {
    _typeIndex = type ?? typeIndex;
    notifyListeners();

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
        if (typeIndex == 0) "slug": _tabs?[selectedIndex].key,
        "page": "$_page"
      };

      ApiResponse response = await apiRequest(
        url: typeIndex == 1 ? Apis.saleOnStocks : Apis.lowPricesStocks,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = lowPriceStocksResFromJson(jsonEncode(response.data));
          _extraUp = response.extra is Extra ? response.extra : null;
          title = response.extra?.title;
          subTitle = response.extra?.subTitle;
        } else {
          _data?.addAll(lowPriceStocksResFromJson(jsonEncode(response.data)));
          notifyListeners();
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
