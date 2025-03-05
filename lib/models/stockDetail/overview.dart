import 'dart:convert';

SDOverviewRes stocksDetailOverviewResFromJson(String str) =>
    SDOverviewRes.fromJson(json.decode(str));

String stocksDetailOverviewResToJson(SDOverviewRes data) =>
    json.encode(data.toJson());

class SDOverviewRes {
  final SDCompanyRes? companyInfo;
  final SDStockScoreRes? stockScore;
  final SDAiAnalysisRes? aiAnalysis;

  SDOverviewRes({
    this.companyInfo,
    this.stockScore,
    this.aiAnalysis,
  });

  factory SDOverviewRes.fromJson(Map<String, dynamic> json) => SDOverviewRes(
        companyInfo: json["company_info"] == null
            ? null
            : SDCompanyRes.fromJson(json["company_info"]),
        stockScore: json["stock_score"] == null
            ? null
            : SDStockScoreRes.fromJson(json["stock_score"]),
        aiAnalysis: json["ai_analysis"] == null
            ? null
            : SDAiAnalysisRes.fromJson(json["ai_analysis"]),
      );

  Map<String, dynamic> toJson() => {
        "company_info": companyInfo?.toJson(),
        "stock_score": stockScore?.toJson(),
        "ai_analysis": aiAnalysis?.toJson(),
      };
}

class SDAiAnalysisRes {
  final String? title;
  final BaseKeyValueRes? recommendation;
  final List<RadarChartRes>? radarChart;

  SDAiAnalysisRes({
    this.title,
    this.radarChart,
    this.recommendation,
  });

  factory SDAiAnalysisRes.fromJson(Map<String, dynamic> json) =>
      SDAiAnalysisRes(
        title: json["title"],
        recommendation: json["recommendation"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["recommendation"]),
        radarChart: json["radar_chart"] == null
            ? []
            : List<RadarChartRes>.from(
                json["radar_chart"]!.map((x) => RadarChartRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "recommendation": recommendation?.toJson(),
        "radar_chart": radarChart == null
            ? []
            : List<dynamic>.from(radarChart!.map((x) => x.toJson())),
      };
}

class RadarChartRes {
  final String? label;
  final num? value;
  final String? description;

  RadarChartRes({
    this.label,
    this.value,
    this.description,
  });

  factory RadarChartRes.fromJson(Map<String, dynamic> json) => RadarChartRes(
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

class SDStockScoreRes {
  final String? title;
  final BaseKeyValueRes? altmanZScore;
  final BaseKeyValueRes? piotroskiScore;
  final BaseKeyValueRes? mostRepeatedGrade;

  SDStockScoreRes({
    this.title,
    this.altmanZScore,
    this.piotroskiScore,
    this.mostRepeatedGrade,
  });

  factory SDStockScoreRes.fromJson(Map<String, dynamic> json) =>
      SDStockScoreRes(
        title: json["title"],
        altmanZScore: json["altman_z_score"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["altman_z_score"]),
        piotroskiScore: json["piotroski_score"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["piotroski_score"]),
        mostRepeatedGrade: json["most_repeated_grade"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["most_repeated_grade"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "altman_z_score": altmanZScore?.toJson(),
        "piotroski_score": piotroskiScore?.toJson(),
        "most_repeated_grade": mostRepeatedGrade?.toJson(),
      };
}

class BaseKeyValueRes {
  final String? title;
  final String? subTitle;
  final dynamic value;
  final String? slug;
  final dynamic color;
  final String? simple;
  final String? simpleStatus;
  final String? exponential;
  final String? exponentialStatus;
  final String? weighted;
  final String? weightedStatus;
  final String? date;
  final String? action;

  BaseKeyValueRes({
    this.title,
    this.subTitle,
    this.value,
    this.slug,
    this.color,
    this.simple,
    this.simpleStatus,
    this.exponential,
    this.exponentialStatus,
    this.weighted,
    this.weightedStatus,
    this.date,
    this.action,
  });

  factory BaseKeyValueRes.fromJson(Map<String, dynamic> json) =>
      BaseKeyValueRes(
        title: json["title"],
        subTitle: json['sub_title'],
        value: json["value"],
        slug: json['slug'],
        color: json['color'],
        simple: json["simple"],
        simpleStatus: json["simple_status"],
        exponential: json["exponential"],
        exponentialStatus: json["exponential_status"],
        weighted: json["weighted"],
        weightedStatus: json["weighted_status"],
        date: json["date"],
        action: json["action"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        'sub_title': subTitle,
        "value": value,
        "slug": slug,
        "color": color,
        "simple": simple,
        "simple_status": simpleStatus,
        "exponential": exponential,
        "exponential_status": exponentialStatus,
        "weighted": weighted,
        "weighted_status": weightedStatus,
        "date": date,
        "action": action,
      };
}

class SDCompanyRes {
  final String? title;
  final BaseKeyValueRes? ceo;
  final BaseKeyValueRes? country;
  final BaseKeyValueRes? fullTimeEmployees;
  final BaseKeyValueRes? ipoDate;
  final BaseKeyValueRes? isIn;
  final BaseKeyValueRes? sector;
  final BaseKeyValueRes? industry;
  final BaseKeyValueRes? website;
  final String? description;
  final num? dayLow;
  final num? dayHigh;
  final num? yearLow;
  final num? yearHigh;
  final num? currentPrice;

  SDCompanyRes({
    this.title,
    this.ceo,
    this.country,
    this.fullTimeEmployees,
    this.ipoDate,
    this.isIn,
    this.sector,
    this.industry,
    this.website,
    this.description,
    this.dayLow,
    this.dayHigh,
    this.yearLow,
    this.yearHigh,
    this.currentPrice,
  });

  factory SDCompanyRes.fromJson(Map<String, dynamic> json) => SDCompanyRes(
        title: json["title"],
        ceo: json["ceo"] == null ? null : BaseKeyValueRes.fromJson(json["ceo"]),
        country: json["country"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["country"]),
        fullTimeEmployees: json["fullTimeEmployees"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["fullTimeEmployees"]),
        ipoDate: json["ipoDate"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["ipoDate"]),
        isIn: json["isIn"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["isIn"]),
        sector: json["sector"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["sector"]),
        industry: json["industry"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["industry"]),
        website: json["website"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["website"]),
        description: json["description"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        yearLow: json["yearLow"],
        yearHigh: json["yearHigh"],
        currentPrice: json["currentPrice"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "ceo": ceo?.toJson(),
        "country": country?.toJson(),
        "fullTimeEmployees": fullTimeEmployees?.toJson(),
        "ipoDate": ipoDate?.toJson(),
        "isIn": isIn?.toJson(),
        "sector": sector?.toJson(),
        "industry": industry?.toJson(),
        "website": website?.toJson(),
        "description": description,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "yearLow": yearLow,
        "yearHigh": yearHigh,
        "currentPrice": currentPrice,
      };
}
