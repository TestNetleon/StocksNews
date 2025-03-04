import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/ai_analysis.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../utils/constants.dart';
import '../user.dart';

class AIManager extends ChangeNotifier {
  //MARK: AI
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  AIRes? _data;
  AIRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getAIData(String symbol) async {
    _data = null;
    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.aiAnalysis,
        request: request,
      );
      if (response.status) {
        _data = AIResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.aiAnalysis} $e');
    } finally {
      setStatus(Status.loaded);
    }
  }
}
