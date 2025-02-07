import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/models/battle_res.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../providers/user_provider.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../models/leaderboard.dart';

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

  List<LeaderboardByDateRes?> topPerformers = [];
  List<LeaderboardByDateRes?> allData=[];
  bool isTopPerformer=false;
  Future leaderboard({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatusLeaderboard(Status.loadingMore);
    } else {
      _page = 1;
      setStatusLeaderboard(Status.loading);
    }
    topPerformers=[];
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
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

        /*  for (int i = 0; i < (_leaderboardRes?.leaderboardByDate?.length ?? 0); i++) {
            LeaderboardByDateRes? data = _leaderboardRes?.leaderboardByDate?[i];
            if (data == null) continue;
            isTopPerformer = (data.performance ?? 0) > 0;
            if (isTopPerformer && topPerformers.length <3){
              topPerformers.add(data);
            }
          }*/
          print(topPerformers.length);
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
