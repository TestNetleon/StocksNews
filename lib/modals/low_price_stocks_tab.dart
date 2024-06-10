import 'dart:convert';

List<LowPriceStocksTabRes> lowPriceStocksTabResFromJson(String str) =>
    List<LowPriceStocksTabRes>.from(
        json.decode(str).map((x) => LowPriceStocksTabRes.fromJson(x)));

String lowPriceStocksTabResToJson(List<LowPriceStocksTabRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LowPriceStocksTabRes {
  final String key;
  final String value;

  LowPriceStocksTabRes({
    required this.key,
    required this.value,
  });

  factory LowPriceStocksTabRes.fromJson(Map<String, dynamic> json) =>
      LowPriceStocksTabRes(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
