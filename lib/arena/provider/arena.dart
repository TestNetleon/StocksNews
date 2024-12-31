import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';

import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../providers/user_provider.dart';
import '../../routes/my_app.dart';
import '../../tradingSimulator/modals/trading_search_res.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../models/leaderboard.dart';
import '../models/tournament.dart';
import '../models/tournament_detail.dart';

class ArenaProvider extends ChangeNotifier {
  int selectedTab = 0;

  onTabChange(index) {
    selectedTab = index;
    notifyListeners();
  }

  List<String> tabs = [
    'Tournaments',
    'Leaderboard',
    'Trades',
  ];

  getTournamentData() {
    tournament();
    timer(true);
    notifyListeners();
  }

  int hours = 24;
  int minutes = 0;
  int seconds = 0;
  Timer? _timer;

  timer(bool start) {
    if (start) {
      _timer?.cancel();
      hours = 24;
      minutes = 0;
      seconds = 0;
      _startCountdown();
    } else {
      _timer?.cancel();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (hours == 0 && minutes == 0 && seconds == 0) {
        _timer?.cancel();
      } else {
        if (seconds > 0) {
          seconds--;
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
      }
      notifyListeners();
    });
  }

  Map<String, String> get timeRemaining {
    return {
      'hours': hours.toString().padLeft(2, '0'),
      'minutes': minutes.toString().padLeft(2, '0'),
      'seconds': seconds.toString().padLeft(2, '0'),
    };
  }
// TOP STOCKS

  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TradingSearchTickerRes>? _topSearch;
  List<TradingSearchTickerRes>? get topSearch => _topSearch;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

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
        _topSearch = tradingSearchTickerResFromJson(jsonEncode(response.data));
      } else {
        _topSearch = null;
      }
      setStatus(Status.ideal);
    } catch (e) {
      _topSearch = null;
      Utils().showLog(e.toString());
      setStatus(Status.ideal);
    }
  }

// ARENA TOURNAMENT
  Status _statusTournament = Status.ideal;
  Status get statusTournament => _statusTournament;

  bool get isLoadingTournament =>
      _statusTournament == Status.loading || _statusTournament == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  TournamentRes? _data;
  TournamentRes? get data => _data;

  void setStatusTournament(status) {
    _statusTournament = status;
    notifyListeners();
  }

  Future tournament() async {
    _data = null;
    setStatusTournament(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };
      ApiResponse response = await apiRequest(
        url: Apis.tournament,
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

//ARENA LEADERBOARD
  int _page = 1;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);

  Extra? _extra;
  Extra? get extra => _extra;

  Status _statusLeaderboard = Status.ideal;
  Status get statusLeaderboard => _statusLeaderboard;

  bool get isLoadingLeaderboard =>
      _statusLeaderboard == Status.loading ||
      _statusLeaderboard == Status.ideal;

  String? _errorLeaderboard;
  String? get errorLeaderboard => _errorLeaderboard ?? Const.errSomethingWrong;

  TournamentLeaderboardRes? _leaderboardRes;
  TournamentLeaderboardRes? get leaderboardRes => _leaderboardRes;

  void setStatusLeaderboard(status) {
    _statusLeaderboard = status;
    notifyListeners();
  }

  String? selectedDate;

  getSelectedDate(DateTime date) {
    String newDate = DateFormat('yyyy-MM-dd').format(date);
    selectedDate = newDate;
  }

  Future leaderboard({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatusLeaderboard(Status.loadingMore);
    } else {
      _page = 1;
      setStatusLeaderboard(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": '$_page',
        "date": selectedDate,
      };
      ApiResponse response = await apiRequest(
        url: Apis.tournamentLeaderboard,
        request: request,
      );

      if (response.status) {
        if (_page == 1) {
          _leaderboardRes =
              tournamentLeaderboardResFromJson(jsonEncode(response.data));
          _extra = response.extra is Extra ? response.extra : null;
        } else {
          _leaderboardRes?.leaderboardByDate?.addAll(
            tournamentLeaderboardResFromJson(jsonEncode(response.data))
                    .leaderboardByDate ??
                [],
          );
        }
      } else {
        if (_page == 1) {
          _leaderboardRes = null;

          _errorLeaderboard = response.message;
        }
      }
      setStatusLeaderboard(Status.loaded);
    } catch (e) {
      _leaderboardRes = null;
      _errorLeaderboard = Const.errSomethingWrong;
      setStatusLeaderboard(Status.loaded);
      Utils().showLog('error $e');
    }
  }

// TOURNAMENT DETAIL

  Status _statusDetail = Status.ideal;
  Status get statusDetail => _statusDetail;

  bool get isLoadingDetail =>
      _statusDetail == Status.loading || _statusDetail == Status.ideal;

  String? _errorDetail;
  String? get errorDetail => _errorDetail ?? Const.errSomethingWrong;

  TournamentDetailRes? _detailRes;
  TournamentDetailRes? get detailRes => _detailRes;

  void setStatusDetail(status) {
    _statusDetail = status;
    notifyListeners();
  }

  Future tournamentDetail(int? id) async {
    setStatusDetail(Status.loading);
    try {
      UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
      Map request = {
        'token': user?.token ?? '',
        'tournament_id': '${id ?? ''}',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tournamentDetail,
        request: request,
      );
      if (response.status) {
        _detailRes = tournamentDetailResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _detailRes = null;
        _error = response.message;
      }
      setStatusDetail(Status.loaded);
    } catch (e) {
      Utils().showLog('error in detail $e');
      _error = Const.errSomethingWrong;
      _detailRes = null;
      setStatusDetail(Status.loaded);
    }
  }
}

class ArenaTournamentRes {
  String? label;
  String? value;
  ArenaTournamentRes({
    this.label,
    this.value,
  });
}
