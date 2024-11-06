import 'dart:async';

import 'package:flutter/material.dart';

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

  List<ArenaTournamentRes> _tournamentHeader = [];
  List<ArenaTournamentRes> get tournamentHeader => _tournamentHeader;

  List<ArenaTournamentRes> _tournaments = [];
  List<ArenaTournamentRes> get tournaments => _tournaments;

  getTournamentData() {
    _tournamentHeader = [];
    _tournaments = [];
    notifyListeners();

    List<ArenaTournamentRes> data = [
      ArenaTournamentRes(label: 'TRADES', value: '6,317,941'),
      ArenaTournamentRes(label: 'CASH PAID', value: '\$1,39,000'),
      ArenaTournamentRes(label: 'PLAY TRADERS', value: '47,002'),
    ];

    List<ArenaTournamentRes> tournamentsData = [
      ArenaTournamentRes(label: 'Day Training', value: '1,000'),
      ArenaTournamentRes(label: 'Top Stocks', value: '\$500'),
    ];

    _tournamentHeader.addAll(data);
    _tournaments.addAll(tournamentsData);
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
}

class ArenaTournamentRes {
  String? label;
  String? value;
  ArenaTournamentRes({
    this.label,
    this.value,
  });
}
