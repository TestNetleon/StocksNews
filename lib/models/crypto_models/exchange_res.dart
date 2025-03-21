
import 'dart:convert';

ExchangeRes exchangeResFromJson(String str) => ExchangeRes.fromMap(json.decode(str));

String exchangeResToJson(ExchangeRes data) => json.encode(data.toMap());

class ExchangeRes {
  final String? title;
  final List<Exchanges>? data;
  final int? totalPages;

  ExchangeRes({
    this.title,
    this.data,
    this.totalPages,
  });

  factory ExchangeRes.fromMap(Map<String, dynamic> json) => ExchangeRes(
    title: json["title"],
    data: json["data"] == null ? [] : List<Exchanges>.from(json["data"]!.map((x) => Exchanges.fromMap(x))),
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "total_pages": totalPages,
  };
}

class Exchanges {
  final String? name;
  final String? type;
  final String? image;
  final String? url;
  final int? trustScore;
  final String? tradeVolume24HBtc;
  final String? volume24H;

  Exchanges({
    this.name,
    this.type,
    this.image,
    this.url,
    this.trustScore,
    this.tradeVolume24HBtc,
    this.volume24H,
  });

  factory Exchanges.fromMap(Map<String, dynamic> json) => Exchanges(
    name: json["name"],
    type: json["type"],
    image: json["image"],
    url: json["url"],
    trustScore: json["trust_score"],
    tradeVolume24HBtc: json["trade_volume_24h_btc"],
    volume24H: json["volume_24h"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "type": type,
    "image": image,
    "url": url,
    "trust_score": trustScore,
    "trade_volume_24h_btc": tradeVolume24HBtc,
    "volume_24h": volume24H,
  };
}
