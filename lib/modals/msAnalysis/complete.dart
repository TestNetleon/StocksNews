import 'dart:convert';
import 'radar_chart.dart';

MsCompleteRes msCompleteResFromJson(String str) =>
    MsCompleteRes.fromJson(json.decode(str));

String msCompleteResToJson(MsCompleteRes data) => json.encode(data.toJson());

class MsCompleteRes {
  final String? recommendation;
  final List<String>? keyHighlights;
  final num? priceVolatility;
  final List<MsRadarChartRes>? stockHighLights;
  final List<MsRadarChartRes>? score;
  final List<MsRadarChartRes>? radarChart;
  final MsFundamentalsRes? fundamentals;
  final Swot? swot;
  final MsTextRes? text;
  String? open;
  String? previousClose;
  String? volume;

  // final String? cap;
  // final num? dividendYield;
  // final num? pe;
  // final String? sector;
  // final num? sectorPe;

  MsCompleteRes({
    this.recommendation,
    this.keyHighlights,
    this.priceVolatility,
    this.stockHighLights,
    this.score,
    this.fundamentals,
    this.radarChart,
    this.swot,
    this.text,
    this.open,
    this.previousClose,
    this.volume,
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
        volume: json['volume'],
        fundamentals: json["fundamentals"] == null
            ? null
            : MsFundamentalsRes.fromJson(json["fundamentals"]),
        keyHighlights: json["keyHighlights"] == null
            ? []
            : List<String>.from(json["keyHighlights"]!.map((x) => x)),
        priceVolatility: json["priceVolatility"],
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
        swot: json["swot"] == null ? null : Swot.fromJson(json["swot"]),
        text: json["text"] == null ? null : MsTextRes.fromJson(json["text"]),

        // cap: json["cap"],
        // dividendYield: json["dividendYield"],
        // pe: json["pe"],
        // sector: json["sector"],
        // sectorPe: json["sector_pe"],
      );

  Map<String, dynamic> toJson() => {
        "recommendation": recommendation,
        "text": text?.toJson(),
        "fundamentals": fundamentals?.toJson(),
        "keyHighlights": keyHighlights == null
            ? []
            : List<dynamic>.from(keyHighlights!.map((x) => x)),
        "priceVolatility": priceVolatility,
        "stockHighLights": stockHighLights == null
            ? []
            : List<dynamic>.from(stockHighLights!.map((x) => x.toJson())),
        "score": score == null
            ? []
            : List<dynamic>.from(score!.map((x) => x.toJson())),
        "radar_chart": radarChart == null
            ? []
            : List<dynamic>.from(score!.map((x) => x.toJson())),
        "swot": swot?.toJson(),
        // "cap": cap,
        // "dividendYield": dividendYield,
        // "pe": pe,
        // "sector": sector,
        // "sector_pe": sectorPe,
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

  MsTextRes({
    this.otherStocks,
    this.ourTake,
    this.highlights,
    this.swot,
    this.volatility,
    this.peer,
    this.faq,
  });

  factory MsTextRes.fromJson(Map<String, dynamic> json) => MsTextRes(
        otherStocks: json["other_stocks"] == null
            ? null
            : MsTextDataRes.fromJson(json["other_stocks"]),
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

  MsTextDataRes({
    this.title,
    this.subTitle,
  });

  factory MsTextDataRes.fromJson(Map<String, dynamic> json) => MsTextDataRes(
        title: json["title"],
        subTitle: json["sub_title"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
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

class Swot {
  final num? strength;
  final num? weaknesses;
  final num? opportunity;
  final num? threats;

  Swot({
    this.strength,
    this.weaknesses,
    this.opportunity,
    this.threats,
  });

  factory Swot.fromJson(Map<String, dynamic> json) => Swot(
        strength: json["strength"],
        weaknesses: json["weaknesses"],
        opportunity: json["opportunitie"],
        threats: json["threats"],
      );

  Map<String, dynamic> toJson() => {
        "strength": strength,
        "weaknesses": weaknesses,
        "opportunitie": opportunity,
        "threats": threats,
      };
}
