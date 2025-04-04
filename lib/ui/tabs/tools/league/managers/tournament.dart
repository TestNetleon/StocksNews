import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/all_trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/league.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/league_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/league_titan_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/tab_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/tour_user_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/game_tournament_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/dayTraining/open/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/tournament_user/tournament_user_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/tournament_user/trades_with_date.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';


class LeagueManager extends ChangeNotifier {

  double progress = 0.0;
  late Duration? _totalDuration;
  Color progressColor = ThemeColors.success120;

  num hours = 00;
  num minutes = 00;
  num seconds = 00;
  Timer? _timer;

//MARK: TIMER
  timer(bool start) {
    if (start) {
      _timer?.cancel();
      hours = 24;
      minutes = 0;
      seconds = 0;
      progress = 0;
      startCountdown();
    } else {
      _timer?.cancel();
    }
  }

  void startCountdown() async {
    DateTime? start = _detailRes?.battleTime?.startTime;
    DateTime? end = _detailRes?.battleTime?.endTime;
    DateTime? serverTime = _detailRes?.battleTime?.currentTime;
    if (start == null || end == null || serverTime == null) {
      return;
    }

    Utils().showLog('ServerTime $serverTime');
    Utils().showLog('Start $start');
    Utils().showLog('End $end');

    if (serverTime.isBefore(start)) {
      // Before tournament start
      if (kDebugMode) {
        print('1: Before start time');
      }
      _startTimer(start.difference(serverTime), isStart: true);
    } else if (serverTime.isAfter(start) && serverTime.isBefore(end)) {
      // During tournament
      if (kDebugMode) {
        print('2: During tournament');
      }
      _startTimer(end.difference(serverTime), isStart: false);
    } else {
      // After tournament end
      if (kDebugMode) {
        print('3: Tournament over');
      }
      hours = 0;
      minutes = 0;
      seconds = 0;
      progress = 0;
      notifyListeners();
    }
  }

  void _startTimer(Duration initialDuration, {required bool isStart}) {
    hours = initialDuration.inHours;
    minutes = initialDuration.inMinutes % 60;
    seconds = initialDuration.inSeconds % 60;
    _totalDuration = _detailRes?.battleTime?.endTime!
        .difference(_detailRes?.battleTime!.startTime ?? DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (hours == 0 && minutes == 0 && seconds == 0) {
        stopCountdown();
        if (isStart) {
          Future.delayed(Duration(seconds: 5), () {
            tournamentDetail(_id);
          });
        } else {
          // _endTournament();
          popUpAlert(
            canPop: false,
            title: 'Tournament has Ended',
            message:
                'Thank you for participating! We hope you enjoyed the tournament. Stay tuned for upcoming event!',
            onTap: () {
              Navigator.popUntil(
                  navigatorKey.currentContext!, (route) => route.isFirst);
              Navigator.pushNamed(
                  navigatorKey.currentContext!,
                  TradingLeagueIndex.path,
                  arguments: {'initialIndex':1}
              );
            },
          );
        }
      } else {
        // Decrement the countdown
        if (seconds > 0) {
          seconds--;
          int elapsedSeconds =
              _totalDuration!.inSeconds - initialDuration.inSeconds;
          progress = elapsedSeconds / _totalDuration!.inSeconds;
          progressColor = ThemeColors.success120;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
            if (hours > 0) {
              hours--;
              minutes = 59;
              seconds = 59;
            }
          }
        }
        // Example: Notify 5 minutes before start or end
        if (hours == 0 && minutes == 5 && seconds == 0) {
          Utils().showLog(isStart
              ? "Tournament starts in 5 minutes"
              : "Tournament ends in 5 minutes");
        }
      }
      notifyListeners();
    });
  }


  void stopCountdown() {
    _timer?.cancel();
  }

  Map<String, String> get timeRemaining {
    return {
      'hours': hours.toString().padLeft(2, '0'),
      'minutes': minutes.toString().padLeft(2, '0'),
      'seconds': seconds.toString().padLeft(2, '0'),
    };
  }


  LeagueTabRes? _tabData;
  LeagueTabRes? get tabData => _tabData;

  Status _status = Status.ideal;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future<void> getTabs({int? initialIndex}) async {
    try {
      setStatus(Status.loading);
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.lTabs,
        request: request,
      );

      if (response.status) {
        _tabData = leagueTabResFromMap(jsonEncode(response.data));
        _error = null;
        onScreenChange(initialIndex??0);
      } else {
        _tabData = null;
        _error = response.message;
      }
    } catch (e) {
      _tabData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error on ${Apis.cryptoTabs}: $e');

    } finally {
      setStatus(Status.loaded);
    }
  }


  int? selectedScreen=-1;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      notifyListeners();
      switch (selectedScreen) {
        case 0:
          tournament();
          break;
        case 1:
          navigatorKey.currentContext!.read<LeaderboardManager>().showLeaderboard();
          break;

        case 2:
          break;
        default:
      }
    }
  }


// TOURNAMENT
  Status _statusTournament = Status.ideal;
  Status get statusTournament => _statusTournament;

  bool get isLoadingTournament =>
      _statusTournament == Status.loading || _statusTournament == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  LeagueRes? _data;
  LeagueRes? get data => _data;

  Extra? _extra;
  Extra? get extra => _extra;


  void setStatusTournament(status) {
    _statusTournament = status;
    notifyListeners();
  }

  Future tournament() async {
    _data = null;
    setStatusTournament(Status.loading);
    try {
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.t,
        request: request,
      );

      if (response.status) {
        _data = tournamentResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
      }
      setStatusTournament(Status.loaded);
    } catch (e) {
      _data = null;

      _error = Const.errSomethingWrong;
      setStatusTournament(Status.loaded);
      Utils().showLog('error $e');
    }
  }

  Status _statusDetail = Status.ideal;
  Status get statusDetail => _statusDetail;

  bool get isLoadingDetail =>
      _statusDetail == Status.loading || _statusDetail == Status.ideal;

  String? _errorDetail;
  String? get errorDetail => _errorDetail ?? Const.errSomethingWrong;

  LeagueDetailRes? _detailRes;
  LeagueDetailRes? get detailRes => _detailRes;

  void setStatusDetail(status) {
    _statusDetail = status;
    notifyListeners();
  }

  int? _id;
  Future tournamentDetail(int? id, {bool timerSet = true}) async {
    _id = id;
    setStatusDetail(Status.loading);
    try {
      Map request = {
        'tournament_id': '${id ?? ''}',
      };
      ApiResponse response = await apiRequest(
        url: Apis.tDetail,
        request: request,
      );
      if (response.status) {
        _detailRes = tournamentDetailResFromJson(jsonEncode(response.data));
        timer(timerSet);
        _error = null;
      } else {
        _detailRes = null;
        _error = response.message;
      }
    } catch (e) {
      Utils().showLog('error in detail $e');
      _error = Const.errSomethingWrong;
      _detailRes = null;
    }
    finally{
      setStatusDetail(Status.loaded);
    }
  }

// MARK: JOIN
  Future joinLeague({int? id}) async {
    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    if (manager.user == null) {
      await manager.askLoginScreen();
      if (manager.user == null) return;
    }
    try {
      Map request = {
        'tournament_battle_id': '${_detailRes?.tournamentBattleId ?? ''}',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tJoin,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        tournamentDetail(_id);
        Navigator.pushNamed( navigatorKey.currentContext!, LeagueTickersIndex.path);
      } else {
        TopSnackbar.show(
          message: response.message??"",
          type: ToasterEnum.error,
        );
      }
    } catch (e) {
      Utils().showLog('join error $e');
    }
  }

// MARK: Trades Executed

  Status _statusCommonList = Status.ideal;
  Status get statusCommonList => _statusCommonList;

  bool get isLoadingCommonList => _statusCommonList == Status.loading;

  String? _errorCommonList;
  String? get errorCommonList => _errorCommonList ?? Const.errSomethingWrong;

  Extra? _extraCommonList;
  Extra? get extraCommonList => _extraCommonList;


  List<TradingRes>? _playTraders;
  List<TradingRes>? get playTraders => _playTraders;

  int _page = 1;

  TextEditingController date = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController txnSizeController = TextEditingController();


  void setStatusTradeExecuted(status) {
    _statusCommonList = status;
    notifyListeners();
  }

  String dateSend = "";
  String valueSearch = "";
  String keyRank = "";
  String valueRank = "";

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      date.text = DateFormat("MMM dd, yyyy").format(picked);
      dateSend = DateFormat("yyyy-MM-dd").format(picked);
    }

    notifyListeners();
  }

  Future<void> pickTradingDate({String? userID}) async {
    DateTime selectedDate = DateTime.now();
    if(dateSend!=""){
      selectedDate= DateFormat("yyyy-MM-dd").parse(dateSend);
    }

    final DateTime? picked = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      date.text = DateFormat("MMM dd, yyyy").format(picked);
      dateSend = DateFormat("yyyy-MM-dd").format(picked);
      getUserDetail(userID: userID, clear: false);
      notifyListeners();
    }
    else{
      if(dateSend!=""){
        getUserDetail(userID: userID, clear: true);
        notifyListeners();
      }
    }

  }

  void _clearVariables() {
    dateSend = "";
    valueSearch = "";
    valueRank = "";
    keyRank = "";
    date.clear();
    searchController.clear();
    txnSizeController.clear();
    notifyListeners();
  }

  void onChangeTransactionSize({KeyValueElement? selectedItem}) {
    keyRank = selectedItem?.key ?? "";
    valueRank = selectedItem?.value ?? "";
    txnSizeController.text = selectedItem?.value ?? "";
    notifyListeners();
  }

  String getApiUrl(TournamentsHead tournament) {
    switch (tournament) {
      case TournamentsHead.tradTotal:
        return "${Apis.tTradingTotal}?date=$dateSend";
      case TournamentsHead.pPaid:
        return "${Apis.tPointsPaid}?date=$dateSend";
      case TournamentsHead.playTraders:
        return "${Apis.tPlayTraders}?s=$valueSearch&rank=$keyRank";

      case TournamentsHead.topTitan:
        return "${Apis.tTopTitans}?s=$valueSearch&rank=$keyRank";
    }
  }

  LeagueTitanRes? _leagueTitanRes;
  LeagueTitanRes? get leagueTitanRes => _leagueTitanRes;

  bool get canLoadMore => _page <= (_leagueTitanRes?.totalPages ?? 1);

  Future getAllTitans(
      {loadMore = false, bool clear = true,
      required TournamentsHead selectedTournament}) async {
    if (loadMore) {
      _page++;
      setStatusTradeExecuted(Status.loadingMore);
    } else {
      _page = 1;
      setStatusTradeExecuted(Status.loading);
    }

    if (clear) _clearVariables();
    try {
      Map request = {
        'page': '$_page',
      };
      ApiResponse response = await apiRequest(
        url: getApiUrl(selectedTournament),
        showProgress: false,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _leagueTitanRes = leagueTitanResFromMap(jsonEncode(response.data));
          if(_leagueTitanRes?.data==null){
            _errorCommonList = response.message;
          }
        }
        else {
          _leagueTitanRes?.data?.addAll(leagueTitanResFromMap(jsonEncode(response.data)).data ?? []);
        }

      } else {
        if (_page == 1) {
          _leagueTitanRes = null;
          _errorCommonList = response.message;
        }
      }

    } catch (e) {
      _leagueTitanRes = null;
      _errorCommonList = Const.errSomethingWrong;
      Utils().showLog('join error $e');
    }
    finally {
      setStatusTradeExecuted(Status.loaded);
    }
  }

  /// league redirection to leaderboard
  void leagueToLeaderboard({String? selectedDate}) {
    if (selectedDate != null && selectedDate.isNotEmpty) {
      DateFormat inputFormat = DateFormat("MM/dd/yyyy");
      DateTime dateTime = inputFormat.parse(selectedDate);

      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      String formattedDate = outputFormat.format(dateTime);
      DateTime dateTime1 = outputFormat.parse(formattedDate);

      LeaderboardManager manager = navigatorKey.currentContext!.read<LeaderboardManager>();
      manager.getEditedDate(dateTime1);
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushNamed(
          navigatorKey.currentContext!,
          TradingLeagueIndex.path,
          arguments: {'initialIndex':1}
      );

    } else {
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushNamed(
          navigatorKey.currentContext!,
          TradingLeagueIndex.path,
          arguments: {'initialIndex':1}
      );
    }
  }

  /// profile redirection
  void profileRedirection({String? userId}) {
    Navigator.pushNamed(navigatorKey.currentContext!,
        LeagueUserDetail.path,
        arguments: {
          "userId": userId,
        });
  }




  AllTradesRes? _allTrades;
  AllTradesRes? get allTrades => _allTrades;

  List<RecentBattlesRes>? _allBattles;
  List<RecentBattlesRes>? get allBattles => _allBattles;

  String? _errorTradeList;
  String? get errorTradeList => _errorTradeList ?? Const.errSomethingWrong;


  Status _statusTradeList = Status.ideal;
  Status get statusTradeList => _statusTradeList;
  bool get isLoadingTradeList => _statusTradeList == Status.loading;
  bool get canLoadMoreTrade => _page <= (_allTrades?.totalPages ?? 1);

  void setStatusUserData(status) {
    _statusUserData = status;
    notifyListeners();
  }

  void setStatusTrade(status) {
    _statusTradeList = status;
    notifyListeners();
  }

  int _pageProfile = 1;
  Status _statusUserData = Status.ideal;
  Status get statusUserData => _statusUserData;

  bool get isLoadingUserData =>
      _statusUserData == Status.loading || _statusUserData == Status.ideal;

  String? _errorUserData;
  String? get errorUserData => _errorUserData ?? Const.errSomethingWrong;

  LeagueUserDetailRes? _userData;
  LeagueUserDetailRes? get userData => _userData;
  bool get canLoadMoreProfile => _pageProfile <= (_userData?.totalPages ?? 1);


  Future getUserDetail({loadMore = false, bool clear = true, String? userID}) async {
    if (loadMore) {
      _pageProfile++;
      setStatusUserData(Status.loadingMore);
    } else {
      _pageProfile = 1;
      setStatusUserData(Status.loading);
    }

    if (clear) _clearVariables();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "user_id": userID ?? "",
        'page': '$_pageProfile',
        'date': dateSend,
      };
      ApiResponse response = await apiRequest(
        url: Apis.tUser,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        if (_pageProfile == 1) {
          _userData = leagueUserDetailResFromJson(jsonEncode(response.data));
          if (_userData?.recentTrades?.dataTrade != null &&
              _userData?.recentTrades?.dataTrade!.isNotEmpty == true) {
            _startSseTrades();
          }
          _errorUserData = null;
        } else {
          var newEntries =
          leagueUserDetailResFromJson(jsonEncode(response.data));
          _userData?.recentBattles?.data
              ?.addAll(newEntries.recentBattles?.data ?? []);
        }
      } else {
        if (_pageProfile == 1) {
          _userData = null;
        }
        _errorUserData = response.message ?? Const.errSomethingWrong;
      }
      setStatusUserData(Status.loaded);
    } catch (e) {
      _userData = null;

      _errorUserData = Const.errSomethingWrong;
      Utils().showLog('Error getDashboardData $e');
      setStatusUserData(Status.loaded);
    }
  }

  Future tradeWithDateAll({loadMore = false, String? selectedBattleID}) async {
    if (loadMore) {
      _page++;
      setStatusTrade(Status.loadingMore);
    } else {
      _page = 1;
      setStatusTrade(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map requst = {
        'token': provider.user?.token ?? '',
        'tournament_battle_id': '$selectedBattleID',
        'user_id': _userData?.userStats?.userId ?? "",
        'page': '$_page',
      };
      ApiResponse response = await apiRequest(
        url: Apis.tTradeAll,
        showProgress: false,
        request: requst,
      );

      if (response.status) {
        if (_page == 1) {
          _allTrades = allTradesResFromJson(jsonEncode(response.data));
          if (_allTrades != null && _allTrades!.data?.isNotEmpty == true) {
            _startSseTradesAll();
          }
          if(_allTrades?.data==null){
            _errorTradeList = response.message;
          }

        } else {
          _allTrades?.data?.addAll(allTradesResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_page == 1) {
          _allTrades = null;
          _errorTradeList = response.message;
        }
      }
      setStatusTrade(Status.loaded);
    } catch (e) {
      _allTrades = null;
      _errorTradeList = Const.errSomethingWrong;

      Utils().showLog('join error $e');
      setStatusTrade(Status.loaded);
    }
  }

  void _startSseTrades() {
    List<String>? symbols;
    if (_userData?.recentTrades?.dataTrade != null &&
        _userData?.recentTrades?.dataTrade!.isNotEmpty == true) {
      symbols = _userData?.recentTrades?.dataTrade
          ?.where((trade) => trade.status == 0 && trade.symbol != null)
          .map((trade) => trade.symbol!)
          .toList();
    }

    if (_userData?.recentTrades?.dataTrade != null) {
      List<BaseTickerRes> dataTrade = _userData?.recentTrades?.dataTrade ?? [];

      for (var data in dataTrade) {
        num currentPrice = data.price ?? 0;
        num orderPrice = data.orderPrice ?? 0;
        if (data.status == 0) {
          if (symbols != null && symbols.isNotEmpty == true) {
            if (data.type == "buy") {
              data.performance = orderPrice == 0 || currentPrice == 0
                  ? 0
                  : (((currentPrice - orderPrice) / orderPrice) * 100);
              data.gainLoss = orderPrice == 0 || currentPrice == 0
                  ? 0
                  : (currentPrice - orderPrice);
            } else {
              data.performance = currentPrice == 0 || orderPrice == 0
                  ? 0
                  : (((orderPrice - currentPrice) / currentPrice) * 100);
              data.gainLoss = orderPrice == 0 || currentPrice == 0
                  ? 0
                  : (orderPrice - currentPrice);
            }
            notifyListeners();
            SSEManager.instance.connectMultipleStocks(
              symbols: symbols,
              screen: SimulatorEnum.tournament,
            );

            SSEManager.instance.addListener(
              data.symbol ?? '',
              (stockData) {
                num? newPrice = stockData.price;
                if (newPrice != null) {
                  if (data.type == "buy") {
                    data.performance =
                        (((newPrice - orderPrice) / orderPrice) * 100);
                    data.gainLoss = (newPrice - orderPrice);
                  } else {
                    data.performance =
                        (((orderPrice - newPrice) / newPrice) * 100);
                    data.gainLoss = (orderPrice - newPrice);
                  }
                  //   data.gainLoss = (newPrice - orderPrice);
                  data.price = newPrice;
                }
                Utils().showLog(
                    'Recent Activities ${data.symbol}, ${data.performance}, ${data.gainLoss}, ${data.price}');
                notifyListeners();
              },
              SimulatorEnum.tournament,
            );
          }
        } else {}
      }
    }
  }

  void _startSseTradesAll() {
    List<String>? symbols;
    if (_allTrades != null && _allTrades?.data!.isNotEmpty == true) {
      symbols = _allTrades?.data
          ?.where((trade) => trade.status == 0 && trade.symbol != null)
          .map((trade) => trade.symbol!)
          .toList();
    }

    if (_allTrades != null) {
      List<BaseTickerRes> dataTrade = _allTrades?.data ?? [];

      for (var data in dataTrade) {
        num currentPrice = data.price ?? 0;
        num orderPrice = data.orderPrice ?? 0;
        if (data.status == 0) {
          if (symbols != null && symbols.isNotEmpty == true) {
            if (data.type == "buy") {
              data.performance = orderPrice == 0 || currentPrice == 0
                  ? 0
                  : (((currentPrice - orderPrice) / orderPrice) * 100);
              data.gainLoss = orderPrice == 0 || currentPrice == 0
                  ? 0
                  : (currentPrice - orderPrice);
            } else {
              data.performance = currentPrice == 0 || orderPrice == 0
                  ? 0
                  : (((orderPrice - currentPrice) / currentPrice) * 100);
              data.gainLoss = orderPrice == 0 || currentPrice == 0
                  ? 0
                  : (orderPrice - currentPrice);
            }
            notifyListeners();
            SSEManager.instance.connectMultipleStocks(
              symbols: symbols,
              screen: SimulatorEnum.tournamentTrade,
            );
            SSEManager.instance.addListener(
              data.symbol ?? '',
              (stockData) {
                num? newPrice = stockData.price;
                if (newPrice != null) {
                  if (data.type == "buy") {
                    data.performance =
                        (((newPrice - orderPrice) / orderPrice) * 100);
                    data.gainLoss = (newPrice - orderPrice);
                  } else {
                    data.performance =
                        (((orderPrice - newPrice) / newPrice) * 100);
                    data.gainLoss = (orderPrice - newPrice);
                  }
                  data.price = newPrice;
                }
                Utils().showLog(
                    'Recent Activities of All trade ${data.symbol}, ${data.performance}, ${data.gainLoss}, ${data.price}');
                notifyListeners();
              },
              SimulatorEnum.tournamentTrade,
            );
          }
        } else {}
      }
    }
  }

 /* void tickerDetailRedirection(String symbol) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => StockDetail(symbol: symbol)),
    );
  }*/

  void tradesRedirection(String selectedBattleID) {
    Navigator.pushNamed(navigatorKey.currentContext!,
        TradesWithDate.path,
        arguments: {
          "selectedBattleID": selectedBattleID,
        });
  }
}
