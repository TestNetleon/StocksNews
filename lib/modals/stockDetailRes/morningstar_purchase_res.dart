import 'dart:convert';

List<MorningStarPurchase> morningStarPurchaseFromJson(String str) =>
    List<MorningStarPurchase>.from(
        json.decode(str).map((x) => MorningStarPurchase.fromJson(x)));

String morningStarPurchaseToJson(List<MorningStarPurchase> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MorningStarPurchase {
  final dynamic id;
  final dynamic userId;
  final dynamic morningStarId;
  final dynamic symbol;
  final dynamic priceOverQuantFairValue;
  final dynamic quantFairValue;
  final dynamic oneStarPrice;
  final dynamic fiveStarPrice;
  final dynamic quantStarRatingDate;
  final dynamic quantEconomicMoatDate;
  final dynamic priceOverQuantFairValueDate;
  final dynamic quantFairValueDate;
  final dynamic quantFairValueUncertaintyDate;
  final dynamic oneStarPriceDate;
  final dynamic fiveStarPriceDate;
  final dynamic quantFinancialHealthDate;
  final dynamic pdfUrl;
  final dynamic updatedAt;
  final dynamic createdAt;
  final dynamic tickerImage;
  final dynamic purchaseDate;

  MorningStarPurchase({
    required this.id,
    required this.userId,
    required this.morningStarId,
    required this.symbol,
    required this.priceOverQuantFairValue,
    required this.quantFairValue,
    required this.oneStarPrice,
    required this.fiveStarPrice,
    required this.quantStarRatingDate,
    required this.quantEconomicMoatDate,
    required this.priceOverQuantFairValueDate,
    required this.quantFairValueDate,
    required this.quantFairValueUncertaintyDate,
    required this.oneStarPriceDate,
    required this.fiveStarPriceDate,
    required this.quantFinancialHealthDate,
    required this.pdfUrl,
    required this.updatedAt,
    required this.createdAt,
    required this.tickerImage,
    this.purchaseDate,
  });

  factory MorningStarPurchase.fromJson(Map<String, dynamic> json) =>
      MorningStarPurchase(
        id: json["_id"],
        userId: json["user_id"],
        morningStarId: json["morning_star_id"],
        symbol: json["symbol"],
        priceOverQuantFairValue: json["PriceOverQuantFairValue"],
        quantFairValue: json["QuantFairValue"],
        oneStarPrice: json["OneStarPrice"],
        fiveStarPrice: json["FiveStarPrice"],
        quantStarRatingDate: json["QuantStarRatingDate"],
        quantEconomicMoatDate: json["QuantEconomicMoatDate"],
        priceOverQuantFairValueDate: json["PriceOverQuantFairValueDate"],
        quantFairValueDate: json["QuantFairValueDate"],
        quantFairValueUncertaintyDate: json["QuantFairValueUncertaintyDate"],
        oneStarPriceDate: json["OneStarPriceDate"],
        fiveStarPriceDate: json["FiveStarPriceDate"],
        quantFinancialHealthDate: json["QuantFinancialHealthDate"],
        pdfUrl: json["pdf_url"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        tickerImage: json["ticker_image"],
        purchaseDate: json["purchase_date"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "morning_star_id": morningStarId,
        "symbol": symbol,
        "PriceOverQuantFairValue": priceOverQuantFairValue,
        "QuantFairValue": quantFairValue,
        "OneStarPrice": oneStarPrice,
        "FiveStarPrice": fiveStarPrice,
        "QuantStarRatingDate": quantStarRatingDate,
        "QuantEconomicMoatDate": quantEconomicMoatDate,
        "PriceOverQuantFairValueDate": priceOverQuantFairValueDate,
        "QuantFairValueDate": quantFairValueDate,
        "QuantFairValueUncertaintyDate": quantFairValueUncertaintyDate,
        "OneStarPriceDate": oneStarPriceDate,
        "FiveStarPriceDate": fiveStarPriceDate,
        "QuantFinancialHealthDate": quantFinancialHealthDate,
        "pdf_url": pdfUrl,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "ticker_image": tickerImage,
        "purchase_date": purchaseDate,
      };
}
