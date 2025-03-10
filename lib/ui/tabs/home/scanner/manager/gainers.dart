import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../../../routes/my_app.dart';
import '../../../tools/scanner/manager/scanner.dart';
import '../data/gainers.dart';

class HomeGainersManager extends ChangeNotifier {
  Status _status = Status.ideal;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  List<OfflineScannerRes>? _offlineDataList;
  List<OfflineScannerRes>? get offlineDataList => _offlineDataList;

  List<LiveScannerRes>? _dataList;
  List<LiveScannerRes>? get dataList => _dataList;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void startListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    notifyListeners();
    HomeGainersStream().initializePorts();
  }

  setTotalResult(num total) {
    navigatorKey.currentContext!.read<ScannerManager>().setTotalResults(total);
  }

  void stopListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    HomeGainersStream().stopListeningPorts();
  }

  void updateOfflineData(List<OfflineScannerRes>? data, {applyFilter = false}) {
    updateOfflineDataFilter(data);
    notifyListeners();
  }

  void updateOfflineDataFilter(List<OfflineScannerRes>? data) {
    if (data == null) return;

    data.sort((a, b) {
      num valueA = a.ext?.extendedHoursPercentChange ?? 0;
      num valueB = b.ext?.extendedHoursPercentChange ?? 0;

      return valueB.compareTo(valueA);
    });

    _offlineDataList = List.empty(growable: true);
    _offlineDataList?.addAll(data);
    notifyListeners();
    setTotalResult(_offlineDataList?.length ?? 0);
  }

  Future updateData(List<LiveScannerRes>? data) async {
    if (data == null) return;

    List<LiveScannerRes> prChangeAr = data;

    Utils().showLog("-----------------------------------------------");
    prChangeAr.sort((a, b) {
      num valueA = a.percentChange ?? 0;
      num valueB = b.percentChange ?? 0;
      if ((a.extendedHoursType == "PostMarket" ||
          a.extendedHoursType == "PreMarket")) {
        Utils().showLog("++++++++++++++++++++++++++++++++");
        valueA = a.extendedHoursPercentChange ?? 0;
        valueB = b.extendedHoursPercentChange ?? 0;
      }

      return valueB.compareTo(valueA);
    });

    _dataList = prChangeAr;
    notifyListeners();

    setTotalResult(_dataList?.length ?? 0);
  }
}
