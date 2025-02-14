import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SignalsManager extends ChangeNotifier {
  //MARK: Signals
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<String> tabs = ['Stocks', 'Sentiment', 'Insiders', 'Politicians'];

  setStatus(status) {
    _status = status;
    notifyListeners();
  }
}
