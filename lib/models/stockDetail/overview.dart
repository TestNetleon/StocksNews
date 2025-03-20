import 'dart:convert';

import '../ai_analysis.dart';

SDOverviewRes stocksDetailOverviewResFromJson(String str) =>
    SDOverviewRes.fromJson(json.decode(str));

String stocksDetailOverviewResToJson(SDOverviewRes data) =>
    json.encode(data.toJson());

class SDOverviewRes {
  final SDCompanyRes? companyInfo;
  final SDStockScoreRes? stockScore;
  final AIradarChartRes? aiAnalysis;
  final MorningStarRes? morningStar;

  SDOverviewRes({
    this.companyInfo,
    this.stockScore,
    this.aiAnalysis,
    this.morningStar,
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
            : AIradarChartRes.fromJson(json["ai_analysis"]),
        morningStar: json["morning_star"] == null
            ? null
            : MorningStarRes.fromJson(json["morning_star"]),
      );

  Map<String, dynamic> toJson() => {
        "company_info": companyInfo?.toJson(),
        "stock_score": stockScore?.toJson(),
        "ai_analysis": aiAnalysis?.toJson(),
        "morning_star": morningStar?.toJson(),
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

BaseKeyValueRes baseResDataFromJson(String str) =>
    BaseKeyValueRes.fromJson(json.decode(str));

String baseResDataToJson(BaseKeyValueRes data) => json.encode(data.toJson());

class BaseKeyValueRes {
  final String? title;
  final String? subTitle;
  final String? other;
  final dynamic value;
  final String? slug;
  final String? icon;
  final dynamic color;
  final String? simple;
  final String? simpleStatus;
  final String? exponential;
  final String? exponentialStatus;
  final String? weighted;
  final String? weightedStatus;
  final String? date;
  final String? action;
  bool? selected;
  final List<BaseKeyValueRes>? data;

  BaseKeyValueRes({
    this.title,
    this.subTitle,
    this.other,
    this.value,
    this.slug,
    this.icon,
    this.color,
    this.simple,
    this.simpleStatus,
    this.exponential,
    this.exponentialStatus,
    this.weighted,
    this.weightedStatus,
    this.date,
    this.action,
    this.selected,
    this.data,
  });

  factory BaseKeyValueRes.fromJson(Map<String, dynamic> json) =>
      BaseKeyValueRes(
        title: json["title"],
        subTitle: json['sub_title'],
        other: json['other'],
        value: json["value"],
        slug: json['slug'],
        icon: json['icon'],
        color: json['color'],
        simple: json["simple"],
        simpleStatus: json["simple_status"],
        exponential: json["exponential"],
        exponentialStatus: json["exponential_status"],
        weighted: json["weighted"],
        weightedStatus: json["weighted_status"],
        date: json["date"],
        action: json["action"],
        selected: json["selected"],
        data: json["data"] == null
            ? null
            : List<BaseKeyValueRes>.from(
          json["data"].map((x) => BaseKeyValueRes.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        'sub_title': subTitle,
        'other': other,
        "value": value,
        "slug": slug,
        "icon": icon,
        "color": color,
        "simple": simple,
        "simple_status": simpleStatus,
        "exponential": exponential,
        "exponential_status": exponentialStatus,
        "weighted": weighted,
        "weighted_status": weightedStatus,
        "date": date,
        "action": action,
        "selected": selected,
    "data": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),

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

//MARK: Morning Star

class MorningStarRes {
  final String? id;
  final String? morningStarId;
  final String? symbol;
  final String? shareClassId;
  final num? quantStarRating;
  final String? quantStarRatingDate;
  final String? quantEconomicMoatLabel;
  final String? quantEconomicMoatDate;
  final String? priceOverQuantFairValue;
  final String? priceOverQuantFairValueDate;
  final String? quantValuation;
  final String? quantFairValue;
  final String? quantFairValueDate;
  final String? quantFairValueUncertaintyLabel;
  final String? quantFairValueUncertaintyDate;
  final String? oneStarPrice;
  final String? oneStarPriceDate;
  final String? fiveStarPrice;
  final String? fiveStarPriceDate;
  final String? quantFinancialHealthLabel;
  final String? quantFinancialHealthDate;
  final num? pdfStatus;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? pdfUrl;
  final MorningStarLockInfo? lockInformation;
  final String? updated;
  final String? description;
  final String? viewAllText;

  MorningStarRes({
    this.id,
    this.morningStarId,
    this.symbol,
    this.shareClassId,
    this.quantStarRating,
    this.quantStarRatingDate,
    this.quantEconomicMoatLabel,
    this.quantEconomicMoatDate,
    this.priceOverQuantFairValue,
    this.priceOverQuantFairValueDate,
    this.quantValuation,
    this.quantFairValue,
    this.quantFairValueDate,
    this.quantFairValueUncertaintyLabel,
    this.quantFairValueUncertaintyDate,
    this.oneStarPrice,
    this.oneStarPriceDate,
    this.fiveStarPrice,
    this.fiveStarPriceDate,
    this.quantFinancialHealthLabel,
    this.quantFinancialHealthDate,
    this.pdfStatus,
    this.updatedAt,
    this.createdAt,
    this.pdfUrl,
    this.lockInformation,
    this.updated,
    this.description,
    this.viewAllText,
  });

  factory MorningStarRes.fromJson(Map<String, dynamic> json) => MorningStarRes(
        id: json["_id"],
        morningStarId: json["morning_star_id"],
        symbol: json["symbol"],
        shareClassId: json["share_class_id"],
        quantStarRating: json["QuantStarRating"],
        quantStarRatingDate: json["QuantStarRatingDate"],
        quantEconomicMoatLabel: json["QuantEconomicMoatLabel"],
        quantEconomicMoatDate: json["QuantEconomicMoatDate"],
        priceOverQuantFairValue: json["PriceOverQuantFairValue"],
        priceOverQuantFairValueDate: json["PriceOverQuantFairValueDate"],
        quantValuation: json["QuantValuation"],
        quantFairValue: json["QuantFairValue"],
        quantFairValueDate: json["QuantFairValueDate"],
        quantFairValueUncertaintyLabel: json["QuantFairValueUncertaintyLabel"],
        quantFairValueUncertaintyDate: json["QuantFairValueUncertaintyDate"],
        oneStarPrice: json["OneStarPrice"],
        oneStarPriceDate: json["OneStarPriceDate"],
        fiveStarPrice: json["FiveStarPrice"],
        fiveStarPriceDate: json["FiveStarPriceDate"],
        quantFinancialHealthLabel: json["QuantFinancialHealthLabel"],
        quantFinancialHealthDate: json["QuantFinancialHealthDate"],
        pdfStatus: json["pdf_status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        pdfUrl: json["pdf_url"],
        lockInformation: json["lock_information"] == null
            ? null
            : MorningStarLockInfo.fromJson(json["lock_information"]),
        updated: json["updated"],
        description: json["description"],
        viewAllText: json["view_all_text"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "morning_star_id": morningStarId,
        "symbol": symbol,
        "share_class_id": shareClassId,
        "QuantStarRating": quantStarRating,
        "QuantStarRatingDate": quantStarRatingDate,
        "QuantEconomicMoatLabel": quantEconomicMoatLabel,
        "QuantEconomicMoatDate": quantEconomicMoatDate,
        "PriceOverQuantFairValue": priceOverQuantFairValue,
        "PriceOverQuantFairValueDate": priceOverQuantFairValueDate,
        "QuantValuation": quantValuation,
        "QuantFairValue": quantFairValue,
        "QuantFairValueDate": quantFairValueDate,
        "QuantFairValueUncertaintyLabel": quantFairValueUncertaintyLabel,
        "QuantFairValueUncertaintyDate": quantFairValueUncertaintyDate,
        "OneStarPrice": oneStarPrice,
        "OneStarPriceDate": oneStarPriceDate,
        "FiveStarPrice": fiveStarPrice,
        "FiveStarPriceDate": fiveStarPriceDate,
        "QuantFinancialHealthLabel": quantFinancialHealthLabel,
        "QuantFinancialHealthDate": quantFinancialHealthDate,
        "pdf_status": pdfStatus,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "pdf_url": pdfUrl,
        "lock_information": lockInformation?.toJson(),
        "updated": updated,
        "description": description,
        "view_all_text": viewAllText,
      };
}

class MorningStarLockInfo {
  final bool? readingStatus;
  final String? title;
  final String? readingSubtitle;
  final String? readingTitle;
  final String? readingHeading;

  final bool? balanceStatus;
  final int? totalPoints;
  final int? pointRequired;
  final String? popUpMessage;
  final String? popUpButton;
  final dynamic showSubscribeBtn;
  final dynamic showUpgradeBtn;
  final dynamic showViewBtn;

  MorningStarLockInfo({
    this.readingStatus,
    this.title,
    this.readingSubtitle,
    this.readingTitle,
    this.readingHeading,
    this.balanceStatus,
    this.totalPoints,
    this.pointRequired,
    this.popUpMessage,
    this.popUpButton,
    this.showSubscribeBtn,
    this.showUpgradeBtn,
    this.showViewBtn,
  });

  factory MorningStarLockInfo.fromJson(Map<String, dynamic> json) =>
      MorningStarLockInfo(
        readingStatus: json["reading_status"],
        title: json["title"],
        readingHeading: json['reading_heading'],
        readingSubtitle: json["reading_subtitle"],
        readingTitle: json["reading_title"],
        balanceStatus: json["balance_status"],
        totalPoints: json["total_points"],
        pointRequired: json["point_required"],
        popUpMessage: json["popup_message"],
        popUpButton: json["popup_button"],
        showSubscribeBtn: json["show_subscribe_btn"],
        showUpgradeBtn: json["show_upgrade_btn"],
        showViewBtn: json["show_view_btn"],
      );

  Map<String, dynamic> toJson() => {
        "reading_status": readingStatus,
        "title": title,
        'reading_heading': readingHeading,
        "reading_subtitle": readingSubtitle,
        "reading_title": readingTitle,
        "balance_status": balanceStatus,
        "total_points": totalPoints,
        "point_required": pointRequired,
        "popup_message": popUpMessage,
        "popup_button": popUpButton,
        "show_subscribe_btn": showSubscribeBtn,
        "show_upgrade_btn": showUpgradeBtn,
        "show_view_btn": showViewBtn,
      };
}
