import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../models/lock.dart';
import '../../models/signals/sentiment.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../user.dart';

class SignalsSentimentManager extends ChangeNotifier {
  void clearAllData() {
    _data = null;
    notifyListeners();
  }

  String? _error;
  String? get error => _error;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading;

  SignalSentimentRes? _data;
  SignalSentimentRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData({
    int dataAll = 1,
    num days = 1,
    bool loadFull = true,
  }) async {
    try {
      if (loadFull) setStatus(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      request['all_data'] = '$dataAll';
      request['days'] = '$days';

      ApiResponse response = await apiRequest(
        url: Apis.signalSentiment,
        request: request,
        showProgress: !loadFull,
      );
      if (response.status) {
        if (dataAll == 1) {
          _data = signalSentimentResFromJson(jsonEncode(response.data));
          // _lockSentiment = _data?.lockInfo;
        } else {
          _data?.mostMentions?.data =
              signalSentimentResFromJson(jsonEncode(response.data))
                  .mostMentions
                  ?.data;
        }
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error on ${Apis.signalSentiment}: $e');
    } finally {
      if (loadFull) {
        setStatus(Status.loaded);
      } else {
        notifyListeners();
      }
    }
  }

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _data?.lockInfo;
    return info;
  }

  void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {
    if (_data?.recentMentions?.data != null) {
      final index = _data?.recentMentions?.data
          ?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _data?.recentMentions?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _data?.recentMentions?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
    if (_data?.mostMentions?.data != null) {
      final index = _data?.mostMentions?.data
          ?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _data?.mostMentions?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _data?.mostMentions?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
  }
}
