import 'dart:convert';

StreamRes streamResFromJson(String str) => StreamRes.fromJson(json.decode(str));

String streamResToJson(StreamRes data) => json.encode(data.toJson());

class StreamRes {
  final StreamKetsDataRes? liveKeys;
  final StreamKetsDataRes? closeKeys;

  StreamRes({
    this.liveKeys,
    this.closeKeys,
  });

  factory StreamRes.fromJson(Map<String, dynamic> json) => StreamRes(
        liveKeys: json["live_keys"] == null
            ? null
            : StreamKetsDataRes.fromJson(json["live_keys"]),
        closeKeys: json["close_keys"] == null
            ? null
            : StreamKetsDataRes.fromJson(json["close_keys"]),
      );

  Map<String, dynamic> toJson() => {
        "live_keys": liveKeys?.toJson(),
        "close_keys": closeKeys?.toJson(),
      };
}

class StreamKetsDataRes {
  final String? price;
  final String? change;
  final String? changePercentage;
  final String? type;
  final String? previousClose;
  final String? symbol;
  final String? time;

  StreamKetsDataRes({
    this.price,
    this.change,
    this.changePercentage,
    this.type,
    this.previousClose,
    this.symbol,
    this.time,
  });

  factory StreamKetsDataRes.fromJson(Map<String, dynamic> json) =>
      StreamKetsDataRes(
        price: json["price"],
        change: json["change"],
        changePercentage: json["changePercentage"],
        type: json["type"],
        previousClose: json["previousClose"],
        symbol: json["symbol"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "change": change,
        "changePercentage": changePercentage,
        "type": type,
        "previousClose": previousClose,
        "symbol": symbol,
        "time": time,
      };
}
