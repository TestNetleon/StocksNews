// To parse this JSON data, do
//
//     final ipoRes = ipoResFromJson(jsonString);

import 'dart:convert';

List<IpoRes> ipoResFromJson(String str) =>
    List<IpoRes>.from(json.decode(str).map((x) => IpoRes.fromJson(x)));

String ipoResToJson(List<IpoRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IpoRes {
  final String? date;
  final DateTime? daa;
  final String? company;
  final String? symbol;
  final String? exchange;
  final String? actions;
  final int? shares;
  final String? priceRange;
  final int? marketCap;

  IpoRes({
    this.date,
    this.daa,
    this.company,
    this.symbol,
    this.exchange,
    this.actions,
    this.shares,
    this.priceRange,
    this.marketCap,
  });

  factory IpoRes.fromJson(Map<String, dynamic> json) => IpoRes(
        date: json["date"],
        daa: json["daa"] == null ? null : DateTime.parse(json["daa"]),
        company: json["company"],
        symbol: json["symbol"],
        exchange: json["exchange"],
        actions: json["actions"]!,
        shares: json["shares"],
        priceRange: json["priceRange"],
        marketCap: json["marketCap"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "daa": daa?.toIso8601String(),
        "company": company,
        "symbol": symbol,
        "exchange": exchange,
        "actions": actions,
        "shares": shares,
        "priceRange": priceRange,
        "marketCap": marketCap,
      };
}
