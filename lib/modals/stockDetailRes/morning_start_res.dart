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
  });

  factory MorningStar.fromJson(Map<String, dynamic> json) => MorningStar(
        id: json["_id"],
        morningStarId: json["morning_star_id"],
        symbol: json["symbol"],
        shareClassId: json["share_class_id"],
        quantStarRating: json["QuantStarRating"],
        quantStarRatingDate: DateTime.parse(json["QuantStarRatingDate"]),
        quantEconomicMoatLabel: json["QuantEconomicMoatLabel"],
        quantEconomicMoatDate: DateTime.parse(json["QuantEconomicMoatDate"]),
        priceOverQuantFairValue: json["PriceOverQuantFairValue"],
        priceOverQuantFairValueDate:
            DateTime.parse(json["PriceOverQuantFairValueDate"]),
        quantValuation: json["QuantValuation"],
        quantFairValue: json["QuantFairValue"],
        quantFairValueDate: DateTime.parse(json["QuantFairValueDate"]),
        quantFairValueUncertaintyLabel: json["QuantFairValueUncertaintyLabel"],
        quantFairValueUncertaintyDate:
            DateTime.parse(json["QuantFairValueUncertaintyDate"]),
        oneStarPrice: json["OneStarPrice"],
        oneStarPriceDate: DateTime.parse(json["OneStarPriceDate"]),
        fiveStarPrice: json["FiveStarPrice"],
        fiveStarPriceDate: DateTime.parse(json["FiveStarPriceDate"]),
        quantFinancialHealthLabel: json["QuantFinancialHealthLabel"],
        quantFinancialHealthDate:
            DateTime.parse(json["QuantFinancialHealthDate"]),
        pdfStatus: json["pdf_status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        pdfUrl: json["pdf_url"],
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
      };
}
