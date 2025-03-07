import 'package:stocks_news_new/modals/stockDetailRes/lock_information_res.dart';

class MorningStar {
  final dynamic id;
  final dynamic morningStarId;
  final dynamic symbol;
  final dynamic shareClassId;
  final dynamic quantStarRating;
  final dynamic quantStarRatingDate;
  final dynamic quantEconomicMoatLabel;
  final dynamic quantEconomicMoatDate;
  final dynamic priceOverQuantFairValue;
  final dynamic priceOverQuantFairValueDate;
  final dynamic quantValuation;
  final dynamic quantFairValue;
  final dynamic quantFairValueDate;
  final dynamic quantFairValueUncertaintyLabel;
  final dynamic quantFairValueUncertaintyDate;
  final dynamic oneStarPrice;
  final dynamic oneStarPriceDate;
  final dynamic fiveStarPrice;
  final dynamic fiveStarPriceDate;
  final dynamic quantFinancialHealthLabel;
  final dynamic quantFinancialHealthDate;
  final dynamic pdfStatus;
  final dynamic updatedAt;
  final dynamic createdAt;
  final dynamic pdfUrl;
  final dynamic updated;
  final LockInformation? lockInformation;
  final dynamic description;
  final dynamic viewAllText;

  MorningStar({
    required this.id,
    required this.morningStarId,
    required this.symbol,
    required this.shareClassId,
    required this.quantStarRating,
    required this.quantStarRatingDate,
    required this.quantEconomicMoatLabel,
    required this.quantEconomicMoatDate,
    required this.priceOverQuantFairValue,
    required this.priceOverQuantFairValueDate,
    required this.quantValuation,
    required this.quantFairValue,
    required this.quantFairValueDate,
    required this.quantFairValueUncertaintyLabel,
    required this.quantFairValueUncertaintyDate,
    required this.oneStarPrice,
    required this.oneStarPriceDate,
    required this.fiveStarPrice,
    required this.fiveStarPriceDate,
    required this.quantFinancialHealthLabel,
    required this.quantFinancialHealthDate,
    required this.pdfStatus,
    required this.updatedAt,
    required this.createdAt,
    required this.pdfUrl,
    this.lockInformation,
    required this.updated,
    required this.description,
    required this.viewAllText,
  });

  factory MorningStar.fromJson(Map<String, dynamic> json) => MorningStar(
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
        updatedAt: json["updated_at"],
        lockInformation: json["lock_information"] == null
            ? null
            : LockInformation.fromJson(json["lock_information"]),
        createdAt: json["created_at"],
        pdfUrl: json["pdf_url"],
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
        "updated_at": updatedAt,
        "created_at": createdAt,
        "pdf_url": pdfUrl,
        "updated": updated,
        "lock_information": lockInformation?.toJson(),
        "description": description,
        "view_all_text": viewAllText,
      };
}
