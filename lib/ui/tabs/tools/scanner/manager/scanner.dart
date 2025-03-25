import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/losers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/screens/extra/sorting_list.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../../../api/apis.dart';
import '../../../../../managers/user.dart';
import '../../../../../models/lock.dart';
import '../../../../../routes/my_app.dart';
import '../../../../../utils/constants.dart';
import '../data/scanner.dart';
import '../models/filter_sectors.dart';
import '../models/scanner_port.dart';
import 'filters.dart';

enum SortByEnums {
  symbol,
  company,
  sector,
  lastTrade,
  netChange,
  perChange,
  volume,
  dollarVolume,
  bid,
  ask,
  postMarket,
  postMarketNetChange,
  postMarketPerChange,
}

class ScannerManager extends ChangeNotifier {
//MARK: Call API
  int selectedIndex = -1;

  bool _usingFilter = false;
  bool get usingFilter => _usingFilter;

  setUsingFilter(value) {
    _usingFilter = value;
    notifyListeners();
  }

  onTabChange(index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      selectedSubIndex = 0;
      notifyListeners();
      onRefresh(withPortRefresh: false);
    }
  }

  onRefresh({bool withPortRefresh = true}) async {
    if (withPortRefresh) {
      await getScannerPorts(showProgress: true);
    }
    if (_portData?.lockInfo != null) return;
    setUsingFilter(false);
    ScannerGainersManager gainersManager =
        navigatorKey.currentContext!.read<ScannerGainersManager>();
    ScannerLosersManager losersManager =
        navigatorKey.currentContext!.read<ScannerLosersManager>();
    stopListeningPorts();
    gainersManager.stopListeningPorts();
    losersManager.stopListeningPorts();
    setTotalResults(0);
    switch (selectedIndex) {
      case 0:
        setSortingApplied(false);

        if (_portData?.port?.checkMarketOpenApi?.scannerStatus == 1) {
          return;
        }

        Future.delayed(
          Duration(milliseconds: 100),
          () {
            startListeningPorts();
          },
        );
        break;

      case 1:
        if (_portData?.port?.checkMarketOpenApi?.gainerStatus == 1) {
          return;
        }
        setSortingApplied(true);

        gainersManager.resetLiveFilter();
        Future.delayed(
          Duration(milliseconds: 100),
          () {
            gainersManager.startListeningPorts();
          },
        );

        break;

      case 2:
        if (_portData?.port?.checkMarketOpenApi?.loserStatus == 1) {
          return;
        }

        setSortingApplied(true);

        losersManager.resetLiveFilter();

        Future.delayed(
          Duration(milliseconds: 100),
          () {
            losersManager.startListeningPorts();
          },
        );
        break;

      default:
    }
  }

//MARK: Sub Tab

  int selectedSubIndex = -0;
  onSubTabChange(index) {
    if (selectedIndex == 0) return;

    selectedSubIndex = index;
    notifyListeners();
    CheckMarketOpenRes? data = _portData?.port?.checkMarketOpenApi;
    if (data == null) return;

    ScannerGainersManager gainersManager =
        navigatorKey.currentContext!.read<ScannerGainersManager>();

    ScannerLosersManager losersManager =
        navigatorKey.currentContext!.read<ScannerLosersManager>();
    switch (index) {
      case 0:
        if (selectedIndex == 1) {
          gainersManager.applyFilter(2);
        } else {
          losersManager.applyFilter(2);
        }

        break;

      case 1:
        if (selectedIndex == 1) {
          gainersManager.applyFilter(3);
        } else {
          losersManager.applyFilter(3);
        }
        break;
      default:
    }
  }

//MARK: Sorting
  String? totalResult;
  bool _sortingApplied = false;
  bool get sortingApplied => _sortingApplied;

  setSortingApplied(bool applied) {
    _sortingApplied = applied;
    notifyListeners();
  }

  setTotalResults(num total) {
    totalResult = '$total';
    notifyListeners();
  }

  sorting() {
    bool preMarket = false;
    bool postMarket = false;
    bool showSector = true;
    String? text;

    ScannerGainersManager gainersManager =
        navigatorKey.currentContext!.read<ScannerGainersManager>();
    ScannerLosersManager losersManager =
        navigatorKey.currentContext!.read<ScannerLosersManager>();

    FilterParamsGainerLoser? filter;

    preMarket = _portData?.port?.checkMarketOpenApi?.checkPreMarket ?? false;
    postMarket = _portData?.port?.checkMarketOpenApi?.checkPostMarket ?? false;

    text = preMarket
        ? 'Pre-Market'
        : postMarket
            ? 'Post-Market'
            : null;
    switch (selectedIndex) {
      case 0:
        filter = FilterParamsGainerLoser(
          sortByAsc: _filterParams?.sortByAsc,
          sortByHeader: _filterParams?.sortBy,
        );
        showSector = false;
        break;

      case 1:
        filter = gainersManager.filterParams;
        break;

      case 2:
        filter = losersManager.filterParams;
        break;

      default:
    }

    BaseBottomSheet().bottomSheet(
      padding: EdgeInsets.zero,
      child: ScannerSortingList(
        showPreMarket: !(preMarket || postMarket),
        showSector: showSector,
        sortBy: filter?.sortByAsc,
        header: filter?.sortByHeader,
        sortByCallBack: (received) {
          switch (selectedIndex) {
            case 0:
              setSortingApplied(true);
              applySorting(
                received.type.name,
                received.ascending,
              );
              break;

            case 1:
              gainersManager.applySorting(
                received.type.name,
                received.ascending,
              );

              break;

            case 2:
              losersManager.applySorting(
                received.type.name,
                received.ascending,
              );
              break;

            default:
          }
          Navigator.pop(navigatorKey.currentContext!);
        },
        text: text,
      ),
    );
  }

  //MARK: Scanner Ports
  ScannerPortRes? _portData;
  ScannerPortRes? get portData => _portData;
  String? _errorPort;
  String? get errorPort => _errorPort ?? Const.errSomethingWrong;

  Status _statusPort = Status.ideal;
  Status get statusPort => _statusPort;

  bool get isLoadingPort =>
      _statusPort == Status.loading || _statusPort == Status.ideal;

//MARK: setting up lock

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _portData?.lockInfo;
    return info;
  }

  setStatusPort(status) {
    _statusPort = status;
    notifyListeners();
  }

  Future getScannerPorts({bool showProgress = false, reset = false}) async {
    if (reset) {
      _portData = null;
      selectedIndex = -1;
      totalResult = null;
    }
    setStatusPort(Status.loading);

    try {
      Map request = {
        'token':
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
          url: Apis.stockScannerPort,
          showProgress: showProgress,
          request: request);

      if (response.status) {
        _portData = scannerPortResFromJson(jsonEncode(response.data));
        _errorPort = null;
        if (reset) {
          onTabChange(1);
        }
      } else {
        _portData = null;
        _errorPort = response.message;
      }

      return ApiResponse(
        status: response.status,
        data: _portData,
      );
    } catch (e) {
      _portData = null;
      _errorPort = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.stockScannerPort}: $e');
      return ApiResponse(status: false);
    } finally {
      setStatusPort(Status.loaded);
    }
  }

//MARK: Sector Filters

  void setStatusFilter(status) {
    _status = status;
    notifyListeners();
  }

  Future getFilterSectors({showProgress = false}) async {
    setStatusFilter(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.scannerFilters,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _sectors = filterSectorsResFromJson(jsonEncode(response.data));
      } else {
        _sectors = null;
      }
    } catch (e) {
      Utils().showLog('Error in ${Apis.trendingSectors}: $e');
    } finally {
      setStatusFilter(Status.loaded);
    }
  }

  //MARK: Scanner
  Status _status = Status.ideal;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  List<OfflineScannerRes>? _fullOfflineDataList;
  List<OfflineScannerRes>? _offlineDataList;
  List<OfflineScannerRes>? get offlineDataList => _offlineDataList;

  List<LiveScannerRes>? _fullDataList;
  List<LiveScannerRes>? _dataList;
  List<LiveScannerRes>? get dataList => _dataList;

  List<String>? _sectors;
  List<String>? get sectors => _sectors;

  FilterParams? _filterParams;
  FilterParams? get filterParams => _filterParams;

  // Extra? _extra;
  // Extra? get extra => _extra;

  String? _marketStatus;
  String? get marketStatus => _marketStatus;

  bool _visible = false;
  bool get visible => _visible;

  // int? get page => _page;

  void startListeningPorts() async {
    _offlineDataList = null;
    _dataList = null;
    _visible = true;
    _filterParams = null;
    _filterParams = FilterParams(
      sector: "Consumer Cyclical",
      // sortBy: "% Change",
      // sortByAsc: false,
    );
    notifyListeners();

    MarketScannerStream.instance.initializePorts();
  }

  void stopListeningPorts() {
    _visible = false;
    notifyListeners();
    _offlineDataList = null;
    _dataList = null;
    _filterParams = null;
    MarketScannerStream.instance.stopListeningPorts();
    notifyListeners();
  }

  void updateOfflineData(List<OfflineScannerRes>? data, {applyFilter = false}) {
    if (!applyFilter) {
      if (_fullOfflineDataList == null && data != null) {
        _fullOfflineDataList = List.empty(growable: true);
        _fullOfflineDataList?.addAll(data);
      }
      // _offlineDataList = data?.take(50).toList();
      _offlineDataList = data;
      setTotalResults(_offlineDataList?.length ?? 0);
    } else {
      if (_fullOfflineDataList == null && data != null) {
        _fullOfflineDataList = List.empty(growable: true);
        _fullOfflineDataList?.addAll(data);
      }
      List<OfflineScannerRes>? list = List.empty(growable: true);
      list.addAll(data!);
      updateOfflineDataFilter(list);
    }
    notifyListeners();
  }

  void updateOfflineDataFilter(List<OfflineScannerRes>? data) {
    if (data == null) return;

    data.removeWhere((item) {
      if (item.identifier == _filterParams!.symbolCompany) {
        // Utils().showLog(
        //   "***********************************************************${item.identifier}  ${_filterParams!.symbolCompany}",
        // );
        // Utils().showLog(
        //   " ===>>>> ******** ${item.sector}  ${_filterParams?.sector} ${item.sector == (_filterParams?.sector ?? "Consumer Cyclical")}",
        // );
      }
      if (item.sector == (_filterParams?.sector ?? "Consumer Cyclical")) {
        num lastTrade = (item.price ?? 0);
        if (lastTrade == 0) {
          return true;
        }
        if (item.volume == 0) {
          return true;
        }

        if (_filterParams == null) return false;

        // If any filter fails, return true to remove the item
        bool visible = isVisibleOffline(item, _filterParams!);
        return !visible;
      } else {
        return true;
      }
    });

    Utils().showLog("Filtered data length => ${data.length}");

    // _offlineDataList = data.take(50).toList();
    _offlineDataList = data;
    setTotalResults(_offlineDataList?.length ?? 0);

    if (_filterParams?.sortBy != null) {
      Utils().showLog('----${_filterParams?.sortByAsc}');
      _offlineDataList?.sort((a, b) {
        return sortByCompareOffline(
          a,
          b,
          _filterParams?.sortBy ?? "",
          _filterParams?.sortByAsc ?? false,
        );
      });
    }

    // Notify listeners to update UI
    notifyListeners();
  }

  bool isVisibleOffline(OfflineScannerRes item, FilterParams filterParams) {
    num lastTrade = item.price ?? 0;
    num netChange = item.change ?? 0;
    num percentChange = item.changesPercentage ?? 0;
    num volume = item.volume ?? 0;
    num dollarVolume = (volume * lastTrade);

    // Bid Range Conditions
    bool bidStartCondition = filterParams.bidStart == null ||
        (item.bid ?? 0) >= filterParams.bidStart!;
    bool bidEndCondition =
        filterParams.bidEnd == null || (item.bid ?? 0) <= filterParams.bidEnd!;

    // Ask Range Conditions
    bool askStartCondition = filterParams.askStart == null ||
        (item.ask ?? 0) >= filterParams.askStart!;
    bool askEndCondition =
        filterParams.askEnd == null || (item.ask ?? 0) <= filterParams.askEnd!;

    // Last Trade Range Conditions
    bool lastTradeStartCondition = filterParams.lastTradeStart == null ||
        lastTrade >= filterParams.lastTradeStart!;
    bool lastTradeEndCondition = filterParams.lastTradeEnd == null ||
        lastTrade <= filterParams.lastTradeEnd!;

    // Net Change Range Conditions
    bool netChangeStartCondition = filterParams.netChangeStart == null ||
        netChange >= filterParams.netChangeStart!;
    bool netChangeEndCondition = filterParams.netChangeEnd == null ||
        netChange <= filterParams.netChangeEnd!;

    // Percent Change Range Conditions
    bool percentChangeStartCondition = filterParams.perChangeStart == null ||
        percentChange >= filterParams.perChangeStart!;
    bool percentChangeEndCondition = filterParams.perChangeEnd == null ||
        percentChange <= filterParams.perChangeEnd!;

    // Volume Range Conditions
    bool volumeStartCondition =
        filterParams.volumeStart == null || volume >= filterParams.volumeStart!;
    bool volumeEndCondition =
        filterParams.volumeEnd == null || volume <= filterParams.volumeEnd!;

    // Dollar Volume Range Conditions
    bool dollarVolumeStartCondition = filterParams.dolorVolumeStart == null ||
        dollarVolume >= filterParams.dolorVolumeStart!;
    bool dollarVolumeEndCondition = filterParams.dolorVolumeEnd == null ||
        dollarVolume <= filterParams.dolorVolumeEnd!;

    // Sector Condition
    bool sectorCondition =
        filterParams.sector == null || item.sector == filterParams.sector;

    // Symbol Condition (case-insensitive check)
    bool symbolCondition = filterParams.symbolCompany == null ||
        item.identifier
            .toLowerCase()
            .contains(filterParams.symbolCompany!.toLowerCase());

    bool nameCondition = filterParams.symbolCompany == null ||
        item.name
            .toLowerCase()
            .contains(filterParams.symbolCompany!.toLowerCase());

    // Combine all conditions using logical AND (&&)
    return bidStartCondition &&
        bidEndCondition &&
        askStartCondition &&
        askEndCondition &&
        lastTradeStartCondition &&
        lastTradeEndCondition &&
        netChangeStartCondition &&
        netChangeEndCondition &&
        percentChangeStartCondition &&
        percentChangeEndCondition &&
        volumeStartCondition &&
        volumeEndCondition &&
        dollarVolumeStartCondition &&
        dollarVolumeEndCondition &&
        sectorCondition &&
        (symbolCondition || nameCondition);
  }

  void updateData(List<LiveScannerRes>? data) {
    if (data == null) return;

    // for (var a in data) {
    //   if (a.identifier == 'TSLA') {
    //     Utils().showLog('Data:Volume ${a.volume}');
    //     Utils().showLog('Data:Last ${a.last}');
    //     Utils().showLog('Data:ExtPrice ${a.extendedHoursPrice}');
    //     Utils().showLog(
    //         'Dollar vol.: ${(a.volume ?? 0) * (a.extendedHoursPrice ?? 0)}');
    //     Utils().showLog('Dollar vol.1: ${(a.volume ?? 0) * (a.last ?? 0)}');
    //   }
    // }

    data.removeWhere((item) {
      if (item.sector == (_filterParams?.sector ?? "Consumer Cyclical")) {
        num lastTrade = (item.last ?? 0);
        if (item.extendedHoursType == "PostMarket" ||
            item.extendedHoursType == "PreMarket") {
          lastTrade = item.extendedHoursPrice ?? 0;
        }
        if (lastTrade == 0) {
          return true;
        }
        if (item.volume == 0) {
          return true;
        }
        if (item.extendedHoursType == "PostMarket" ||
            item.extendedHoursType == "PreMarket") {
          if ((item.volume ?? 0) * (item.extendedHoursPrice ?? 0) < 100000) {
            return true;
          }
        } else {
          if ((item.volume ?? 0) * (item.last ?? 0) < 100000) {
            return true;
          }
        }

        if (_filterParams == null) return false;

        // HERE
        // bool visible = isVisible(item, _filterParams!);
        // return !visible;

        // Return false (item is not removed) if the item passes all filter conditions
        bool shouldRemove = false;

        // Apply filter for last trade
        if (_filterParams?.lastTradeStart != null &&
            _filterParams?.lastTradeEnd != null) {
          if (!(item.last! >= _filterParams!.lastTradeStart! &&
              item.last! <= _filterParams!.lastTradeEnd!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.lastTradeStart != null) {
          if (!(item.last! >= _filterParams!.lastTradeStart!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.lastTradeEnd != null) {
          if (!(item.last! <= _filterParams!.lastTradeEnd!)) {
            shouldRemove = true;
          }
        }

        bool preMarket = item.extendedHoursType == 'PreMarket';
        bool postMarket = item.extendedHoursType == 'PostMarket';

        // Apply filter for last trade
        if (_filterParams?.lastTradeStart != null &&
            _filterParams?.lastTradeEnd != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursPrice! >= _filterParams!.lastTradeStart! &&
                item.extendedHoursPrice! <= _filterParams!.lastTradeEnd!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.last! >= _filterParams!.lastTradeStart! &&
                item.last! <= _filterParams!.lastTradeEnd!)) {
              shouldRemove = true;
            }
          }
        } else if (_filterParams?.lastTradeStart != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursPrice! >= _filterParams!.lastTradeStart!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.last! >= _filterParams!.lastTradeStart!)) {
              shouldRemove = true;
            }
          }
        } else if (_filterParams?.lastTradeEnd != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursPrice! <= _filterParams!.lastTradeEnd!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.last! <= _filterParams!.lastTradeEnd!)) {
              shouldRemove = true;
            }
          }
        }

        //filter by change
        if (_filterParams?.netChangeStart != null &&
            _filterParams?.netChangeEnd != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursChange! >= _filterParams!.netChangeStart! &&
                item.extendedHoursChange! <= _filterParams!.netChangeEnd!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.change! >= _filterParams!.netChangeStart! &&
                item.change! <= _filterParams!.netChangeEnd!)) {
              shouldRemove = true;
            }
          }
        } else if (_filterParams?.netChangeStart != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursChange! >=
                _filterParams!.netChangeStart!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.change! >= _filterParams!.netChangeStart!)) {
              shouldRemove = true;
            }
          }
        } else if (_filterParams?.netChangeEnd != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursChange! <= _filterParams!.netChangeEnd!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.change! <= _filterParams!.netChangeEnd!)) {
              shouldRemove = true;
            }
          }
        }

        num dollarVolumeLive = (item.volume ?? 0) * (item.last ?? 0);
        num dollarVolumePrePost =
            (item.volume ?? 0) * (item.extendedHoursPrice ?? 0);

        //filter by dollar volume
        if (_filterParams?.dolorVolumeStart != null &&
            _filterParams?.dolorVolumeEnd != null) {
          if (preMarket || postMarket) {
            if (!(dollarVolumePrePost >= _filterParams!.dolorVolumeStart! &&
                dollarVolumePrePost <= _filterParams!.dolorVolumeEnd!)) {
              shouldRemove = true;
            }
          } else {
            if (!(dollarVolumeLive >= _filterParams!.dolorVolumeStart! &&
                dollarVolumeLive <= _filterParams!.dolorVolumeEnd!)) {
              shouldRemove = true;
            }
          }
        } else if (_filterParams?.dolorVolumeStart != null) {
          if (preMarket || postMarket) {
            if (!(dollarVolumePrePost >= _filterParams!.dolorVolumeStart!)) {
              shouldRemove = true;
            }
          } else {
            if (!(dollarVolumeLive >= _filterParams!.dolorVolumeStart!)) {
              shouldRemove = true;
            }
          }
        } else if (_filterParams?.dolorVolumeEnd != null) {
          if (preMarket || postMarket) {
            if (!(dollarVolumePrePost <= _filterParams!.dolorVolumeEnd!)) {
              shouldRemove = true;
            }
          } else {
            if (!(dollarVolumeLive <= _filterParams!.dolorVolumeEnd!)) {
              shouldRemove = true;
            }
          }
        }

        // Apply filter for bid range (bidStart <= item.bid <= bidEnd)
        if (_filterParams?.bidStart != null && _filterParams?.bidEnd != null) {
          if (!(item.bid! >= _filterParams!.bidStart! &&
              item.bid! <= _filterParams!.bidEnd!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.bidStart != null) {
          if (!(item.bid! >= _filterParams!.bidStart!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.bidEnd != null) {
          if (!(item.bid! <= _filterParams!.bidEnd!)) {
            shouldRemove = true;
          }
        }

        // Apply filter for ask range (askStart <= item.ask <= askEnd)
        if (_filterParams?.askStart != null && _filterParams?.askEnd != null) {
          if (!(item.ask! >= _filterParams!.askStart! &&
              item.ask! <= _filterParams!.askEnd!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.askStart != null) {
          if (!(item.ask! >= _filterParams!.askStart!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.askEnd != null) {
          if (!(item.ask! <= _filterParams!.askEnd!)) {
            shouldRemove = true;
          }
        }

        // Apply filter for percentChange range
        if (_filterParams?.perChangeStart != null &&
            _filterParams?.perChangeEnd != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursPercentChange! >=
                    _filterParams!.perChangeStart! &&
                item.extendedHoursPercentChange! <=
                    _filterParams!.perChangeEnd!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.percentChange! >= _filterParams!.perChangeStart! &&
                item.percentChange! <= _filterParams!.perChangeEnd!)) {
              shouldRemove = true;
            }
          }
        } else if (_filterParams?.perChangeStart != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursPercentChange! >=
                _filterParams!.perChangeStart!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.percentChange! >= _filterParams!.perChangeStart!)) {
              shouldRemove = true;
            }
          }
        } else if (_filterParams?.perChangeEnd != null) {
          if (preMarket || postMarket) {
            if (!(item.extendedHoursPercentChange! <=
                _filterParams!.perChangeEnd!)) {
              shouldRemove = true;
            }
          } else {
            if (!(item.percentChange! <= _filterParams!.perChangeEnd!)) {
              shouldRemove = true;
            }
          }
        }

        // Apply filter for volume range
        if (_filterParams?.volumeStart != null &&
            _filterParams?.volumeEnd != null) {
          if (!(item.volume! >= _filterParams!.volumeStart! &&
              item.volume! <= _filterParams!.volumeEnd!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.volumeStart != null) {
          if (!(item.volume! >= _filterParams!.volumeStart!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.volumeEnd != null) {
          if (!(item.volume! <= _filterParams!.volumeEnd!)) {
            shouldRemove = true;
          }
        }

        // Apply filter for symbolCompany
        if (_filterParams?.symbolCompany != null) {
          String searchText = _filterParams!.symbolCompany!.toLowerCase();
          // Check if either the identifier or security name contains the search text
          bool matchesIdentifier =
              item.identifier?.toLowerCase().contains(searchText) ?? false;
          bool matchesCompanyName =
              item.security?.name?.toLowerCase().contains(searchText) ?? false;
          if (!(matchesIdentifier || matchesCompanyName)) {
            shouldRemove = true;
          }
          // if (!(item.security.name
          //         ?.toLowerCase()
          //         .contains(_filterParams!.symbolCompany!.toLowerCase()) ??
          //     false)) {
          //   shouldRemove = true;
          // }
        }

        // Apply filter for sector
        // if (_filterParams?.sector != null) {
        //   if (!(item.sector == _filterParams!.sector)) {
        //     shouldRemove = true;
        //   }
        // }

        // If any filter fails, return true to remove the item
        return shouldRemove;
      } else {
        return true;
      }
    });

    storeFullLiveData(data);

    if (_dataList == null || _dataList?.isEmpty == true) {
      _dataList = List.empty(growable: true);
      _dataList!.addAll(data);

      notifyListeners();
    } else {
      for (var newItem in data) {
        // Check if the item already exists based on the identifier
        int index = _dataList!
            .indexWhere((item) => item.identifier == newItem.identifier);
        if (index != -1) {
          // If the item exists, update it
          _dataList![index] = newItem;
        } else {
          // If the item does not exist, add it to the top of the list
          if (_filterParams?.sortBy != null) {
            _dataList!.insert(0, newItem); // Insert at the top
          } else {
            _dataList!
                .insert(_dataList!.length - 1, newItem); // Insert at the last
          }
        }
      }
    }

    if (_filterParams?.sortBy != null) {
      _dataList?.sort((a, b) {
        return sortByCompare(
          a,
          b,
          _filterParams?.sortBy ?? "",
          _filterParams?.sortByAsc ?? false,
        );
      });
    }
    setTotalResults(_dataList?.length ?? 0);

    // _dataList = _dataList!.take(50).toList();

    // Notify listeners to update UI
    notifyListeners();
  }

  void storeFullLiveData(List<LiveScannerRes>? data) async {
    if (_fullDataList == null) {
      _fullDataList = data;

      return;
    } else {
      if (data != null && data.isNotEmpty) {
        // Iterate over the new data list
        for (var newItem in data) {
          // Find if an item with the same identifier exists in the list

          int index = _fullDataList!.indexWhere(
              (existingItem) => existingItem.identifier == newItem.identifier);

          if (index != -1) {
            // If the item exists (index != -1), replace the existing one
            _fullDataList![index] = newItem;
          } else {
            // If the item doesn't exist, add the new item
            _fullDataList!.add(newItem);
          }
        }
      }
    }
  }

  int sortByCompare(
      LiveScannerRes a, LiveScannerRes b, String sortBy, bool isAsc) {
    if (sortBy == SortByEnums.symbol.name) {
      if (a.identifier == null && b.identifier == null) return 0;
      if (a.identifier == null) return -1;
      if (b.identifier == null) return 1;
      if (isAsc) {
        return a.identifier!.compareTo(b.identifier!);
      } else {
        return b.identifier!.compareTo(a.identifier!);
      }
    } else if (sortBy == SortByEnums.company.name) {
      if (a.security?.name == null && b.security?.name == null) return 0;
      if (a.security?.name == null) return -1;
      if (b.security?.name == null) return 1;
      if (isAsc) {
        return a.security!.name!.compareTo(b.security!.name!);
      } else {
        return b.security!.name!.compareTo(a.security!.name!);
      }
    } else if (sortBy == SortByEnums.bid.name) {
      if (a.bid == null && b.bid == null) return 0;
      if (a.bid == null) return -1;
      if (b.bid == null) return 1;
      if (isAsc) {
        return a.bid!.compareTo(b.bid!);
      } else {
        return b.bid!.compareTo(a.bid!);
      }
    } else if (sortBy == SortByEnums.ask.name) {
      if (a.ask == null && b.ask == null) return 0;
      if (a.ask == null) return -1;
      if (b.ask == null) return 1;
      if (isAsc) {
        return a.ask!.compareTo(b.ask!);
      } else {
        return b.ask!.compareTo(a.ask!);
      }
    } else if (sortBy == SortByEnums.lastTrade.name) {
      num? valueA = a.last;
      num? valueB = b.last;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursPrice ?? 0;
      //   valueB = b.extendedHoursPrice ?? 0;
      // }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.netChange.name) {
      num? valueA = a.change;
      num? valueB = b.change;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursChange ?? 0;
      //   valueB = b.extendedHoursChange ?? 0;
      // }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.postMarketNetChange.name) {
      num? valueA = a.extendedHoursChange;
      num? valueB = b.extendedHoursChange;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursChange ?? 0;
      //   valueB = b.extendedHoursChange ?? 0;
      // }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.postMarketPerChange.name) {
      num? valueA = a.extendedHoursPercentChange;
      num? valueB = b.extendedHoursPercentChange;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursChange ?? 0;
      //   valueB = b.extendedHoursChange ?? 0;
      // }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.perChange.name) {
      num? valueA = a.percentChange;
      num? valueB = b.percentChange;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursPercentChange ?? 0;
      //   valueB = b.extendedHoursPercentChange ?? 0;
      // }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.postMarket.name) {
      if (a.extendedHoursPrice == null && b.extendedHoursPrice == null) {
        return 0;
      }
      if (a.extendedHoursPrice == null) return -1;
      if (b.extendedHoursPrice == null) return 1;
      if (isAsc) {
        return a.extendedHoursPrice!.compareTo(b.extendedHoursPrice!);
      } else {
        return b.extendedHoursPrice!.compareTo(a.extendedHoursPrice!);
      }
    } else if (sortBy == SortByEnums.volume.name) {
      if (a.volume == null && b.volume == null) return 0;
      if (a.volume == null) return -1;
      if (b.volume == null) return 1;
      if (isAsc) {
        return a.volume!.compareTo(b.volume!);
      } else {
        return b.volume!.compareTo(a.volume!);
      }
    } else if (sortBy == SortByEnums.dollarVolume.name) {
      num dolorVolumeA = (a.volume ?? 0) * (a.last ?? 0);
      num dolorVolumeB = (b.volume ?? 0) * (b.last ?? 0);
      if (a.extendedHoursType == "PostMarket" ||
          a.extendedHoursType == "PreMarket") {
        dolorVolumeA = (a.volume ?? 0) * (a.extendedHoursPrice ?? 0);
        dolorVolumeB = (b.volume ?? 0) * (b.extendedHoursPrice ?? 0);
      }
      if (isAsc) {
        return dolorVolumeA.compareTo(dolorVolumeB);
      } else {
        return dolorVolumeB.compareTo(dolorVolumeA);
      }
    }
    return 0;
  }

  int sortByCompareOffline(
      OfflineScannerRes a, OfflineScannerRes b, String sortBy, bool isAsc) {
    if (sortBy == SortByEnums.symbol.name) {
      if (a.identifier == null && b.identifier == null) return 0;
      if (a.identifier == null) return -1;
      if (b.identifier == null) return 1;
      if (isAsc) {
        return a.identifier!.compareTo(b.identifier!);
      } else {
        return b.identifier!.compareTo(a.identifier!);
      }
    }
    if (sortBy == SortByEnums.company.name) {
      if (a.name == null && b.name == null) return 0;
      if (a.name == null) return -1;
      if (b.name == null) return 1;
      if (isAsc) {
        return a.name!.compareTo(b.name!);
      } else {
        return b.name!.compareTo(a.name!);
      }
    }
    if (sortBy == SortByEnums.bid.name) {
      if (a.bid == null && b.bid == null) return 0;
      if (a.bid == null) return -1;
      if (b.bid == null) return 1;
      if (isAsc) {
        return a.bid!.compareTo(b.bid!);
      } else {
        return b.bid!.compareTo(a.bid!);
      }
    }
    if (sortBy == SortByEnums.ask.name) {
      if (a.ask == null && b.ask == null) return 0;
      if (a.ask == null) return -1;
      if (b.ask == null) return 1;
      if (isAsc) {
        return a.ask!.compareTo(b.ask!);
      } else {
        return b.ask!.compareTo(a.ask!);
      }
    }
    if (sortBy == SortByEnums.lastTrade.name) {
      if (a.price == null && b.price == null) return 0;
      if (a.price == null) return -1;
      if (b.price == null) return 1;
      if (isAsc) {
        return a.price!.compareTo(b.price!);
      } else {
        return b.price!.compareTo(a.price!);
      }
    }
    if (sortBy == SortByEnums.postMarket.name) {
      if (a.ext?.extendedHoursPrice == null &&
          b.ext?.extendedHoursPrice == null) {
        return 0;
      }
      if (a.ext?.extendedHoursPrice == null) return -1;
      if (b.ext?.extendedHoursPrice == null) return 1;
      if (isAsc) {
        return a.ext?.extendedHoursPrice!.compareTo(b.ext?.extendedHoursPrice!);
      } else {
        return b.ext?.extendedHoursPrice!.compareTo(a.ext?.extendedHoursPrice!);
      }
    }
    if (sortBy == SortByEnums.netChange.name) {
      // dynamic valueA = a.ext?.extendedHoursChange;
      // dynamic valueB = b.ext?.extendedHoursChange;
      dynamic valueA = a.change;
      dynamic valueB = b.change;

      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA!.compareTo(valueB!);
      } else {
        return valueB!.compareTo(valueA!);
      }
    }

    if (sortBy == SortByEnums.postMarketNetChange.name) {
      dynamic valueA = a.ext?.extendedHoursChange;
      dynamic valueB = b.ext?.extendedHoursChange;
      // dynamic valueA = a.change;
      // dynamic valueB = b.change;

      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA!.compareTo(valueB!);
      } else {
        return valueB!.compareTo(valueA!);
      }
    }
    if (sortBy == SortByEnums.postMarketPerChange.name) {
      dynamic valueA = a.ext?.extendedHoursPercentChange;
      dynamic valueB = b.ext?.extendedHoursPercentChange;
      // dynamic valueA = a.changesPercentage;
      // dynamic valueB = b.changesPercentage;

      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;

      if (isAsc) {
        return valueA!.compareTo(valueB!);
      } else {
        return valueB!.compareTo(valueA!);
      }
    }

    if (sortBy == SortByEnums.perChange.name) {
      // dynamic valueA = a.ext?.extendedHoursPercentChange;
      // dynamic valueB = b.ext?.extendedHoursPercentChange;
      dynamic valueA = a.changesPercentage;
      dynamic valueB = b.changesPercentage;

      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;

      if (isAsc) {
        return valueA!.compareTo(valueB!);
      } else {
        return valueB!.compareTo(valueA!);
      }
    }
    if (sortBy == SortByEnums.volume.name) {
      if (a.volume == null && b.volume == null) return 0;
      if (a.volume == null) return -1;
      if (b.volume == null) return 1;
      if (isAsc) {
        return a.volume!.compareTo(b.volume!);
      } else {
        return b.volume!.compareTo(a.volume!);
      }
    }
    if (sortBy == SortByEnums.dollarVolume.name) {
      num dolorVolumeA = (a.volume ?? 0) * (a.ext?.extendedHoursPrice ?? 0);
      num dolorVolumeB = (b.volume ?? 0) * (b.ext?.extendedHoursPrice ?? 0);

      if (isAsc) {
        return dolorVolumeA.compareTo(dolorVolumeB);
      } else {
        return dolorVolumeB.compareTo(dolorVolumeA);
      }
    }
    return 0;
  }

  void applySorting(String sortBy, bool isAscending) {
    if (sortBy == _filterParams?.sortBy) {
      // _filterParams?.sortByAsc = !(_filterParams?.sortByAsc ?? true);
      _filterParams?.sortByAsc = isAscending;
    } else {
      _filterParams?.sortBy = sortBy;
      // _filterParams?.sortByAsc = true;
      _filterParams?.sortByAsc = isAscending;
    }

    // if (MarketScannerStream.instance.isListening) {
    //   MarketScannerStream.instance.stopListeningPorts();
    // }

    if (_dataList != null) {
      // notifyListeners();
      updateData(_fullDataList);
    } else if (_offlineDataList != null) {
      // _offlineDataList = null;
      updateOfflineData(_fullOfflineDataList, applyFilter: true);
    }
  }

  void applyFilter(FilterParams params) {
    if (_dataList != null) {
      _filterParams = params;
      Utils().showLog("----");
      _dataList = null;
      _offlineDataList = null;
      _fullOfflineDataList = null;
      notifyListeners();
      // MarketScannerStream.instance.initializePorts();
      updateData(_fullDataList);
    } else if (_offlineDataList != null) {
      if (params.sector != _filterParams?.sector) {
        _filterParams = params;
        MarketScannerStream.instance.getOfflineData();
      } else {
        _filterParams = params;
        updateOfflineData(_fullOfflineDataList, applyFilter: true);
      }
    } else {
      _filterParams = params;
      notifyListeners();
    }
  }

  void clearFilter() {
    _filterParams = FilterParams(sector: "Consumer Cyclical");
    if (_offlineDataList != null && _fullOfflineDataList != null) {
      _offlineDataList = _fullOfflineDataList;
      setTotalResults(_offlineDataList?.length ?? 0);
    }
    if (_dataList != null && _fullDataList != null) {
      _dataList = _fullDataList;
      setTotalResults(_dataList?.length ?? 0);
    }

    notifyListeners();
  }

  bool isFilterApplied() {
    if (_filterParams == null) return false;

    if (_filterParams?.bidStart != null) {
      return true;
    }
    if (_filterParams?.bidEnd != null) {
      return true;
    }
    if (_filterParams?.askStart != null) {
      return true;
    }
    if (_filterParams?.askEnd != null) {
      return true;
    }
    if (_filterParams?.lastTradeStart != null) {
      return true;
    }
    if (_filterParams?.lastTradeEnd != null) {
      return true;
    }
    if (_filterParams?.netChangeStart != null) {
      return true;
    }
    if (_filterParams?.netChangeEnd != null) {
      return true;
    }
    if (_filterParams?.perChangeStart != null) {
      return true;
    }
    if (_filterParams?.perChangeEnd != null) {
      return true;
    }
    if (_filterParams?.volumeStart != null) {
      return true;
    }
    if (_filterParams?.volumeEnd != null) {
      return true;
    }
    if (_filterParams?.volumeEnd != null) {
      return true;
    }
    if (_filterParams?.dolorVolumeStart != null) {
      return true;
    }
    if (_filterParams?.dolorVolumeEnd != null) {
      return true;
    }
    if (_filterParams?.sector != null) {
      return true;
    }
    if (_filterParams?.symbolCompany != null) {
      return true;
    }
    return false;
  }
}
