import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/battle_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';


class LeaderboardManager extends ChangeNotifier {
  int _page = 1;
  bool get canLoadMore => _page < (_leaderboardRes?.totalPages ?? 1);

  Status _statusLeaderboard = Status.ideal;
  Status get statusLeaderboard => _statusLeaderboard;

  bool get isLoadingLeaderboard =>
      _statusLeaderboard == Status.loading ||
      _statusLeaderboard == Status.ideal;

  String? _errorLeaderboard;
  String? get errorLeaderboard => _errorLeaderboard ?? Const.errSomethingWrong;

  LeagueLeaderboardRes? _leaderboardRes;
  LeagueLeaderboardRes? get leaderboardRes => _leaderboardRes;


  BattleRes? _battleRes;
  BattleRes? get battleRes => _battleRes;

  String? _errorBattle;
  String? get errorBattle => _errorBattle ?? Const.errSomethingWrong;

  void setStatusLeaderboard(status) {
    _statusLeaderboard = status;
    notifyListeners();
  }
  Status _statusBattle = Status.ideal;
  Status get statusBattle => _statusBattle;
  bool get isLoadingBattle =>
      _statusBattle == Status.loading ||
          _statusBattle == Status.ideal;

  void setStatusBattle(status) {
    _statusBattle = status;
  }

  String? selectedDate;
  DateTime? editedDate;

  getSelectedDate(DateTime date) {
    String newDate = DateFormat('yyyy-MM-dd').format(date);
    selectedDate = newDate;
  }
  getEditedDate(DateTime date) {
    editedDate = date;
    notifyListeners();
  }
   clearEditedDate(){
    editedDate = null;
  }

  List<TradingRes?> topPerformers = [];
  List<TradingRes?> allData=[];
  bool isTopPerformer=false;
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
        "token": navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "page": '$_page',
        "date": selectedDate,
      };
      ApiResponse response = await apiRequest(
        url: Apis.tLeaderboard,
        request: request,
      );

      if (response.status) {
        if (_page == 1) {
          _leaderboardRes = tournamentLeaderboardResFromJson(jsonEncode(response.data));
          topPerformers = (_leaderboardRes?.leaderboardByDate ?? [])
              .where((data) => (data.performance ?? 0) > 0)
              .take(3)
              .toList();
        } else {
          _leaderboardRes?.leaderboardByDate?.addAll(tournamentLeaderboardResFromJson(jsonEncode(response.data)).leaderboardByDate ?? [],
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

  Future showLeaderboard() async {
    setStatusBattle(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tShowLeaderboard,
      );
      if (response.status) {
        _battleRes = battleResFromMap(jsonEncode(response.data));
        notifyListeners();
      } else {
        _battleRes = null;
        _errorBattle = response.message;
      }
      setStatusBattle(Status.loaded);
    } catch (e) {
      _battleRes = null;
      _errorBattle = Const.errSomethingWrong;
      setStatusBattle(Status.loaded);
      Utils().showLog('error $e');
    }
  }

}
