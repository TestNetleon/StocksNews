import 'dart:convert';

import 'package:stocks_news_new/modals/stockDetailRes/morning_start_res.dart';

import '../stock_details_res.dart';
import 'earnings.dart';

SdOverviewRes sdOverviewResFromJson(String str) =>
    SdOverviewRes.fromJson(json.decode(str));

String sdOverviewResToJson(SdOverviewRes data) => json.encode(data.toJson());

class SdOverviewRes {
  final CompanyInfo? companyInfo;
  final StockScore? stockScore;
  final List<SdTopRes>? calendar;
  final List<SdTopRes>? top;

  final List<SdTopRes>? priceTarget;
  final List<SdTopRes>? profit;
  final AnalystRecom? analystRecom;
  final MorningStar? morningStart;

  SdOverviewRes({
    this.companyInfo,
    this.stockScore,
    this.calendar,
    this.priceTarget,
    this.top,
    this.analystRecom,
    this.profit,
    this.morningStart,
  });

  factory SdOverviewRes.fromJson(Map<String, dynamic> json) => SdOverviewRes(
        companyInfo: json["company_info"] == null
            ? null
            : CompanyInfo.fromJson(json["company_info"]),
        calendar: json["company_calendar"] == null
            ? []
            : List<SdTopRes>.from(
                json["company_calendar"]!.map((x) => SdTopRes.fromJson(x))),
        analystRecom: json["analyst_recom"] == null
            ? null
            : AnalystRecom.fromJson(json["analyst_recom"]),
        top: json["top"] == null
            ? []
            : List<SdTopRes>.from(
                json["top"]!.map((x) => SdTopRes.fromJson(x))),
        priceTarget: json["price_target_rating"] == null
            ? []
            : List<SdTopRes>.from(
                json["price_target_rating"]!.map((x) => SdTopRes.fromJson(x))),
        profit: json["profitability"] == null
            ? []
            : List<SdTopRes>.from(
                json["profitability"]!.map((x) => SdTopRes.fromJson(x))),
        stockScore: json["stock_score"] == null
            ? null
            : StockScore.fromJson(json["stock_score"]),
        morningStart: json["morning_star"] == null
            ? null
            : MorningStar.fromJson(json["morning_star"]),
      );

  Map<String, dynamic> toJson() => {
        "company_info": companyInfo?.toJson(),
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "stock_score": stockScore?.toJson(),
        "analyst_recom": analystRecom?.toJson(),
        "company_calendar": calendar == null
            ? []
            : List<dynamic>.from(calendar!.map((x) => x.toJson())),
        "price_target_rating": priceTarget == null
            ? []
            : List<dynamic>.from(priceTarget!.map((x) => x.toJson())),
        "profitability": profit == null
            ? []
            : List<dynamic>.from(profit!.map((x) => x.toJson())),
        "morning_star": morningStart?.toJson(),
      };
}

class AnalystRecom {
  final String? lastUpdate;
  final int? totalAnalysis;
  final int? buyPercent;
  final int? holdPercent;
  final int? sellPercent;
  final String? source;

  AnalystRecom({
    this.lastUpdate,
    this.totalAnalysis,
    this.buyPercent,
    this.holdPercent,
    this.sellPercent,
    this.source,
  });

  factory AnalystRecom.fromJson(Map<String, dynamic> json) => AnalystRecom(
        lastUpdate: json["lastUpdate"],
        totalAnalysis: json["totalAnalysis"],
        buyPercent: json["buyPercent"],
        holdPercent: json["holdPercent"],
        sellPercent: json["sellPercent"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "lastUpdate": lastUpdate,
        "totalAnalysis": totalAnalysis,
        "buyPercent": buyPercent,
        "holdPercent": holdPercent,
        "sellPercent": sellPercent,
        "source": source,
      };
}

class CompanyCalendar {
  final String? lastEarnings;
  final String? exDividend;
  final String? dividendPayable;
  final String? today;
  final String? nextEarnings;
  final String? fiscalYearEnd;

  CompanyCalendar({
    this.lastEarnings,
    this.exDividend,
    this.dividendPayable,
    this.today,
    this.nextEarnings,
    this.fiscalYearEnd,
  });

  factory CompanyCalendar.fromJson(Map<String, dynamic> json) =>
      CompanyCalendar(
        lastEarnings: json["last_earnings"],
        exDividend: json["ex_dividend"],
        dividendPayable: json["dividend_payable"],
        today: json["today"],
        nextEarnings: json["next_earnings"],
        fiscalYearEnd: json["fiscal_year_end"],
      );

  Map<String, dynamic> toJson() => {
        "last_earnings": lastEarnings,
        "ex_dividend": exDividend,
        "dividend_payable": dividendPayable,
        "today": today,
        "next_earnings": nextEarnings,
        "fiscal_year_end": fiscalYearEnd,
      };
}

class PriceTargetRating {
  final String? averageStockPriceTarget;
  final String? highStockPriceTarget;
  final String? lowStockPriceTarget;
  final String? potentialUpsideDownside;
  final String? consensusRating;
  final String? ratingScore;
  final String? researchCoverage;

  PriceTargetRating({
    this.averageStockPriceTarget,
    this.highStockPriceTarget,
    this.lowStockPriceTarget,
    this.potentialUpsideDownside,
    this.consensusRating,
    this.ratingScore,
    this.researchCoverage,
  });

  factory PriceTargetRating.fromJson(Map<String, dynamic> json) =>
      PriceTargetRating(
        averageStockPriceTarget: json["average_stock_price_target"],
        highStockPriceTarget: json["high_stock_price_target"],
        lowStockPriceTarget: json["low_stock_price_target"],
        potentialUpsideDownside: json["potential_upside_downside"],
        consensusRating: json["consensus_rating"],
        ratingScore: json["rating_score"],
        researchCoverage: json["research_coverage"],
      );

  Map<String, dynamic> toJson() => {
        "average_stock_price_target": averageStockPriceTarget,
        "high_stock_price_target": highStockPriceTarget,
        "low_stock_price_target": lowStockPriceTarget,
        "potential_upside_downside": potentialUpsideDownside,
        "consensus_rating": consensusRating,
        "rating_score": ratingScore,
        "research_coverage": researchCoverage,
      };
}

class Profitability {
  final String? netIncome;
  final String? eps;
  final double? trailingPe;
  final double? forwardPe;
  final double? peGrowth;

  Profitability({
    this.netIncome,
    this.eps,
    this.trailingPe,
    this.forwardPe,
    this.peGrowth,
  });

  factory Profitability.fromJson(Map<String, dynamic> json) => Profitability(
        netIncome: json["net_income"],
        eps: json["eps"],
        trailingPe: json["trailing_pe"]?.toDouble(),
        forwardPe: json["forward_pe"]?.toDouble(),
        peGrowth: json["pe_growth"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "net_income": netIncome,
        "eps": eps,
        "trailing_pe": trailingPe,
        "forward_pe": forwardPe,
        "pe_growth": peGrowth,
      };
}

class StockScore {
  final String? text;
  final String? altmanZScore;
  final String? piotroskiScore;
  final String? mostRepeatedGrade;

  StockScore({
    this.text,
    this.altmanZScore,
    this.piotroskiScore,
    this.mostRepeatedGrade,
  });

  factory StockScore.fromJson(Map<String, dynamic> json) => StockScore(
        text: json["text"],
        altmanZScore: json["altman_z_score"],
        piotroskiScore: json["piotroski_score"],
        mostRepeatedGrade: json["most_repeated_grade"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "altman_z_score": altmanZScore,
        "piotroski_score": piotroskiScore,
        "most_repeated_grade": mostRepeatedGrade,
      };
}
