// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/api/apis.dart';
// import 'package:stocks_news_new/modals/most_active_stocks_res.dart';
// import 'package:stocks_news_new/providers/auth_provider_base.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// class MostActiveProvider extends ChangeNotifier with AuthProviderBase {
//   Status _status = Status.ideal;
//   // ************* GAP DOWN **************** //
//   String? _error;
//   int _page = 1;
//   Extra? _extraUp;
//   List<MostActiveStocksRes>? _data;

//   List<MostActiveStocksRes>? get data => _data;
//   List<MostActiveStocksRes>? _dataMostVolatile;

//   List<MostActiveStocksRes>? get dataMostVolatile => _dataMostVolatile;
//   List<MostActiveStocksRes>? _dataUnusualTradingVolume;

//   List<MostActiveStocksRes>? get dataUnusualTradingVolume =>
//       _dataUnusualTradingVolume;
//   Extra? get extraUp => _extraUp;
//   bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
//   String? get error => _error ?? Const.errSomethingWrong;
//   bool get isLoading => _status == Status.loading;

//   // ************* GAP DOWN **************** //
//   String? _errorDown;
//   int _pageDown = 1;
//   // int? _totalPageDown;
//   Extra? _extraDown;

//   bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
//   String? get errorDown => _errorDown ?? Const.errSomethingWrong;
//   bool get isLoadingDown => _status == Status.loading;
//   Status _statusMostActive = Status.ideal;
//   Status get statusMostActive => _statusMostActive;
//   bool get isLoadingMostActive => _statusMostActive == Status.loading;
//   int get openIndexMostActive => _openIndexMostActive;
//   int _openIndexMostActive = -1;
//   int _openIndex = -1;

//   int get openIndex => _openIndex;

//   void setStatus(status) {
//     _status = status;
//     notifyListeners();
//   }

//   void setStatusMostActive(status) {
//     _statusMostActive = status;
//     notifyListeners();
//   }

//   void setOpenIndex(index) {
//     _openIndex = index;
//     notifyListeners();
//   }

//   void setOpenIndexMostActive(index) {
//     _openIndexMostActive = index;
//     notifyListeners();
//   }

//   Future getMostActiveData({loadMore = false, type = 1}) async {
//     if (loadMore) {
//       _page++;
//       setStatus(Status.loadingMore);
//     } else {
//       _page = 1;
//       setStatus(Status.loading);
//     }
//     try {
//       Map request = {"page": "$_page"};

//       ApiResponse response = await apiRequest(
//         url: type == 1
//             ? Apis.mostActiveStocks
//             : type == 2
//                 ? Apis.mostVoliatileStocks
//                 : Apis.mostVolumeStocks,
//         request: request,
//         showProgress: false,
//       );

//       if (response.status) {
//         _error = null;
//         if (_page == 1) {
//           type == 1
//               ? _data = mostActiveStocksFromJson(jsonEncode(response.data))
//               : type == 2
//                   ? _dataMostVolatile =
//                       mostActiveStocksFromJson(jsonEncode(response.data))
//                   : _dataUnusualTradingVolume =
//                       mostActiveStocksFromJson(jsonEncode(response.data));

//           _extraUp = response.extra is Extra ? response.extra : null;
//         } else {
//           type == 1
//               ? _data
//                   ?.addAll(mostActiveStocksFromJson(jsonEncode(response.data)))
//               : type == 2
//                   ? _dataMostVolatile?.addAll(
//                       mostActiveStocksFromJson(jsonEncode(response.data)))
//                   : _dataUnusualTradingVolume?.addAll(
//                       mostActiveStocksFromJson(jsonEncode(response.data)));
//         }
//       } else {
//         if (_page == 1) {
//           type == 1
//               ? _data = null
//               : type == 2
//                   ? _dataMostVolatile = null
//                   : _dataUnusualTradingVolume = null;
//           _error = response.message;
//           // showErrorMessage(message: response.message);
//         }
//       }
//       setStatus(Status.loaded);
//     } catch (e) {
//       type == 1
//           ? _data = null
//           : type == 2
//               ? _dataMostVolatile = null
//               : _dataUnusualTradingVolume = null;
//       Utils().showLog(e.toString());
//       setStatus(Status.loaded);
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/most_active_stocks_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class MostActiveProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;

  String? _error;
  int _page = 1;
  Extra? _extraUp;
  List<MostActiveStocksRes>? _data;

  List<MostActiveStocksRes>? get data => _data;

  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;

  int get openIndex => _openIndex;
  int _openIndex = -1;
  FilteredParams? _filterParams;
  FilteredParams? get filterParams => _filterParams;

  void resetFilter() {
    _filterParams = null;
    _page = 1;
    notifyListeners();
  }

  void applyFilter(FilteredParams? params) {
    _filterParams = params;
    _page = 1;
    notifyListeners();
    getData();
  }

  void exchangeFilter(String item) {
    _filterParams!.exchange_name!.remove(item);
    if (_filterParams!.exchange_name!.isEmpty) {
      _filterParams!.exchange_name = null;
    }
    _page = 1;
    notifyListeners();
    getData();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future onRefresh() async {
    // getHighLowNegativeBetaStocks();
  }

  Future getData({loadMore = false, type = 1}) async {
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
        "exchange_name": _filterParams?.exchange_name?.join(",") ?? "",
        "price": _filterParams?.price ?? "",
        "industry": _filterParams?.industry ?? "",
        "market_cap": _filterParams?.market_cap ?? "",
        "beta": _filterParams?.beta ?? "",
        "dividend": _filterParams?.dividend ?? "",
        "isEtf": _filterParams?.isEtf ?? "",
        "isFund": _filterParams?.isFund ?? "",
        "isActivelyTrading": _filterParams?.isActivelyTrading ?? "",
        "sector": _filterParams?.sector ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.mostActiveStocks,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = mostActiveStocksFromJson(jsonEncode(response.data));

          _extraUp = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(mostActiveStocksFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _data = null;
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
