import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/insider_trading_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

class InsiderTradingProvider extends ChangeNotifier with AuthProviderBase {
  InsiderTradingRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _openIndex = -1;
  int _page = 1;
//
  Status get status => _status;
  InsiderTradingRes? get data => _data;
  int get openIndex => _openIndex;

  List<KeyValueElement>? _cap;
  List<KeyValueElement>? get cap => _cap;

  List<KeyValueElement>? _sector;
  List<KeyValueElement>? get sector => _sector;

  List<KeyValueElement>? _transactionType;
  List<KeyValueElement>? get transactionType => _transactionType;
  List<KeyValueElement>? _txnSize;
  List<KeyValueElement>? get txnSize => _txnSize;

  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  bool get isLoading => _status == Status.loading;
  bool get isSearching => _status == Status.searching;
  String? get error => _error ?? Const.errSomethingWrong;

  String keyTxnType = "";
  String keyCap = "";
  String keySector = "";
  String keyTxnSize = "";
  String valueSearch = "";
  String valueTxnType = "";
  String valueCap = "";
  String valueSector = "";
  String valueTxnSize = "";

  TextEditingController date = TextEditingController();
  String dateSend = "";
  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      date.text = DateFormat("dd-MM-yyyy").format(picked);
      dateSend = DateFormat("yyyy-MM-dd").format(picked);
      log(date.text);
    }

    notifyListeners();
  }

  void onChangeTransactionType({KeyValueElement? selectedItem}) {
    keyTxnType = selectedItem?.key ?? "";
    valueTxnType = selectedItem?.value ?? "";
    log("Key TransactionType=> $keyTxnType");
    notifyListeners();
  }

  void onChangeCap({KeyValueElement? selectedItem}) {
    keyCap = selectedItem?.key ?? "";
    valueCap = selectedItem?.value ?? "";
    log("Key Cap=> $keyCap");
    notifyListeners();
  }

  void onChangeSector({KeyValueElement? selectedItem}) {
    keySector = selectedItem?.key ?? "";
    valueSector = selectedItem?.value ?? "";
    log("Key Sector=> $keySector");
    notifyListeners();
  }

  void onChangeTransactionSize({KeyValueElement? selectedItem}) {
    keyTxnSize = selectedItem?.key ?? "";
    valueTxnSize = selectedItem?.value ?? "";
    log("Key TransactionSize=> $keyTxnSize");
    notifyListeners();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpen(index) {
    _openIndex = index;
    notifyListeners();
  }

  void _clearVariables() {
    keyCap = "";
    keySector = "";
    keyTxnSize = "";
    keyTxnType = "";
    valueCap = "";
    valueSector = "";
    valueTxnSize = "";
    valueTxnType = "";
    valueSearch = "";
    dateSend = "";
    _openIndex = -1;
    date.clear();
    notifyListeners();
  }

  Future getData(
      {showProgress = false,
      loadMore = false,
      search,
      bool clear = true}) async {
    if (search != null) {
      valueSearch = search;
      _page = 1;
      setStatus(Status.searching);
    } else if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }

    if (clear) _clearVariables();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page",
        "search": valueSearch,
        "txn_type": keyTxnType,
        "market_cap": keyCap,
        "sector": keySector,
        "txn_size": keyTxnSize,
        "txn_date": dateSend,
      };
      ApiResponse response = await apiRequest(
          url: Apis.insiderTrading,
          request: request,
          showProgress: showProgress);

      if (response.status) {
        _error = null;
        // if (_page == 1 && response.data == []) {
        //   _data = null;
        // } else
        if (_page == 1) {
          _data = InsiderTradingRes.fromJson(response.data);
          if ((_data?.data.isEmpty ?? false) && isSearching) {
            _error = Const.errNoRecord;
          }
        } else {
          _data?.data.addAll(InsiderTradingRes.fromJson(response.data).data);
        }
        _transactionType = response.extra.transactionType;
        _cap = response.extra.cap;
        _sector = response.extra.sector;
        _txnSize = response.extra.txnSize;
        notifyListeners();
      } else {
        _data = null;
        _error = response.message;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;

      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future logoutUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        showErrorMessage(message: res.message);
      }
    } catch (e) {
      setStatus(Status.loaded);
      showErrorMessage(
        message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      );
    }
  }
}
