import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/models/tools.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/signals/signals.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/ui/tabs/tools/market/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/game_tournament_index.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../models/compare.dart';
import '../models/plaid_portfolio.dart';
import '../routes/my_app.dart';
import '../ui/tabs/tools/compareStocks/compare.dart';
import '../ui/tabs/tools/plaidConnect/plaid_service.dart';
import '../ui/tabs/tools/plaidConnect/portfolio.dart';
import '../utils/constants.dart';

class ToolsManager extends ChangeNotifier {
  //MARK: Clear Data
  void clearAllData() {
    //clear tools data
    _data = null;
    //clear portfolio data
    _portfolioData = null;
    //clear compare data
    _compareData = null;
    notifyListeners();
  }

//MARK: Navigate
  Future startNavigation(ToolsEnum type) async {
    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    // await manager.askLoginScreen();
    // if (manager.user == null) {
    //   return;
    // }

    switch (type) {
      case ToolsEnum.scanner:
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          ToolsScannerIndex.path,
        );
        break;

      case ToolsEnum.signals:
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => SignalsIndex(),
          ),
        );
        break;

      case ToolsEnum.market:
        // Navigator.pushNamed(
        //   navigatorKey.currentContext!,
        //   SimulatorIndex.path,
        // );

        Navigator.pushNamed(navigatorKey.currentContext!, MarketIndex.path);
        break;

      case ToolsEnum.simulator:
        // Navigator.pushNamed(
        //   navigatorKey.currentContext!,
        //   SimulatorIndex.path,
        // );

        Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path,
            arguments: {'index': 2});
        break;

      case ToolsEnum.portfolio:
        ToolsCardsRes? data = _data?.tools
            ?.firstWhere((element) => element.slug == ToolsEnum.portfolio);

        if (data?.connected == true) {
          Navigator.pushNamed(
              navigatorKey.currentContext!, ToolsPortfolioIndex.path);
        } else {
          bool callAPI = false;
          if (manager.user == null) {
            callAPI = true;
          }
          await manager.askLoginScreen();
          if (callAPI) await getToolsData();

          if (manager.user == null) {
            return;
          }
          if (manager.user?.signupStatus != true) {
            if (data?.connected == true) {
              Navigator.pushNamed(
                  navigatorKey.currentContext!, ToolsPortfolioIndex.path);
            } else {
              try {
                PlaidService.instance.init();
                PlaidService.instance.initiatePlaid();
              } catch (e) {
                TopSnackbar.show(
                  message: Const.errSomethingWrong,
                  type: ToasterEnum.error,
                );
              }
            }
          }
        }

        break;

      case ToolsEnum.compare:
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          ToolsCompareIndex.path,
        );
        break;

      case ToolsEnum.league:
        Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => GameTournamentIndex(setIndex: 0),
            ));
        /*  Navigator.pushNamed(
          navigatorKey.currentContext!,
          TradingLeagueIndex.path,
        );*/
        break;
    }
  }

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

        ToolsCardsRes? element = _data?.tools
            ?.firstWhere((element) => element.slug == ToolsEnum.portfolio);

        setSubmission(element?.connected == true);
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
        _error = null;
        await getToolsData();
        Navigator.pushNamed(
            navigatorKey.currentContext!, ToolsPortfolioIndex.path);
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
      Utils().showLog("Error in ${Apis.getPortfolio}: $e");
    } finally {
      setStatusPortfolio(Status.loaded);
    }
  }

//MARK: Remove Portfolio
  Future removePortfolio() async {
    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
        url: Apis.removePortfolio,
        request: request,
        showProgress: true,
      );

      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
      Navigator.pop(navigatorKey.currentContext!);
      await getToolsData();
    } catch (e) {
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    } finally {
      setStatus(Status.loaded);
    }
  }

//MARK: Compare Stocks
  String? _errorCompare;
  String? get errorCompare => _errorCompare ?? Const.errSomethingWrong;

  Status _statusCompare = Status.ideal;
  Status get statusCompare => _statusCompare;

  bool get isLoadingCompare =>
      _statusCompare == Status.loading || _statusCompare == Status.ideal;

  ToolsCompareRes? _compareData;
  ToolsCompareRes? get compareData => _compareData;

  final List<String> tableRow = [
    //Total 25
    'Overall',
    'Fundamental',
    'Short-term Technical',
    'Long-term Technical',
    'Analyst Ranking',
    'Valuation',
    // 'Social Sentiment',
    'Price',
    'Change',
    'Change Percentage',
    'Day Low',
    'Day High',
    'Year Low',
    'Year High',
    'Market Cap',
    'Price Avg 50',
    'Price Avg 200',
    'Exchange',
    'Volume',
    'Average Volume',
    'Open',
    'Previous Close',
    'EPS',
    'PE',
    'Earnings Announcement',
  ];

  setStatusCompare(status) {
    _statusCompare = status;
    notifyListeners();
  }

  Future getCompareData({bool showDefault = true}) async {
    try {
      setStatusCompare(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };
      if (showDefault) {
        request['default_compare_add'] = '1';
      }

      ApiResponse response = await apiRequest(
        url: Apis.compareStocks,
        request: request,
      );
      if (response.status) {
        _compareData = toolsCompareResFromJson(jsonEncode(response.data));
        _errorCompare = response.message;
      } else {
        _compareData = null;
        _errorCompare = response.message;
      }
    } catch (e) {
      _compareData = null;
      _errorCompare = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.compareStocks}: $e');
    } finally {
      setStatusCompare(Status.loaded);
    }
  }

//MARK: Add Compare
  Future addToCompare(String symbol) async {
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.addCompareStock,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        BaseTickerRes tickerRes = BaseTickerRes.fromJson(response.data);

        _compareData?.data?.add(tickerRes);
      }

      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
    } catch (e) {
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    } finally {
      notifyListeners();
    }
  }

//MARK: Delete Compare
  Future deleteFromCompare(index) async {
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _compareData?.data?[index].symbol ?? '',
      };

      ApiResponse response = await apiRequest(
        url: Apis.deleteCompareStock,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        if (_compareData?.data?.isNotEmpty == true &&
            _compareData?.data != null) {
          if (_compareData?.data?.length == 1) {
            Utils().showLog('--calling compare data');
            _compareData?.data?.removeAt(index);
            await getCompareData();
          } else {
            _compareData?.data?.removeAt(index);
          }
        }
      }

      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
    } catch (e) {
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    } finally {
      notifyListeners();
    }
  }
}
