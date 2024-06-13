// To parse this JSON data, do
//
//     final plaidDataRes = plaidDataResFromJson(jsonString);

import 'dart:convert';

List<PlaidDataRes> plaidDataResFromJson(String str) => List<PlaidDataRes>.from(
    json.decode(str).map((x) => PlaidDataRes.fromJson(x)));

String plaidDataResToJson(List<PlaidDataRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaidDataRes {
  // final dynamic id;
  // final dynamic userId;
  final dynamic tickerSymbol;
  // final dynamic validTicker;
  final dynamic image;
  final int? validTicker;
  final dynamic closePrice;
  final dynamic investmentValue;
  final dynamic qty;
  final String? change;
  final num? changesPercentage;

  // final dynamic institutionId;
  // final dynamic institutionSecurityId;
  // final dynamic isCashEquivalent;
  final dynamic name;
  // final dynamic securityId;
  final dynamic type;
  // final dynamic updateDatetime;
  // final dynamic marketIdentifierCode;
  // final DateTime? updatedAt;
  // final DateTime? createdAt;

  PlaidDataRes({
    // this.id,
    // this.userId,
    this.tickerSymbol,
    this.change,
    this.changesPercentage,
    this.investmentValue,
    this.validTicker,
    this.qty,

    // this.validTicker,
    this.image,
    this.closePrice,
    // this.institutionId,
    // this.institutionSecurityId,
    // this.isCashEquivalent,
    this.name,
    // this.securityId,
    this.type,
    // this.updateDatetime,
    // this.marketIdentifierCode,
    // this.updatedAt,
    // this.createdAt,
  });

  factory PlaidDataRes.fromJson(Map<String, dynamic> json) => PlaidDataRes(
        // id: json["_id"],
        // userId: json["user_id"],
        tickerSymbol: json["ticker_symbol"],
        investmentValue: json['investment_value'],
        qty: json["quantity"],
        change: json['change'],
        changesPercentage: json['changesPercentage'],
        // validTicker: json["valid_ticker"],
        image: json["image"],
        closePrice: json["close_price"],
        // institutionId: json["institution_id"],
        // institutionSecurityId: json["institution_security_id"],
        // isCashEquivalent: json["is_cash_equivalent"],
        name: json["name"],
        validTicker: json['valid_ticker'],
        // securityId: json["security_id"],
        type: json["type"],
        // updateDatetime: json["update_datetime"],
        // marketIdentifierCode: json["market_identifier_code"],
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
        // createdAt: json["created_at"] == null
        //     ? null
        //     : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        // "user_id": userId,
        "ticker_symbol": tickerSymbol,
        'investment_value': investmentValue,
        // "valid_ticker": validTicker,
        "image": image,
        "close_price": closePrice,
        'changesPercentage': changesPercentage,
        "change": change,
        "quantity": qty,
        "valid_ticker": validTicker,
        // "institution_id": institutionId,
        // "institution_security_id": institutionSecurityId,
        // "is_cash_equivalent": isCashEquivalent,
        "name": name,
        // "security_id": securityId,
        "type": type,
        // "update_datetime": updateDatetime,
        // "market_identifier_code": marketIdentifierCode,
        // "updated_at": updatedAt?.toIso8601String(),
        // "created_at": createdAt?.toIso8601String(),
      };
}
