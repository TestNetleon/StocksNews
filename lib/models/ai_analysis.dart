import 'dart:convert';

import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/models/ticker.dart';

import 'lock.dart';

AIRes AIResFromJson(String str) => AIRes.fromJson(json.decode(str));

String AIResToJson(AIRes data) => json.encode(data.toJson());

class AIRes {
  final BaseTickerRes? tickerDetail;
  final AIradarChartRes? radarChart;
  final AIourTakeRes? ourTake;
  final AIswotRes? swot;
  final AIPerformanceRes? performance;
  final BaseFaqRes? faqs;
//
  final AIHighlightsRes? highlights;
  final AIPriceVolatilityRes? priceVolatility;
  final List<BaseNewsRes>? latestNews;
  final List<BaseKeyValueRes>? events;
  final AIFundamentalsRes? fundamentals;
  final AIPeerComparisonRes? peerComparison;
  final String? lastUpdateDate;
  final String? usdText;
  final BaseLockInfoRes? lockInfo;

  AIRes({
    this.lockInfo,
    this.tickerDetail,
    this.radarChart,
    this.ourTake,
    this.swot,
    this.performance,
    this.faqs,
    //
    this.highlights,
    this.priceVolatility,
    this.latestNews,
    this.events,
    this.fundamentals,
    this.peerComparison,
    this.lastUpdateDate,
    this.usdText,
  });

  factory AIRes.fromJson(Map<String, dynamic> json) => AIRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        tickerDetail: json["ticker_data"] == null
            ? null
            : BaseTickerRes.fromJson(json["ticker_data"]),
        radarChart: json["radar_chart"] == null
            ? null
            : AIradarChartRes.fromJson(json["radar_chart"]),
        ourTake: json["our_take"] == null
            ? null
            : AIourTakeRes.fromJson(json["our_take"]),
        swot: json["swot"] == null ? null : AIswotRes.fromJson(json["swot"]),
        performance: json["performance"] == null
            ? null
            : AIPerformanceRes.fromJson(json["performance"]),
        faqs: json["faqs"] == null ? null : BaseFaqRes.fromJson(json["faqs"]),
        //
        highlights: json["highlights"] == null
            ? null
            : AIHighlightsRes.fromJson(json["highlights"]),
        priceVolatility: json["priceVolatility"] == null
            ? null
            : AIPriceVolatilityRes.fromJson(json["priceVolatility"]),
        latestNews: json["latestNews"] == null
            ? []
            : List<BaseNewsRes>.from(
                json["latestNews"]!.map((x) => BaseNewsRes.fromJson(x))),

        events: json["events"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["events"]!.map((x) => BaseKeyValueRes.fromJson(x))),
        fundamentals: json["fundamentals"] == null
            ? null
            : AIFundamentalsRes.fromJson(json["fundamentals"]),
        peerComparison: json["peerComparison"] == null
            ? null
            : AIPeerComparisonRes.fromJson(json["peerComparison"]),
        lastUpdateDate: json["last_update_date"],
        usdText: json["usd_text"],
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "ticker_data": tickerDetail?.toJson(),
        "radar_chart": radarChart?.toJson(),
        "our_take": ourTake?.toJson(),
        "swot": swot?.toJson(),
        "performance": performance?.toJson(),
        "faqs": faqs?.toJson(),
        //
        "highlights": highlights?.toJson(),
        "priceVolatility": priceVolatility?.toJson(),
        "latestNews": latestNews == null
            ? []
            : List<dynamic>.from(latestNews!.map((x) => x.toJson())),
        "events": events == null
            ? []
            : List<dynamic>.from(events!.map((x) => x.toJson())),
        "fundamentals": fundamentals?.toJson(),
        "peerComparison": peerComparison?.toJson(),
        "last_update_date": lastUpdateDate,
        "usd_text": usdText,
      };
}

class AIourTakeRes {
  final String? title;
  final List<String>? data;

  AIourTakeRes({
    this.title,
    this.data,
  });

  factory AIourTakeRes.fromJson(Map<String, dynamic> json) => AIourTakeRes(
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<String>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}

class AIPerformanceRes {
  final String? title;
  final num? price;
  final num? yearHigh;
  final num? yearLow;
  final num? dayHigh;
  final num? dayLow;
  final String? open;
  final String? previousClose;
  final String? volume;

  AIPerformanceRes({
    this.title,
    this.price,
    this.yearHigh,
    this.yearLow,
    this.dayHigh,
    this.dayLow,
    this.open,
    this.previousClose,
    this.volume,
  });

  factory AIPerformanceRes.fromJson(Map<String, dynamic> json) =>
      AIPerformanceRes(
        title: json["title"],
        price: json["price"],
        yearHigh: json["yearHigh"],
        yearLow: json["yearLow"],
        dayHigh: json["dayHigh"],
        dayLow: json["dayLow"],
        open: json["open"],
        previousClose: json["previousClose"],
        volume: json["volume"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "yearHigh": yearHigh,
        "yearLow": yearLow,
        "dayHigh": dayHigh,
        "dayLow": dayLow,
        "open": open,
        "previousClose": previousClose,
        "volume": volume,
      };
}

class AIradarChartRes {
  final String? title;
  final BaseKeyValueRes? recommendation;
  final List<AIradarChartDataRes>? radarChart;
  final BaseLockInfoRes? lockInfo;

  AIradarChartRes({
    this.title,
    this.recommendation,
    this.radarChart,
    this.lockInfo,
  });

  factory AIradarChartRes.fromJson(Map<String, dynamic> json) =>
      AIradarChartRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        title: json["title"],
        recommendation: json["recommendation"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["recommendation"]),
        radarChart: json["radar_chart"] == null
            ? []
            : List<AIradarChartDataRes>.from(json["radar_chart"]!
                .map((x) => AIradarChartDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "title": title,
        "recommendation": recommendation?.toJson(),
        "radar_chart": radarChart == null
            ? []
            : List<dynamic>.from(radarChart!.map((x) => x.toJson())),
      };
}

class AIradarChartDataRes {
  final String? label;
  final num? value;
  final String? description;

  AIradarChartDataRes({
    this.label,
    this.value,
    this.description,
  });

  factory AIradarChartDataRes.fromJson(Map<String, dynamic> json) =>
      AIradarChartDataRes(
        label: json["label"],
        value: json["value"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "description": description,
      };
}

class AIswotRes {
  final String? title;
  final AIswotDataRes? data;

  AIswotRes({
    this.title,
    this.data,
  });

  factory AIswotRes.fromJson(Map<String, dynamic> json) => AIswotRes(
        title: json["title"],
        data:
            json["data"] == null ? null : AIswotDataRes.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data?.toJson(),
      };
}

class AIswotDataRes {
  final List<String>? strengths;
  final List<String>? weaknesses;
  final List<String>? opportunity;
  final List<String>? threats;

  AIswotDataRes({
    this.strengths,
    this.weaknesses,
    this.opportunity,
    this.threats,
  });

  factory AIswotDataRes.fromJson(Map<String, dynamic> json) => AIswotDataRes(
        strengths: json["strengths"] == null
            ? []
            : List<String>.from(json["strengths"]!.map((x) => x)),
        weaknesses: json["weaknesses"] == null
            ? []
            : List<String>.from(json["weaknesses"]!.map((x) => x)),
        opportunity: json["opportunity"] == null
            ? []
            : List<String>.from(json["opportunity"]!.map((x) => x)),
        threats: json["threats"] == null
            ? []
            : List<String>.from(json["threats"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "strengths": strengths == null
            ? []
            : List<dynamic>.from(strengths!.map((x) => x)),
        "weaknesses": weaknesses == null
            ? []
            : List<dynamic>.from(weaknesses!.map((x) => x)),
        "opportunity": opportunity == null
            ? []
            : List<dynamic>.from(opportunity!.map((x) => x)),
        "threats":
            threats == null ? [] : List<dynamic>.from(threats!.map((x) => x)),
      };
}

class AIFundamentalsRes {
  final String? title;
  final List<String>? header;
  final List<BaseKeyValueRes>? data;

  AIFundamentalsRes({
    this.title,
    this.header,
    this.data,
  });

  factory AIFundamentalsRes.fromJson(Map<String, dynamic> json) =>
      AIFundamentalsRes(
        title: json["title"],
        header: json["header"] == null
            ? []
            : List<String>.from(json["header"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["data"]!.map((x) => BaseKeyValueRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "header":
            header == null ? [] : List<dynamic>.from(header!.map((x) => x)),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AIHighlightsRes {
  final String? title;
  final List<BaseKeyValueRes>? data;

  AIHighlightsRes({
    this.title,
    this.data,
  });

  factory AIHighlightsRes.fromJson(Map<String, dynamic> json) =>
      AIHighlightsRes(
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["data"]!.map((x) => BaseKeyValueRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AIPeerComparisonRes {
  final String? title;
  final List<String>? headers;
  final List<PeerComparisonElementRes>? peerComparison;

  AIPeerComparisonRes({
    this.headers,
    this.title,
    this.peerComparison,
  });

  factory AIPeerComparisonRes.fromJson(Map<String, dynamic> json) =>
      AIPeerComparisonRes(
        title: json['title'],
        headers: json["header"] == null
            ? []
            : List<String>.from(json["header"]!.map((x) => x)),
        peerComparison: json["data"] == null
            ? []
            : List<PeerComparisonElementRes>.from(
                json["data"]!.map((x) => PeerComparisonElementRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        "header":
            headers == null ? [] : List<dynamic>.from(headers!.map((x) => x)),
        "data": peerComparison == null
            ? []
            : List<dynamic>.from(peerComparison!.map((x) => x.toJson())),
      };
}

class PeerComparisonElementRes {
  final String? symbol;
  final String? name;
  final String? image;
  final num? peRatio;
  final num? returns;
  final num? salesGrowth;
  final num? profitGrowth;
  final num? roe;

  PeerComparisonElementRes({
    this.symbol,
    this.name,
    this.image,
    this.peRatio,
    this.returns,
    this.salesGrowth,
    this.profitGrowth,
    this.roe,
  });

  factory PeerComparisonElementRes.fromJson(Map<String, dynamic> json) =>
      PeerComparisonElementRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        peRatio: json["pe_ratio"],
        returns: json["returns"],
        salesGrowth: json["sales_growth"],
        profitGrowth: json["profit_growth"],
        roe: json["roe"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "pe_ratio": peRatio,
        "returns": returns,
        "sales_growth": salesGrowth,
        "profit_growth": profitGrowth,
        "roe": roe,
      };
}

class AIPriceVolatilityRes {
  final String? title;
  final PriceVolatilityDataRes? data;

  AIPriceVolatilityRes({
    this.title,
    this.data,
  });

  factory AIPriceVolatilityRes.fromJson(Map<String, dynamic> json) =>
      AIPriceVolatilityRes(
        title: json["title"],
        data: json["data"] == null
            ? null
            : PriceVolatilityDataRes.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data?.toJson(),
      };
}

class PriceVolatilityDataRes {
  final num? avg;
  final num? stockVolatility;
  final String? text;

  PriceVolatilityDataRes({
    this.avg,
    this.stockVolatility,
    this.text,
  });

  factory PriceVolatilityDataRes.fromJson(Map<String, dynamic> json) =>
      PriceVolatilityDataRes(
        avg: json["avg"],
        stockVolatility: json["stock_volatility"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "avg": avg,
        "stock_volatility": stockVolatility,
        "text": text,
      };
}
