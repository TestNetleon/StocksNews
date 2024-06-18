// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/api/apis.dart';
// import 'package:stocks_news_new/modals/gap_up_res.dart';
// import 'package:stocks_news_new/providers/auth_provider_base.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// import '../modals/penny_stocks.dart';

// class PennyStocksProvider extends ChangeNotifier with AuthProviderBase {
//   int _openIndex = -1;
//   int? get openIndex => _openIndex;

//   Status _status = Status.ideal;
//   // ************* Most Active **************** //
//   String? _error;
//   int _page = 1;
//   List<PennyStocksRes>? _data;

//   List<PennyStocksRes>? get data => _data;
//   List<PennyStocksRes>? _dataTopTodays;

//   List<PennyStocksRes>? get dataTopTodays => _dataTopTodays;
//   bool get canLoadMore => _page < (extra?.totalPages ?? 0);
//   String? get error => _error ?? Const.errSomethingWrong;
//   bool get isLoading => _status == Status.loading || _status == Status.ideal;
//   Extra? _extraData;
//   Extra? get extra => _extraData;

//   // ************* GAP DOWN **************** //
//   List<GapUpRes>? _dataDown;
//   String? _errorDown;
//   // int _pageDown = 1;

//   List<GapUpRes>? get dataDown => _dataDown;
//   // bool get canLoadMoreDown => _pageDown < (0 ?? 1);
//   String? get errorDown => _errorDown ?? Const.errSomethingWrong;

//   void setStatus(status) {
//     _status = status;
//     notifyListeners();
//   }

//   void setOpenIndex(index) {
//     _openIndex = index;
//     notifyListeners();
//   }
//   // void setStatusLosers(status) {
//   //   _status = status;
//   //   notifyListeners();
//   // }
//   // void setOpenIndex(index) {
//   //   // _openIndex = index;
//   //   notifyListeners();
//   // }
//   // void setOpenIndexLosers(index) {
//   //   // _openIndexLosers = index;
//   //   notifyListeners();
//   // }

//   Future getData({showProgress = false, loadMore = false, type = 0}) async {
//     if (loadMore) {
//       _page++;
//       setStatus(Status.loadingMore);
//     } else {
//       _openIndex = -1;
//       _page = 1;
//       setStatus(Status.loading);
//     }
//     try {
// Map request = {
//   "token":
//       navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
//   "page": "$_page"
// };

//       ApiResponse response = await apiRequest(
//         url: type == 1
//             ? Apis.mostActivePenny
//             : type == 2
//                 ? Apis.mostActivePenny
//                 : type == 3
//                     ? Apis.topPennyStocksToday
//                     : Apis.mostActivePenny,
//         request: request,
//         showProgress: false,
//       );

//       if (response.status) {
//         _extraData = response.extra;
//         _error = null;
//         if (_page == 1) {
//           type == 1
//               ? _data = pennyStocksResFromJson(jsonEncode(response.data))
//               : type == 2
//                   ? _data = pennyStocksResFromJson(jsonEncode(response.data))
//                   : type == 3
//                       ? _dataTopTodays =
//                           pennyStocksResFromJson(jsonEncode(response.data))
//                       : _data =
//                           pennyStocksResFromJson(jsonEncode(response.data));
//         } else {
//           type == 1
//               ? _data?.addAll(pennyStocksResFromJson(jsonEncode(response.data)))
//               : type == 2
//                   ? _data?.addAll(
//                       pennyStocksResFromJson(jsonEncode(response.data)))
//                   : type == 3
//                       ? _dataTopTodays?.addAll(
//                           pennyStocksResFromJson(jsonEncode(response.data)))
//                       : _data?.addAll(
//                           pennyStocksResFromJson(jsonEncode(response.data)));
//         }
//       } else {
//         if (_page == 1) {
//           type == 1
//               ? _data = null
//               : type == 2
//                   ? _data = null
//                   : type == 3
//                       ? _dataTopTodays = null
//                       : _data = null;
//           _error = response.message;
//           // showErrorMessage(message: response.message);
//         }
//       }
//       setStatus(Status.loaded);
//     } catch (e) {
//       type == 1
//           ? _data = null
//           : type == 2
//               ? _data = null
//               : type == 3
//                   ? _dataTopTodays = null
//                   : _data = null;
//       Utils().showLog(e.toString());
//       setStatus(Status.loaded);
//     }
//   }

//   Future logoutUser(request) async {
//     try {
//       ApiResponse res = await apiRequest(
//         url: Apis.logout,
//         request: request,
//         showProgress: true,
//       );
//       if (res.status) {
//         setStatus(Status.loaded);
//         handleSessionOut();
//         // showErrorMessage(message: res.message, type: SnackbarType.info);
//       } else {
//         setStatus(Status.loaded);
//         // showErrorMessage(
//         //   message: res.message,
//         // );
//       }
//     } catch (e) {
//       setStatus(Status.loaded);
//       // showErrorMessage(
//       //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
//       // );
//     }
//   }
// }
// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/penny_stocks.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TopTodayPennyStocksProviders extends ChangeNotifier
    with AuthProviderBase {
  Status _status = Status.ideal;

  String? _error;
  int _page = 1;
  Extra? _extra;
  List<PennyStocksRes>? _data;

  List<PennyStocksRes>? get data => _data;

  Extra? get extra => _extra;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

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

  void applySorting(String sortingKey) {
    _filterParams?.sorting = sortingKey;
    _page = 1;
    notifyListeners();
    Utils()
        .showLog("Sorting Data ===   $sortingKey   ${_filterParams?.sorting}");
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

  void sectorFilter(String item) {
    _filterParams!.sector!.remove(item);
    if (_filterParams!.sector!.isEmpty) {
      _filterParams!.sector = null;
    }
    _page = 1;

    notifyListeners();
    getData();
  }

  void industryFilter(String item) {
    _filterParams!.industry!.remove(item);
    if (_filterParams!.industry!.isEmpty) {
      _filterParams!.industry = null;
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
        "industry": _filterParams?.industry?.join(",") ?? "",
        "market_cap": _filterParams?.market_cap ?? "",
        "beta": _filterParams?.beta ?? "",
        "dividend": _filterParams?.dividend ?? "",
        "isEtf": _filterParams?.isEtf ?? "",
        "isFund": _filterParams?.isFund ?? "",
        "isActivelyTrading": _filterParams?.isActivelyTrading ?? "",
        "sector": _filterParams?.sector?.join(",") ?? "",
        "sortBy": _filterParams?.sorting ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.topPennyStocksToday,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = pennyStocksResFromJson(jsonEncode(response.data));
          _extra = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(pennyStocksResFromJson(jsonEncode(response.data)));
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
