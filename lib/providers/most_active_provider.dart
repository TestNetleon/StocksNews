// import 'dart:async';
// import 'dart:convert';
//

// import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/api/apis.dart';
// import 'package:stocks_news_new/modals/low_price_stocks_tab.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import '../modals/low_price_stocks_res.dart';

// class MostActiveProvider extends ChangeNotifier {
//   String? _error;
//   Status _status = Status.ideal;
//   Status _tabStatus = Status.ideal;
//   int selectedIndex = 0;

//   List<LowPriceStocksTabRes>? _tabs;

//   List<LowPriceStocksTabRes>? get tabs => _tabs;

//   List<LowPriceStocksRes>? _data;
//   List<LowPriceStocksRes>? get data => _data;

//   String? get error => _error ?? Const.errSomethingWrong;
//   bool get isLoading => _status == Status.loading;
//   bool get tabLoading => _tabStatus == Status.loading;

//   String? title;
//   String? subTitle;
//   int _openIndexMostActive = -1;
//   int get openIndexMostActive => _openIndexMostActive;
//   int _openIndex = -1;
//   int get openIndex => _openIndex;

//   void setStatus(status) {
//     _status = status;
//     notifyListeners();
//   }

//   void setTabStatus(status) {
//     _tabStatus = status;
//     notifyListeners();
//   }

//   void setOpenIndexMostActive(index) {
//     _openIndexMostActive = index;
//     notifyListeners();
//   }

//   void setOpenIndex(index) {
//     _openIndex = index;
//     notifyListeners();
//   }

//   void tabChange(index) {
//     Utils().showLog("Before--> selected index $selectedIndex, index $index ");
//     if (selectedIndex != index) {
//       selectedIndex = index;
//       notifyListeners();
//       getMostActiveData(showProgress: false);
//     }
//   }

//   Future getMostActiveData({showProgress = false, type = 1}) async {
//     setStatus(Status.loading);

//     try {
//       Map request = {
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
//       };

//       ApiResponse response = await apiRequest(
//         url: Apis.lowPricesStocks,
//         request: request,
//         showProgress: false,
//       );

//       if (response.status) {
//         _error = null;
//         _data = lowPriceStocksResFromJson(jsonEncode(response.data));
//         title = response.extra?.title;
//         subTitle = response.extra?.subTitle;
//       } else {
//         _data = null;
//         _error = response.message;
//       }

//       setStatus(Status.loaded);
//     } catch (e) {
//       _data = null;
//       Utils().showLog(e.toString());

// ignore_for_file: prefer_final_fields

//       setStatus(Status.loaded);
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/most_active_stocks_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class MostActiveProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;
  // ************* GAP DOWN **************** //
  List<MostActiveStocksRes>? _data;
  String? _error;
  int _page = 1;
  Extra? _extraUp;

  List<MostActiveStocksRes>? get data => _data;
  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;

  // ************* GAP DOWN **************** //
  String? _errorDown;
  int _pageDown = 1;
  // int? _totalPageDown;
  Extra? _extraDown;

  bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
  String? get errorDown => _errorDown ?? Const.errSomethingWrong;
  bool get isLoadingDown => _status == Status.loading;
  Status _statusMostActive = Status.ideal;
  Status get statusMostActive => _statusMostActive;
  bool get isLoadingMostActive => _statusMostActive == Status.loading;
  int get openIndexMostActive => _openIndexMostActive;
  int _openIndexMostActive = -1;
  int _openIndex = -1;

  int get openIndex => _openIndex;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusMostActive(status) {
    _statusMostActive = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void setOpenIndexMostActive(index) {
    _openIndexMostActive = index;
    notifyListeners();
  }

  Future getMostActiveData({loadMore = false, type = 1}) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = {"page": "$_page"};

      ApiResponse response = await apiRequest(
        url: type == 1
            ? Apis.mostActiveStocks
            : type == 2
                ? Apis.mostVoliatileStocks
                : Apis.mostVolumeStocks,
        request: request,
        showProgress: false,
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
