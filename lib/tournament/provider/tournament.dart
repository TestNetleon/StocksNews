import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/tournament_user_detail.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../providers/user_provider.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../models/tournament.dart';
import '../models/tournament_detail.dart';
import '../screens/game_tournament_index.dart';
import '../screens/tournaments/dayTraining/open/index.dart';

class TournamentProvider extends ChangeNotifier {
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
      startCountdown();
    } else {
      _timer?.cancel();
    }
  }

  void startCountdown() async {
    DateTime? start = _detailRes?.battleTime?.startTime;
    DateTime? end = _detailRes?.battleTime?.endTime;

    DateTime? serverTime = _detailRes?.battleTime?.currentTime;
    // DateTime mockTime = DateTime(2025, 01, 09, 15, 59, 55);
    // serverTime = mockTime;
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
      notifyListeners();
    }
  }

  void _startTimer(Duration initialDuration, {required bool isStart}) {
    // Set initial time
    hours = initialDuration.inHours;
    minutes = initialDuration.inMinutes % 60;
    seconds = initialDuration.inSeconds % 60;

    // Start the periodic timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (hours == 0 && minutes == 0 && seconds == 0) {
        // Stop the timer when countdown reaches zero
        stopCountdown();

        // Call the respective API for start or end
        if (isStart) {
          tournamentDetail(_id);
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
              Navigator.push(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(
                    builder: (context) => GameTournamentIndex(setIndex: 1),
                  ));
            },
          );
        }
      } else {
        // Decrement the countdown
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

// TOURNAMENT
  Status _statusTournament = Status.ideal;
  Status get statusTournament => _statusTournament;

  bool get isLoadingTournament =>
      _statusTournament == Status.loading || _statusTournament == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  TournamentRes? _data;
  TournamentRes? get data => _data;

  Extra? _extra;
  Extra? get extra => _extra;

  /// extra for point_paid
  Extra? _extraOfPointPaid;
  Extra? get extraOfPointPaid => _extraOfPointPaid;

  void setStatusTournament(status) {
    _statusTournament = status;
    notifyListeners();
  }

// MARK: TOURNAMENT
  Future tournament() async {
    _data = null;
    setStatusTournament(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };
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
      _extra = (response.extra is Extra ? response.extra as Extra : null);

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

  TournamentDetailRes? _detailRes;
  TournamentDetailRes? get detailRes => _detailRes;

  void setStatusDetail(status) {
    _statusDetail = status;
    notifyListeners();
  }

  int? _id;
// MARK: DETAIL
  Future tournamentDetail(int? id, {bool timerSet = true}) async {
    _id = id;
    setStatusDetail(Status.loading);
    try {
      UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
      Map request = {
        'token': user?.token ?? '',
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
      setStatusDetail(Status.loaded);
    } catch (e) {
      Utils().showLog('error in detail $e');
      _error = Const.errSomethingWrong;
      _detailRes = null;
      setStatusDetail(Status.loaded);
    }
  }

// MARK: JOIN
  Future joinTounament({int? id}) async {
    try {
      UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;

      Map requst = {
        'token': user?.token ?? '',
        'tournament_battle_id': '${_detailRes?.tournamentBattleId ?? ''}',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tJoin,
        showProgress: true,
        request: requst,
      );
      if (response.status) {
        tournamentDetail(_id);
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => TournamentOpenIndex(),
          ),
        );
      } else {
        showErrorMessage(message: response.message);
      }
    } catch (e) {
      //
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

  List<LeaderboardByDateRes>? _pointsPaid;
  List<LeaderboardByDateRes>? get tradesExecuted => _pointsPaid;

  /// value as per _playTraders

  List<LeaderboardByDateRes>? _playTraders;
  List<LeaderboardByDateRes>? get playTraders => _playTraders;

  int _page = 1;
  /// value as per _extraOfPointPaid
  bool get canLoadMore => _page <= (_extraOfPointPaid?.totalPages ?? 1);

  void setStatusTradeExecuted(status) {
    _statusCommonList = status;
    notifyListeners();
  }

  String getApiUrl(TournamentsHead tournament) {
    switch (tournament) {
      case TournamentsHead.tradTotal:
        return Apis.tTradingTotal;
      case TournamentsHead.pPaid:
        return Apis.tPointsPaid;
      case TournamentsHead.playTraders:
        return Apis.tPlayTraders;
      }
  }

  Future pointsPaidAPI({loadMore = false, required TournamentsHead selectedTournament}) async {
    if (loadMore) {
      _page++;
      setStatusTradeExecuted(Status.loadingMore);
    } else {
      _page = 1;
      setStatusTradeExecuted(Status.loading);
    }

    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

      Map requst = {
        'token': provider.user?.token ?? '',
        'page': '$_page',
      };
      ApiResponse response = await apiRequest(
        url:getApiUrl(selectedTournament),
        showProgress: false,
        request: requst,
      );
      if (response.status) {
        if (_page == 1) {
          // Parse as a list of leaderboard entries
          _pointsPaid = leaderboardByDateResFromJson(jsonEncode(response.data));
          _errorCommonList = null;
        } else {
          var newEntries =
              leaderboardByDateResFromJson(jsonEncode(response.data));
          _pointsPaid?.addAll(newEntries);
        }
      } else {
        if (_page == 1) {
          _pointsPaid = null;
          _errorCommonList = response.message;
        }
      }
      /// get extra point values
      _extraOfPointPaid = (response.extra is Extra ? response.extra as Extra : null);
      setStatusTradeExecuted(Status.loaded);
    } catch (e) {
      _pointsPaid = null;
      _errorCommonList = Const.errSomethingWrong;

      Utils().showLog('join error $e');
      setStatusTradeExecuted(Status.loaded);
    }
  }

  /// league redirection to leaderboard
 void leagueToLeaderboard({String? selectedDate}){

   DateFormat inputFormat = DateFormat("MM/dd/yyyy");
   DateTime dateTime = inputFormat.parse(selectedDate!);

   DateFormat outputFormat = DateFormat("yyyy-MM-dd");
   String formattedDate = outputFormat.format(dateTime);
   DateTime dateTime1 = outputFormat.parse(formattedDate);

   TournamentLeaderboardProvider provider = navigatorKey.currentContext!.read<TournamentLeaderboardProvider>();
   provider.getEditedDate(dateTime1);
   Navigator.popUntil(
       navigatorKey.currentContext!, (route) => route.isFirst);
   Navigator.push(
       navigatorKey.currentContext!,
       MaterialPageRoute(
         builder: (context) => GameTournamentIndex(setIndex: 1),
       ));
 }

 /// profile redirection
 void pointPaidTraderToLeaderboard({String? userName}){
   Navigator.push(
       navigatorKey.currentContext!,
       MaterialPageRoute(
         builder: (context) => TournamentUserDetail(userName:userName),
       ));

 }
}
