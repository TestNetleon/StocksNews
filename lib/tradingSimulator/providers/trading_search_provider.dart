// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/api/apis.dart';
// import 'package:stocks_news_new/modals/search_res.dart';
// import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// import '../manager/sse.dart';

// //
// class TradingSearchProvider extends ChangeNotifier {
//   Status _status = Status.ideal;
//   Status get status => _status;
//   bool get isLoading => _status == Status.loading || _status == Status.ideal;
//   final sseManager = SSEManager();
//   List<TradingSearchTickerRes>? _data;
//   List<TradingSearchTickerRes>? get data => _data;

//   String? _error;
//   String? get error => _error ?? Const.errSomethingWrong;

//   Status _statusS = Status.ideal;
//   Status get statusS => _statusS;
//   bool get isLoadingS => _statusS == Status.loading;

//   List<SearchRes>? _dataNew;
//   List<SearchRes>? get dataNew => _dataNew;

//   Extra? _extra;
//   Extra? get extra => _extra;

//   void setStatus(status) {
//     _status = status;
//     notifyListeners();
//   }

//   void setStatusS(status) {
//     _statusS = status;
//     notifyListeners();
//   }

//   void clearSearch() {
//     _status = Status.ideal;
//     _statusS = Status.ideal;
//     _dataNew = null;
//     notifyListeners();
//   }

//   Future getSearchDefaults() async {
//     setStatus(Status.loading);
//     try {
//       Map request = {
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
//       };

//       ApiResponse response = await apiRequest(
//         url: Apis.tradingMostSearch,
//         request: request,
//         showProgress: false,
//       );

//       if (response.status) {
//         _extra = (response.extra is Extra ? response.extra as Extra : null);
//         _data = tradingSearchTickerResFromJson(jsonEncode(response.data));
//         //SSE CODE HERE
//       } else {
//         _data = null;
//         _error = response.message ?? Const.errSomethingWrong;
//         // showErrorMessage(message: response.message);
//       }
//       setStatus(Status.ideal);
//     } catch (e) {
//       _data = null;
//       _error = Const.errSomethingWrong;
//       Utils().showLog(e.toString());
//       setStatus(Status.ideal);
//     }
//   }

//   Future searchSymbols(request, {showProgress = false}) async {
//     setStatusS(Status.loading);
//     try {
//       ApiResponse response = await apiRequest(
//         url: Apis.tsSearchSymbol,
//         request: request,
//         showProgress: showProgress,
//       );
//       if (response.status) {
//         _dataNew = searchResFromJson(jsonEncode(response.data));
//       } else {
//         _dataNew = null;
//       }
//       setStatusS(Status.loaded);
//     } catch (e) {
//       Utils().showLog(e.toString());
//       setStatusS(Status.loaded);
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../manager/sse.dart';

class TradingSearchProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  final sseManager = SSEManager();

  List<TradingSearchTickerRes>? _data;
  List<TradingSearchTickerRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;
  bool get isLoadingS => _statusS == Status.loading;

  List<SearchRes>? _dataNew;
  List<SearchRes>? get dataNew => _dataNew;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusS(status) {
    _statusS = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _statusS = Status.ideal;
    _dataNew = null;
    notifyListeners();
  }

  /// Fetch search defaults and set up SSE
  Future getSearchDefaults() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };

      ApiResponse response = await apiRequest(
        url: Apis.tradingMostSearch,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        _data = tradingSearchTickerResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
      }
      setStatus(Status.ideal);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.ideal);
    }
  }

  /// Dispose method to clean up SSE
  @override
  void dispose() {
    super.dispose();
  }

  Future searchSymbols(request, {showProgress = false}) async {
    setStatusS(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tsSearchSymbol,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataNew = searchResFromJson(jsonEncode(response.data));
      } else {
        _dataNew = null;
      }
      setStatusS(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatusS(Status.loaded);
    }
  }
}
