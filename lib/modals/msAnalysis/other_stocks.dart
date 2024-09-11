import 'dart:convert';

List<MsMyOtherStockRes> msMyOtherStockResFromJson(String str) =>
    List<MsMyOtherStockRes>.from(
        json.decode(str).map((x) => MsMyOtherStockRes.fromJson(x)));

String msMyOtherStockResToJson(List<MsMyOtherStockRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MsMyOtherStockRes {
  final int? validTicker;
  final String? symbol;
  final String? name;
  final String? image;
  final String? change;
  final num? changesPercentage;

  MsMyOtherStockRes({
    this.validTicker,
    this.symbol,
    this.name,
    this.image,
    this.change,
    this.changesPercentage,
  });

  factory MsMyOtherStockRes.fromJson(Map<String, dynamic> json) =>
      MsMyOtherStockRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "change": change,
        "changesPercentage": changesPercentage,
      };
}
