// To parse this JSON data, do
//
//     final congressionalRes = congressionalResFromJson(jsonString);

import 'dart:convert';

List<CongressionalRes> congressionalResFromJson(String str) =>
    List<CongressionalRes>.from(
        json.decode(str).map((x) => CongressionalRes.fromJson(x)));

String congressionalResToJson(List<CongressionalRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CongressionalRes {
  final dynamic name;
  final dynamic symbol;
  final dynamic company;
  final dynamic currentPrice;
  final dynamic type;
  final dynamic amount;
  final dynamic dateFiled;
  final dynamic dateTraded;

  CongressionalRes({
    this.name,
    this.symbol,
    this.company,
    this.currentPrice,
    this.type,
    this.amount,
    this.dateFiled,
    this.dateTraded,
  });

  factory CongressionalRes.fromJson(Map<String, dynamic> json) =>
      CongressionalRes(
        name: json["name"],
        symbol: json["symbol"],
        company: json["company"],
        currentPrice: json["current_price"],
        type: json["type"],
        amount: json["amount"],
        dateFiled: json["date_filed"],
        dateTraded: json["date_traded"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "company": company,
        "current_price": currentPrice,
        "type": type,
        "amount": amount,
        "date_filed": dateFiled,
        "date_traded": dateTraded,
      };
}
