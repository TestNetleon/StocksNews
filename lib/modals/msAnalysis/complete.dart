import 'dart:convert';
import '../faqs_res.dart';
import 'news.dart';
import 'peer_comparision.dart';
import 'radar_chart.dart';

MsCompleteRes msCompleteResFromJson(String str) =>
    MsCompleteRes.fromJson(json.decode(str));

String msCompleteResToJson(MsCompleteRes data) => json.encode(data.toJson());

class MsCompleteRes {
  final String? recommendation;
  final List<String>? keyHighlights;
  final List<MsRadarChartRes>? stockHighLights;
  final List<MsRadarChartRes>? score;
  final List<MsRadarChartRes>? radarChart;
  List<MsRadarChartRes>? msEvents;
  final SwotAnalysis? swotAnalysis;
  final MsFundamentalsRes? fundamentals;
  final MsPeerComparisonRes? peerComparison;
  List<FaQsRes>? faqData;
  final List<MsNewsRes>? latestNews;
  // final Swot? swot;
  final MsTextRes? text;
  String? open;
  String? previousClose;
  String? volume;
  final PriceVolatilityNew? priceVolatilityNew;
  // final String? cap;
  // final num? dividendYield;
  // final num? pe;
  // final String? sector;
  // final num? sectorPe;

  MsCompleteRes({
    this.recommendation,
    this.priceVolatilityNew,
    this.swotAnalysis,
    this.keyHighlights,
    this.stockHighLights,
    this.score,
    this.faqData,
    this.latestNews,
    this.fundamentals,
    this.radarChart,
    // this.swot,
    this.text,
    this.open,
    this.previousClose,
    this.volume,
    this.peerComparison,
    this.msEvents,
    // this.cap,
    // this.dividendYield,
    // this.pe,
    // this.sector,
    // this.sectorPe,
  });

  factory MsCompleteRes.fromJson(Map<String, dynamic> json) => MsCompleteRes(
        recommendation: json["recommendation"],
        open: json['open'],
        previousClose: json['previousClose'],
        priceVolatilityNew: json["priceVolatilityNew"] == null
            ? null
            : PriceVolatilityNew.fromJson(json["priceVolatilityNew"]),

        swotAnalysis: json["swotAnalysis"] == null
            ? null
            : SwotAnalysis.fromJson(json["swotAnalysis"]),

        latestNews: json["latestNews"] == null
            ? []
            : List<MsNewsRes>.from(
                json["latestNews"]!.map((x) => MsNewsRes.fromJson(x))),

        faqData: json["faqs"] == null
            ? []
            : List<FaQsRes>.from(json["faqs"]!.map((x) => FaQsRes.fromJson(x))),

        peerComparison: json["peerComparison"] == null
            ? null
            : MsPeerComparisonRes.fromJson(json["peerComparison"]),
        msEvents: json["events"] == null
            ? []
            : List<MsRadarChartRes>.from(
                json["events"]!.map((x) => MsRadarChartRes.fromJson(x))),

        volume: json['volume'],
        fundamentals: json["fundamentals"] == null
            ? null
            : MsFundamentalsRes.fromJson(json["fundamentals"]),
        keyHighlights: json["keyHighlights"] == null
            ? []
            : List<String>.from(json["keyHighlights"]!.map((x) => x)),
        stockHighLights: json["stockHighLights"] == null
            ? []
            : List<MsRadarChartRes>.from(json["stockHighLights"]!
                .map((x) => MsRadarChartRes.fromJson(x))),
        score: json["score"] == null
            ? []
            : List<MsRadarChartRes>.from(
                json["score"]!.map((x) => MsRadarChartRes.fromJson(x))),
        radarChart: json["radar_chart"] == null
            ? []
            : List<MsRadarChartRes>.from(
                json["radar_chart"]!.map((x) => MsRadarChartRes.fromJson(x))),
        // swot: json["swot"] == null ? null : Swot.fromJson(json["swot"]),
        text: json["text"] == null ? null : MsTextRes.fromJson(json["text"]),

        // cap: json["cap"],
        // dividendYield: json["dividendYield"],
        // pe: json["pe"],
        // sector: json["sector"],
        // sectorPe: json["sector_pe"],
      );

  Map<String, dynamic> toJson() => {
        "recommendation": recommendation,
        "swotAnalysis": swotAnalysis?.toJson(),
        "priceVolatilityNew": priceVolatilityNew?.toJson(),

        "events": msEvents == null
            ? []
            : List<dynamic>.from(msEvents!.map((x) => x.toJson())),

        "faqs": faqData == null
            ? []
            : List<dynamic>.from(faqData!.map((x) => x.toJson())),

        "peerComparison": peerComparison?.toJson(),
        "latestNews": latestNews == null
            ? []
            : List<dynamic>.from(latestNews!.map((x) => x.toJson())),

        "text": text?.toJson(),
        "fundamentals": fundamentals?.toJson(),
        "keyHighlights": keyHighlights == null
            ? []
            : List<dynamic>.from(keyHighlights!.map((x) => x)),
        "stockHighLights": stockHighLights == null
            ? []
            : List<dynamic>.from(stockHighLights!.map((x) => x.toJson())),
        "score": score == null
            ? []
            : List<dynamic>.from(score!.map((x) => x.toJson())),
        "radar_chart": radarChart == null
            ? []
            : List<dynamic>.from(score!.map((x) => x.toJson())),
        // "swot": swot?.toJson(),
        // "cap": cap,
        // "dividendYield": dividendYield,
        // "pe": pe,
        // "sector": sector,
        // "sector_pe": sectorPe,
      };
}

class PriceVolatilityNew {
  final num? avg;
  final num? stockVolatility;
  final String? text;

  PriceVolatilityNew({
    this.avg,
    this.stockVolatility,
    this.text,
  });

  factory PriceVolatilityNew.fromJson(Map<String, dynamic> json) =>
      PriceVolatilityNew(
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

class SwotAnalysis {
  final List<String>? strengths;
  final List<String>? weaknesses;
  final List<String>? opportunity;
  final List<String>? threats;

  SwotAnalysis({
    this.strengths,
    this.weaknesses,
    this.opportunity,
    this.threats,
  });

  factory SwotAnalysis.fromJson(Map<String, dynamic> json) => SwotAnalysis(
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

class MsTextRes {
  final MsTextDataRes? otherStocks;
  final MsTextDataRes? ourTake;
  final MsTextDataRes? highlights;
  final MsTextDataRes? swot;
  final MsTextDataRes? volatility;
  final MsTextDataRes? peer;
  final MsTextDataRes? faq;
  final MsTextDataRes? stockScore;

  MsTextRes({
    this.otherStocks,
    this.ourTake,
    this.highlights,
    this.swot,
    this.volatility,
    this.peer,
    this.faq,
    this.stockScore,
  });

  factory MsTextRes.fromJson(Map<String, dynamic> json) => MsTextRes(
        otherStocks: json["other_stocks"] == null
            ? null
            : MsTextDataRes.fromJson(json["other_stocks"]),
        stockScore: json["stock_score"] == null
            ? null
            : MsTextDataRes.fromJson(json["stock_score"]),
        ourTake: json["our_take"] == null
            ? null
            : MsTextDataRes.fromJson(json["our_take"]),
        highlights: json["highlights"] == null
            ? null
            : MsTextDataRes.fromJson(json["highlights"]),
        swot:
            json["swot"] == null ? null : MsTextDataRes.fromJson(json["swot"]),
        volatility: json["volatility"] == null
            ? null
            : MsTextDataRes.fromJson(json["volatility"]),
        peer:
            json["peer"] == null ? null : MsTextDataRes.fromJson(json["peer"]),
        faq: json["faq"] == null ? null : MsTextDataRes.fromJson(json["faq"]),
      );

  Map<String, dynamic> toJson() => {
        "other_stocks": otherStocks?.toJson(),
        "stock_score": stockScore?.toJson(),
        "our_take": ourTake?.toJson(),
        "highlights": highlights?.toJson(),
        "swot": swot?.toJson(),
        "volatility": volatility?.toJson(),
        "peer": peer?.toJson(),
        "faq": faq?.toJson(),
      };
}

class MsTextDataRes {
  final String? title;
  final String? subTitle;
  final bool? status;
  final String? info;
  MsTextDataRes({
    this.title,
    this.subTitle,
    this.status,
    this.info,
  });

  factory MsTextDataRes.fromJson(Map<String, dynamic> json) => MsTextDataRes(
        title: json["title"],
        subTitle: json["sub_title"],
        status: json["status"],
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "status": status,
        "info": info,
      };
}

class MsFundamentalsRes {
  final List<String>? header;
  final List<MsFundamentalsResBody>? body;

  MsFundamentalsRes({
    this.header,
    this.body,
  });

  factory MsFundamentalsRes.fromJson(Map<String, dynamic> json) =>
      MsFundamentalsRes(
        header: json["header"] == null
            ? []
            : List<String>.from(json["header"]!.map((x) => x)),
        body: json["body"] == null
            ? []
            : List<MsFundamentalsResBody>.from(
                json["body"]!.map((x) => MsFundamentalsResBody.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header":
            header == null ? [] : List<dynamic>.from(header!.map((x) => x)),
        "body": body == null
            ? []
            : List<dynamic>.from(body!.map((x) => x.toJson())),
      };
}

class MsFundamentalsResBody {
  final String? label;
  final dynamic value;

  MsFundamentalsResBody({
    this.label,
    this.value,
  });

  factory MsFundamentalsResBody.fromJson(Map<String, dynamic> json) =>
      MsFundamentalsResBody(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}
