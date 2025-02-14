import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/tools.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';

import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../models/plaid_portfolio.dart';
import '../routes/my_app.dart';
import '../utils/constants.dart';

class ToolsManager extends ChangeNotifier {
  //MARK: Tools
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  ToolsRes? _data;
  ToolsRes? get data => _data;

  bool _apiSubmitted = false;
  bool get apiSubmitted => _apiSubmitted;

  setSubmission(status) {
    _apiSubmitted = status;
    notifyListeners();
  }

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getToolsData() async {
    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tools,
        request: request,
      );
      if (response.status) {
        _data = toolsResFromJson(jsonEncode(response.data));
        setSubmission(_data?.plaid?.connected == true);
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
    } finally {
      setStatus(Status.loaded);
    }
  }

  //MARK: Save Plaid
  Future savePlaidPortfolio(token) async {
    if (apiSubmitted) return;
    setSubmission(true);

    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'access_token': token,
      };

      ApiResponse response = await apiRequest(
        url: Apis.savePlaid,
        request: request,
      );
      if (response.status) {
        if (response.message != null && response.message != '') {
          TopSnackbar.show(
            message: response.message ?? '',
            type: ToasterEnum.success,
          );
        }

        await getToolsData();
        _error = null;
      } else {
        setSubmission(false);

        TopSnackbar.show(
          message: response.message ?? '',
          type: ToasterEnum.warning,
        );
      }
    } catch (e) {
      setSubmission(false);

      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    } finally {
      setStatus(Status.loaded);
    }
  }

//MARK: Get Portfolio Data
  String? _errorPortfolio;
  String? get errorPortfolio => _errorPortfolio ?? Const.errSomethingWrong;

  Status _statusPortfolio = Status.ideal;
  Status get statusPortfolio => _statusPortfolio;

  bool get isLoadingPortfolio => _statusPortfolio == Status.loading;

  ToolsPortfolioRes? _portfolioData;
  ToolsPortfolioRes? get portfolioData => _portfolioData;

  setStatusPortfolio(status) {
    _statusPortfolio = status;
    notifyListeners();
  }

  Future getPortfolioData() async {
    setStatusPortfolio(Status.loading);
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
        url: Apis.getPortfolio,
        request: request,
      );
      if (response.status) {
        _portfolioData = toolsPortfolioResFromJson(jsonEncode(response.data));
        _errorPortfolio = null;
      } else {
        _portfolioData = null;
        _error = response.message;
      }
    } catch (e) {
      _portfolioData = null;
      _errorPortfolio = Const.errSomethingWrong;
    } finally {
      setStatusPortfolio(Status.loaded);
    }
  }
}
