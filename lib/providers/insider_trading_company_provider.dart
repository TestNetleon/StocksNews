import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/insider_company_graph.dart';
import 'package:stocks_news_new/modals/insider_trading_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class InsiderTradingDetailsProvider extends ChangeNotifier
    with AuthProviderBase {
  String? _error;
//
  // int _openIndex = -1;
  int _pageCompany = 1;
  int _pageReporter = 1;

  InsiderTradingRes? _companyData;
  InsiderTradingRes? get companyData => _companyData;

  InsiderTradingRes? _reporterData;
  InsiderTradingRes? get reporterData => _reporterData;

  List<KeyValueElement>? _transactionType;
  List<KeyValueElement>? get transactionType => _transactionType;
  List<KeyValueElement>? _txnSize;
  List<KeyValueElement>? get txnSize => _txnSize;

  // int get openIndex => _openIndex;
  bool get canLoadMoreCompany => _pageCompany < (_companyData?.lastPage ?? 1);
  bool get canLoadMoreReporter =>
      _pageReporter < (_reporterData?.lastPage ?? 1);

  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get isSearching => _status == Status.searching;

  Status _isGraphLoading = Status.ideal;
  Status _isGraphLoadingInsider = Status.ideal;

  bool get isGraphLoading => _isGraphLoading == Status.loading;
  bool get isGraphLoadingInsider => _isGraphLoadingInsider == Status.loading;

  int _indexCompany = -1;
  int get indexCompany => _indexCompany;

  int _indexReporting = -1;
  int get indexReporting => _indexReporting;
  String searchTransaction = "";

  TextRes? _textRes;
  TextRes? get textRes => _textRes;

  TextRes? _textResI;
  TextRes? get textResI => _textResI;

  String keyTxnTypeCP = "";
  String keyTxnSizeCP = "";
  String valueTxnTypeCP = "";
  String valueTxnSizeCP = "";

  String keyTxnTypeIP = "";
  String keyTxnSizeIP = "";
  String valueTxnTypeIP = "";
  String valueTxnSizeIP = "";

  TextEditingController tnxTypeControllerCP = TextEditingController();
  TextEditingController tnxSizeControllerCP = TextEditingController();

  TextEditingController tnxTypeControllerIP = TextEditingController();
  TextEditingController tnxSizeControllerIP = TextEditingController();

  List<String>? chartDates;
  List<int>? chartPurchase;
  List<int>? chartSale;

  List<String>? chartDatesInsider;
  List<int>? chartPurchaseInsider;
  List<int>? chartSaleInsider;

  Extra? _extra;
  Extra? get extra => _extra;

  Future insiderGraphData({
    showProgress = false,
    String companySlug = "",
  }) async {
    // setStatus(Status.loading);
    _isGraphLoading = Status.loading;
    notifyListeners();

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "companySlug": companySlug,
        "search": searchTransaction,
        "txn_type": keyTxnTypeCP,
        "txn_size": keyTxnSizeCP,
        "txn_date": dateSendCP,
      };
      ApiResponse response = await apiRequest(
        url: Apis.insiderTradingGraph,
        showProgress: showProgress,
        request: request,
        removeForceLogin: true,
      );
      if (response.status) {
        chartDates =
            insiderCompanyGraphFromJson(jsonEncode(response.data)).chartDates;
        chartPurchase = insiderCompanyGraphFromJson(jsonEncode(response.data))
            .chartPurchase;
        chartSale =
            insiderCompanyGraphFromJson(jsonEncode(response.data)).chartSale;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        chartDates = null;
        chartPurchase = null;
        chartSale = null;
      }
      // setStatus(Status.loaded);
      _isGraphLoading = Status.loaded;
      notifyListeners();
    } catch (e) {
      chartDates = null;
      chartPurchase = null;
      chartSale = null;
      Utils().showLog(e.toString());
      // setStatus(Status.loaded);
      _isGraphLoading = Status.loaded;
      notifyListeners();
    }
  }

  Future insiderGraphDataInsider({
    showProgress = false,
    String companySlug = "",
    String reportingSlug = "",
  }) async {
    // setStatus(Status.loading);
    _isGraphLoadingInsider = Status.loading;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "companySlug": companySlug,
        "reportingSlug": reportingSlug,
        "search": searchTransaction,
        "txn_type": keyTxnTypeIP,
        "txn_size": keyTxnSizeIP,
        "txn_date": dateSendIP,
      };
      ApiResponse response = await apiRequest(
        url: Apis.insiderInsiderGraph,
        showProgress: showProgress,
        request: request,
        removeForceLogin: true,
      );
      if (response.status) {
        chartDatesInsider =
            insiderCompanyGraphFromJson(jsonEncode(response.data)).chartDates;
        chartPurchaseInsider =
            insiderCompanyGraphFromJson(jsonEncode(response.data))
                .chartPurchase;
        chartSaleInsider =
            insiderCompanyGraphFromJson(jsonEncode(response.data)).chartSale;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        chartDatesInsider = null;
        chartPurchaseInsider = null;
        chartSaleInsider = null;
      }
      // setStatus(Status.loaded);
      _isGraphLoadingInsider = Status.loaded;
      notifyListeners();
    } catch (e) {
      chartDatesInsider = null;
      chartPurchaseInsider = null;
      chartSaleInsider = null;
      Utils().showLog("Error ------$e");
      // setStatus(Status.loaded);
      _isGraphLoadingInsider = Status.loaded;
      notifyListeners();
    }
  }

  void onChangeTransactionTypeCP({KeyValueElement? selectedItem}) {
    keyTxnTypeCP = selectedItem?.key ?? "";
    valueTxnTypeCP = selectedItem?.value ?? "";
    tnxTypeControllerCP.text = selectedItem?.value ?? "";
    notifyListeners();
  }

  void onChangeTransactionSizeCP({KeyValueElement? selectedItem}) {
    keyTxnSizeCP = selectedItem?.key ?? "";
    valueTxnSizeCP = selectedItem?.value ?? "";
    tnxSizeControllerCP.text = selectedItem?.value ?? "";
    notifyListeners();
  }

  void onChangeTransactionTypeIP({KeyValueElement? selectedItem}) {
    keyTxnTypeIP = selectedItem?.key ?? "";
    valueTxnTypeIP = selectedItem?.value ?? "";
    tnxTypeControllerIP.text = selectedItem?.value ?? "";
    notifyListeners();
  }

  void onChangeTransactionSizeIP({KeyValueElement? selectedItem}) {
    keyTxnSizeIP = selectedItem?.key ?? "";
    valueTxnSizeIP = selectedItem?.value ?? "";
    tnxSizeControllerIP.text = selectedItem?.value ?? "";
    notifyListeners();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void _clearVariablesCP() {
    keyTxnSizeCP = "";
    keyTxnTypeCP = "";
    valueTxnSizeCP = "";
    valueTxnTypeCP = "";
    dateCP.clear();
    dateSendCP = "";
    searchTransaction = "";
    tnxSizeControllerCP.clear();
    tnxTypeControllerCP.clear();
    notifyListeners();
  }

  void _clearVariablesIP() {
    keyTxnSizeIP = "";
    keyTxnTypeIP = "";
    valueTxnSizeIP = "";
    valueTxnTypeIP = "";
    dateIP.clear();
    dateSendIP = "";
    searchTransaction = "";
    tnxSizeControllerIP.clear();
    tnxTypeControllerIP.clear();
    notifyListeners();
  }

  void change(int index, bool isCompany) {
    if (isCompany) {
      _indexCompany = index;

      // if (_companyData?.data.isNotEmpty == true &&
      //     index >= 0 &&
      //     index < _companyData!.data.length) {
      //   for (int i = 0; i < _companyData!.data.length; i++) {
      //     if (i != index) {
      //       _companyData?.data[i].isOpen = false;
      //     }
      //   }
      //   _companyData?.data[index].isOpen = !_companyData!.data[index].isOpen;
      // }
    } else {
      _indexReporting = index;
      // if (_reporterData?.data.isNotEmpty == true &&
      //     index >= 0 &&
      //     index < _reporterData!.data.length) {
      //   for (int i = 0; i < _reporterData!.data.length; i++) {
      //     if (i != index) {
      //       _reporterData?.data[i].isOpen = false;
      //     }
      //   }
      //   _reporterData?.data[index].isOpen = !_reporterData!.data[index].isOpen;
      // }
    }

    notifyListeners();
  }

  TextEditingController dateCP = TextEditingController();
  String dateSendCP = "";
  TextEditingController dateIP = TextEditingController();
  String dateSendIP = "";
  Future<void> pickDate({bool isCP = true}) async {
    final DateTime? picked = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (isCP) {
        dateCP.text = DateFormat("MMM dd, yyyy").format(picked);
        dateSendCP = DateFormat("yyyy-MM-dd").format(picked);
      } else {
        dateIP.text = DateFormat("MMM dd, yyyy").format(picked);
        dateSendIP = DateFormat("yyyy-MM-dd").format(picked);
      }
    }

    notifyListeners();
  }

  Future getData({
    showProgress = false,
    loadMore = false,
    String companySlug = "",
    String reportingSlug = "",
    String search = "",
    bool clear = true,
  }) async {
    if (reportingSlug == "") {
      if (clear) _clearVariablesCP();

      if (search != "") {
        searchTransaction = search;
        _indexCompany = -1;
        _indexReporting = -1;
        _pageCompany = 1;
        setStatus(Status.searching);
      }
      if (loadMore) {
        _pageCompany++;
        setStatus(Status.loadingMore);
      } else {
        _indexCompany = -1;
        _indexReporting = -1;
        _pageCompany = 1;
        setStatus(Status.loading);
      }
    } else {
      if (clear) _clearVariablesIP();
      if (search != "") {
        _indexCompany = -1;
        _indexReporting = -1;
        _pageReporter = 1;
        setStatus(Status.searching);
      } else if (loadMore) {
        _pageReporter++;
        setStatus(Status.loadingMore);
      } else {
        _indexCompany = -1;
        _indexReporting = -1;
        _pageReporter = 1;
        setStatus(Status.loading);
      }
    }

    try {
      Map request = reportingSlug == ""
          ? {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "$_pageCompany",
              "companySlug": companySlug,
              "search": searchTransaction,
              "txn_type": keyTxnTypeCP,
              "txn_size": keyTxnSizeCP,
              "txn_date": dateSendCP,
            }
          : {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "$_pageReporter",
              "companySlug": companySlug,
              "reportingSlug": reportingSlug,
              "search": searchTransaction,
              "txn_type": keyTxnTypeIP,
              "txn_size": keyTxnSizeIP,
              "txn_date": dateSendIP,
            };
      ApiResponse response = await apiRequest(
        url: Apis.insiderTrading,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _error = null;
        if (reportingSlug == "") {
          if (_pageCompany == 1) {
            _companyData = InsiderTradingRes.fromJson(response.data);
            _extra = (response.extra is Extra ? response.extra as Extra : null);
          } else {
            _companyData?.data
                .addAll(InsiderTradingRes.fromJson(response.data).data);
          }
        } else {
          if (_pageReporter == 1) {
            _reporterData = InsiderTradingRes.fromJson(response.data);
          } else {
            _reporterData?.data
                .addAll(InsiderTradingRes.fromJson(response.data).data);
          }
        }
        _transactionType = response.extra.transactionType;
        _txnSize = response.extra.txnSize;
        setStatus(Status.loaded);
      } else {
        if (reportingSlug == "") {
          if (_pageCompany == 1) {
            _companyData = null;
            _error = response.message;
          }
        } else {
          if (_pageReporter == 1) {
            _reporterData = null;
            _error = response.message;
          }
        }
      }

      if (reportingSlug == "") {
        if (response.extra is! List) {
          _textRes = response.extra?.text;
        }
      } else {
        if (response.extra is! List) {
          _textResI = response.extra?.text;
        }
      }

      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog("Error -----$e");

      if (reportingSlug == "") {
        if (_pageCompany == 1) {
          _companyData = null;
        }
      } else {
        if (_pageReporter == 1) {
          _reporterData = null;
        }
      }
      setStatus(Status.loaded);
    }
  }

  Future logoutUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
        showProgress: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        // showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        // showErrorMessage(message: res.message);
      }
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }
}
