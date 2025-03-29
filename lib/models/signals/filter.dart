import 'dart:convert';

import 'package:stocks_news_new/models/stockDetail/overview.dart';

SignalFilterRes signalFilterResFromJson(String str) =>
    SignalFilterRes.fromJson(json.decode(str));

String signalFilterResToJson(SignalFilterRes data) =>
    json.encode(data.toJson());

class SignalFilterRes {
  final SignalFilter? filter;

  SignalFilterRes({
    this.filter,
  });

  factory SignalFilterRes.fromJson(Map<String, dynamic> json) =>
      SignalFilterRes(
        filter: json["filter"] == null
            ? null
            : SignalFilter.fromJson(json["filter"]),
      );

  Map<String, dynamic> toJson() => {
        "filter": filter?.toJson(),
      };
}

class SignalFilter {
  // Insider
  final List<BaseKeyValueRes>? txnType;
  final List<BaseKeyValueRes>? marketCap;
  final List<BaseKeyValueRes>? sector;
  final List<BaseKeyValueRes>? exchange;
  final List<BaseKeyValueRes>? txnSize;
  final dynamic txnDate;

  // politician
  final List<BaseKeyValueRes>? industry;
  final List<BaseKeyValueRes>? marketRank;
  final List<BaseKeyValueRes>? analystConsensus;
  // also includes exchange,sector,marketCap;

  // Stocks
  final List<BaseKeyValueRes>? priceRange;
  final dynamic changePercentage;

  SignalFilter({
    //
    required this.txnType,
    required this.marketCap,
    required this.sector,
    required this.exchange,
    required this.txnSize,
    required this.txnDate,
    //
    required this.industry,
    required this.marketRank,
    required this.analystConsensus,
    //
    required this.priceRange,
    required this.changePercentage,
  });

  factory SignalFilter.fromJson(Map<String, dynamic> json) => SignalFilter(
        txnType: json["txn_type"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["txn_type"].map((x) => BaseKeyValueRes.fromJson(x))),
        marketCap: json["market_cap"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["market_cap"].map((x) => BaseKeyValueRes.fromJson(x))),
        sector: json["sector"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["sector"].map((x) => BaseKeyValueRes.fromJson(x))),
        exchange: json["exchange_name"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["exchange_name"].map((x) => BaseKeyValueRes.fromJson(x))),
        txnSize: json["txn_size"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["txn_size"].map((x) => BaseKeyValueRes.fromJson(x))),
        txnDate: json["txn_date"],

        //
        industry: json["industry"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["industry"].map((x) => BaseKeyValueRes.fromJson(x))),
        marketRank: json["marketRank"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["marketRank"].map((x) => BaseKeyValueRes.fromJson(x))),
        analystConsensus: json["analystConsensus"] == null
            ? null
            : List<BaseKeyValueRes>.from(json["analystConsensus"]
                .map((x) => BaseKeyValueRes.fromJson(x))),
        //
        priceRange: json["price_range"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["price_range"].map((x) => BaseKeyValueRes.fromJson(x))),
        changePercentage: json["change_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "txn_type": txnType == null
            ? null
            : List<dynamic>.from(txnType!.map((x) => x.toJson())),
        "market_cap": marketCap == null
            ? null
            : List<dynamic>.from(marketCap!.map((x) => x.toJson())),
        "sector": sector == null
            ? null
            : List<dynamic>.from(sector!.map((x) => x.toJson())),
        "exchange_name": exchange == null
            ? null
            : List<dynamic>.from(exchange!.map((x) => x.toJson())),
        "txn_size": txnSize == null
            ? null
            : List<dynamic>.from(txnSize!.map((x) => x.toJson())),
        "txn_date": txnDate,
        //
        "industry": industry == null
            ? null
            : List<dynamic>.from(industry!.map((x) => x.toJson())),
        "marketRank": marketRank == null
            ? null
            : List<dynamic>.from(marketRank!.map((x) => x.toJson())),
        "analystConsensus": analystConsensus == null
            ? null
            : List<dynamic>.from(analystConsensus!.map((x) => x.toJson())),
        //
        "price_range": priceRange == null
            ? null
            : List<dynamic>.from(priceRange!.map((x) => x.toJson())),
        "change_percentage": changePercentage,
      };

  SignalFilter clone() {
    return SignalFilter.fromJson(json.decode(json.encode(this)));
  }
}

class FilterParamsInsider {
  String? txnType;
  String? marketCap;
  String? sector;
  String? exchange;
  String? txnSize;
  String? txnDate;

  FilterParamsInsider({
    this.txnType,
    this.marketCap,
    this.txnSize,
    this.sector,
    this.exchange,
    this.txnDate,
  });
}

class FilterParamsPolitician {
  List<String>? exchange;
  List<String>? sectors;
  List<String>? industry;
  String? marketCap;
  List<String>? marketRank;
  List<String>? analystConsensus;

  FilterParamsPolitician({
    this.marketCap,
    this.exchange,
    this.industry,
    this.marketRank,
    this.analystConsensus,
    this.sectors,
  });
}

class FilterParamsStocks {
  String? exchange;
  String? priceRange;
  String? changePercentage;

  FilterParamsStocks({
    this.exchange,
    this.priceRange,
    this.changePercentage,
  });
}

// class SignalFilterParams {
//   // Insider
//   String? txnType;
//   String? marketCap;
//   String? sector;
//   List<String>? exchange;
//   String? txnSize;
//   String? txnDate;

//   //politician
//   List<String>? industry;
//   List<String>? marketRank;
//   List<String>? analystConsensus;
//   List<String>? sectors;

//   SignalFilterParams({
//     this.txnType,
//     this.marketCap,
//     this.txnSize,
//     this.sector,
//     this.exchange,
//     this.industry,
//     this.marketRank,
//     this.analystConsensus,
//     this.sectors,
//   });
// }
