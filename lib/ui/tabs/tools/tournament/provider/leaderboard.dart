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
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/battle_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/trading_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';


class TournamentLeaderboardProvider extends ChangeNotifier {
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


  BattleRes? _battleRes;
  BattleRes? get battleRes => _battleRes;

  String? _errorBattels;
  String? get errorBattels => _errorBattels ?? Const.errSomethingWrong;

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

          _extra = response.extra is Extra ? response.extra : null;
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
        _errorBattels = response.message;
      }
      setStatusBattle(Status.loaded);
    } catch (e) {
      _battleRes = null;
      _errorBattels = Const.errSomethingWrong;
      setStatusBattle(Status.loaded);
      Utils().showLog('error $e');
    }
  }

}
