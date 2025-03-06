import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/market/52Weeks/fifty_two_weeks_high.dart';
import 'package:stocks_news_new/managers/market/52Weeks/fifty_two_weeks_low.dart';
import 'package:stocks_news_new/managers/market/dividends/dividends.dart';
import 'package:stocks_news_new/managers/market/earnings/earnings.dart';
import 'package:stocks_news_new/managers/market/gainer&losers/todays_breakout.dart';
import 'package:stocks_news_new/managers/market/gainer&losers/todays_gainer.dart';
import 'package:stocks_news_new/managers/market/gainer&losers/todays_losers.dart';
import 'package:stocks_news_new/managers/market/gapUpDown/gap_down.dart';
import 'package:stocks_news_new/managers/market/gapUpDown/gap_up.dart';
import 'package:stocks_news_new/managers/market/highLowBeta/high_beta.dart';
import 'package:stocks_news_new/managers/market/highLowBeta/low_beta.dart';
import 'package:stocks_news_new/managers/market/highLowBeta/negative_beta.dart';
import 'package:stocks_news_new/managers/market/highLowPe/high_pe.dart';
import 'package:stocks_news_new/managers/market/highLowPe/high_pe_growth.dart';
import 'package:stocks_news_new/managers/market/highLowPe/low_pe.dart';
import 'package:stocks_news_new/managers/market/highLowPe/low_pe_growth.dart';
import 'package:stocks_news_new/managers/market/indices/amex/amex.dart';
import 'package:stocks_news_new/managers/market/indices/dow30/dow_30.dart';
import 'package:stocks_news_new/managers/market/indices/nasdaq/nasdaq.dart';
import 'package:stocks_news_new/managers/market/indices/nyse/nyse.dart';
import 'package:stocks_news_new/managers/market/indices/s&p500/snp_500.dart';
import 'package:stocks_news_new/managers/market/mostActive/mostActive/most_active.dart';
import 'package:stocks_news_new/managers/market/mostActive/mostVolatile/most_volatile.dart';
import 'package:stocks_news_new/managers/market/mostActive/unusualTrading/unusual_trading.dart';
import 'package:stocks_news_new/managers/market/pennyStocks/mostActive/most_active.dart';
import 'package:stocks_news_new/managers/market/pennyStocks/mostPopular/most_popular.dart';
import 'package:stocks_news_new/managers/market/pennyStocks/topTodays/top_tadays.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/market/mostActive/mostActive/most_active.dart';
import 'package:stocks_news_new/ui/tabs/market/mostActive/mostVolatile/most_volatile.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class MarketManager extends ChangeNotifier {
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  MarketRes? _data;
  MarketRes? get data => _data;

  Map? _filterRequest;
  Map? get filterRequest => _filterRequest;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData() async {
    try {
      setStatus(Status.loading);
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      Map request = {'token': provider.user?.token ?? ''};

      ApiResponse response = await apiRequest(
        url: Apis.marketData,
        request: request,
      );

      if (response.status) {
        _data = marketResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
    } finally {
      setStatus(Status.loaded);
    }
  }

// FILTER RELATED ONLY : START --------

  MarketFilterParams? _filterParams;
  MarketFilterParams? get filterParams => _filterParams;

  void selectSortBy(index) {
    String slug = _data!.filter!.sorting![index].value;
    Utils().showLog("Filter Selected => $index $slug");

    _filterParams = _filterParams ?? MarketFilterParams();
    if (_filterParams?.sorting != null && _filterParams?.sorting == slug) {
      _filterParams?.sorting = null;
    } else {
      _filterParams?.sorting = slug;
    }
    notifyListeners();
  }

  void selectExchange(index) {
    String slug = _data!.filter!.exchange![index].value;
    _filterParams = _filterParams ?? MarketFilterParams();
    if (filterParams?.exchange != null &&
        _filterParams!.exchange!.contains(slug)) {
      _filterParams?.exchange?.remove(slug);
      if (_filterParams!.exchange!.isEmpty) {
        _filterParams?.exchange = null;
      }
    } else {
      _filterParams?.exchange =
          _filterParams?.exchange ?? List.empty(growable: true);
      _filterParams?.exchange?.add(slug);
    }

    notifyListeners();
  }

  void selectSectors(index) {
    String slug = _data!.filter!.sectors![index].value;
    _filterParams = _filterParams ?? MarketFilterParams();
    if (_filterParams?.sectors != null &&
        _filterParams!.sectors!.contains(slug)) {
      _filterParams?.sectors?.remove(slug);
      if (filterParams!.sectors!.isEmpty) {
        _filterParams?.sectors = null;
      }
    } else {
      _filterParams?.sectors =
          _filterParams?.sectors ?? List.empty(growable: true);
      _filterParams?.sectors?.add(slug);
    }
    notifyListeners();
  }

  void selectIndustries(index) {
    String slug = _data!.filter!.industries![index].value;
    _filterParams = _filterParams ?? MarketFilterParams();
    if (filterParams?.industries != null &&
        _filterParams!.industries!.contains(slug)) {
      _filterParams?.industries?.remove(slug);

      if (filterParams!.industries!.isEmpty) {
        _filterParams?.industries = null;
      }
    } else {
      _filterParams?.industries =
          _filterParams?.industries ?? List.empty(growable: true);
      _filterParams?.industries?.add(slug);
    }
    notifyListeners();
  }

  void selectMarketCap(index) {
    String slug = _data!.filter!.marketCap![index].value;
    _filterParams = _filterParams ?? MarketFilterParams();
    if (filterParams?.marketCap != null && _filterParams?.marketCap == slug) {
      _filterParams?.marketCap = null;
    } else {
      _filterParams?.marketCap = slug;
    }

    notifyListeners();
  }

  void selectMarketRank(index) {
    String slug = _data!.filter!.marketRank![index].value;
    _filterParams = _filterParams ?? MarketFilterParams();
    if (filterParams?.marketRank != null &&
        _filterParams!.marketRank!.contains(slug)) {
      _filterParams?.marketRank?.remove(slug);
      if (filterParams!.marketRank!.isEmpty) {
        _filterParams?.marketRank = null;
      }
    } else {
      _filterParams?.marketRank =
          _filterParams?.marketRank ?? List.empty(growable: true);
      _filterParams?.marketRank?.add(slug);
    }
    notifyListeners();
  }

  void selectAnalystConsensus(index) {
    String slug = _data!.filter!.analystConsensus![index].value;
    _filterParams = _filterParams ?? MarketFilterParams();
    if (filterParams?.analystConsensus != null &&
        _filterParams!.analystConsensus!.contains(slug)) {
      _filterParams?.analystConsensus?.remove(slug);
      if (filterParams!.analystConsensus!.isEmpty) {
        _filterParams?.analystConsensus = null;
      }
    } else {
      _filterParams?.analystConsensus =
          _filterParams?.analystConsensus ?? List.empty(growable: true);
      _filterParams?.analystConsensus?.add(slug);
    }

    notifyListeners();
  }

  void resetFilter({
    required marketIndex,
    required marketInnerIndex,
    apiCallNeeded = true,
  }) {
    _filterRequest = null;
    _filterParams = null;
    notifyListeners();
    if (apiCallNeeded) {
      callApi(marketIndex, marketInnerIndex);
    }
  }

  void applyFilter({required marketIndex, required marketInnerIndex}) {
    final request = {};

    if (filterParams != null && _filterParams?.sorting != null) {
      request['shorting'] = _filterParams?.sorting;
    }

    if (filterParams != null && _filterParams?.exchange != null) {
      request['exchange_name'] = _filterParams?.exchange?.join(",");
    }

    if (filterParams != null && _filterParams?.sectors != null) {
      request['sector'] = _filterParams?.sectors?.join(",");
    }

    if (filterParams != null && _filterParams?.industries != null) {
      request['industry'] = _filterParams?.industries?.join(",");
    }

    if (filterParams != null && _filterParams?.marketCap != null) {
      request['market_cap'] = _filterParams?.marketCap;
    }

    if (filterParams != null && _filterParams?.marketRank != null) {
      request['marketRank'] = _filterParams?.marketRank?.join(",");
    }
    if (filterParams != null && _filterParams?.analystConsensus != null) {
      request['analystConsensus'] = _filterParams?.analystConsensus?.join(",");
    }
    _filterRequest = request;
    callApi(marketIndex, marketInnerIndex);
  }

  void callApi(marketIndex, marketInnerIndex) {
    final context = navigatorKey.currentContext!;
    if (marketIndex == 1 && marketInnerIndex == 0) {
      context.read<TodaysGainerManager>().getData(filter: true);
    } else if (marketIndex == 1 && marketInnerIndex == 1) {
      context.read<TodaysLosersManager>().getData(filter: true);
    } else if (marketIndex == 1 && marketInnerIndex == 2) {
      context.read<TodaysBreakoutManager>().getData(filter: true);
    } else if (marketIndex == 2 && marketInnerIndex == 0) {
      context.read<GapUpManager>().getData(filter: true);
    } else if (marketIndex == 2 && marketInnerIndex == 1) {
      context.read<GapDownManager>().getData(filter: true);
    } else if (marketIndex == 3 && marketInnerIndex == 0) {
      context.read<HighPeManager>().getData(filter: true);
    } else if (marketIndex == 3 && marketInnerIndex == 1) {
      context.read<LowPeManager>().getData(filter: true);
    } else if (marketIndex == 3 && marketInnerIndex == 2) {
      context.read<HighPeGrowthManager>().getData(filter: true);
    } else if (marketIndex == 3 && marketInnerIndex == 3) {
      context.read<LowPeGrowthManager>().getData(filter: true);
    } else if (marketIndex == 4 && marketInnerIndex == 0) {
      context.read<FiftyTwoWeeksHighManager>().getData(filter: true);
    } else if (marketIndex == 4 && marketInnerIndex == 1) {
      context.read<FiftyTwoWeeksLowManager>().getData(filter: true);
    } else if (marketIndex == 5 && marketInnerIndex == 0) {
      context.read<HighBetaManager>().getData(filter: true);
    } else if (marketIndex == 5 && marketInnerIndex == 1) {
      context.read<LowBetaManager>().getData(filter: true);
    } else if (marketIndex == 5 && marketInnerIndex == 2) {
      context.read<NegativeBetaManager>().getData(filter: true);
    } else if (marketIndex == 6 && marketInnerIndex == 0) {
      context.read<Dow30Manager>().getData(filter: true);
    } else if (marketIndex == 6 && marketInnerIndex == 1) {
      context.read<Snp500Manager>().getData(filter: true);
    } else if (marketIndex == 6 && marketInnerIndex == 2) {
      context.read<NyseManager>().getData(filter: true);
    } else if (marketIndex == 6 && marketInnerIndex == 3) {
      context.read<AmexManager>().getData(filter: true);
    } else if (marketIndex == 6 && marketInnerIndex == 4) {
      context.read<NasdaqManager>().getData(filter: true);
    } else if (marketIndex == 8 && marketInnerIndex == 0) {
      context.read<MostActiveManager>().getData(filter: true);
    } else if (marketIndex == 8 && marketInnerIndex == 1) {
      context.read<MostVolatileManager>().getData(filter: true);
    } else if (marketIndex == 8 && marketInnerIndex == 2) {
      context.read<UnusualTradingManager>().getData(filter: true);
    } else if (marketIndex == 9 && marketInnerIndex == 0) {
      context.read<MostActivePennyStocksManager>().getData(filter: true);
    } else if (marketIndex == 9 && marketInnerIndex == 1) {
      context.read<MostPopularPennyStocksManager>().getData(filter: true);
    } else if (marketIndex == 9 && marketInnerIndex == 2) {
      context.read<TopTodaysPennyStocksManager>().getData(filter: true);
    } else if (marketIndex == 10) {
      context.read<DividendsManager>().getData(filter: true);
    } else if (marketIndex == 11) {
      context.read<EarningsManager>().getData(filter: true);
    } else {
      //
    }
  }

// FILTER RELATED ONLY : END   --------
}
