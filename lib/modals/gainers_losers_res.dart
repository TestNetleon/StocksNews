// To parse this JSON data, do
//
//     final gainersLosersRes = gainersLosersResFromJson(jsonString);

import 'dart:convert';

GainersLosersRes gainersLosersResFromJson(String str) =>
    GainersLosersRes.fromJson(json.decode(str));

String gainersLosersResToJson(GainersLosersRes data) =>
    json.encode(data.toJson());

//
class GainersLosersRes {
  final int currentPage;
  final List<GainersLosersDataRes>? data;
  final int lastPage;

  GainersLosersRes({
    required this.currentPage,
    this.data,
    required this.lastPage,
  });

  factory GainersLosersRes.fromJson(Map<String, dynamic> json) =>
      GainersLosersRes(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<GainersLosersDataRes>.from(
                json["data"]!.map((x) => GainersLosersDataRes.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class GainersLosersDataRes {
  final String symbol;
  final String name;
  final String? price;
  final num? changesPercentage;
  final String? range;
  final String? volume;
  final String? avgVolume;
  final String? previousClose;
  final String? image;

  GainersLosersDataRes({
    required this.symbol,
    required this.name,
    this.price,
    this.changesPercentage,
    this.volume,
    this.avgVolume,
    this.previousClose,
    this.image,
    this.range,
  });

  factory GainersLosersDataRes.fromJson(Map<String, dynamic> json) =>
      GainersLosersDataRes(
          symbol: json["symbol"],
          name: json["name"],
          price: json["price"],
          changesPercentage: json["changesPercentage"],
          volume: json["volume"],
          avgVolume: json["avgVolume"],
          previousClose: json["previousClose"],
          image: json["image"],
          range: json["range"]);

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "changesPercentage": changesPercentage,
        "volume": volume,
        "avgVolume": avgVolume,
        "previousClose": previousClose,
        "image": image,
        "range": range,
      };
}

HighLowPERes highLowPEResFromJson(String str) =>
    HighLowPERes.fromJson(json.decode(str));

String highLowPEResToJson(HighLowPERes data) => json.encode(data.toJson());

//
class HighLowPERes {
  final int currentPage;
  final List<HighLowPeDataRes>? data;
  final int lastPage;

  HighLowPERes({
    required this.currentPage,
    this.data,
    required this.lastPage,
  });

  factory HighLowPERes.fromJson(Map<String, dynamic> json) => HighLowPERes(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<HighLowPeDataRes>.from(
                json["data"]!.map((x) => HighLowPeDataRes.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class HighLowPeDataRes {
  final String symbol;
  final String name;
  final String? price;
  final num? changesPercentage;
  final dynamic range;
  final dynamic volume;
  final dynamic avgVolume;
  final dynamic previousClose;
  final dynamic image;

  HighLowPeDataRes({
    required this.symbol,
    required this.name,
    this.price,
    this.changesPercentage,
    this.volume,
    this.avgVolume,
    this.previousClose,
    this.image,
    this.range,
  });

  factory HighLowPeDataRes.fromJson(Map<String, dynamic> json) =>
      HighLowPeDataRes(
          symbol: json["symbol"],
          name: json["name"],
          price: json["price"],
          changesPercentage: json["changesPercentage"],
          volume: json["volume"],
          avgVolume: json["avgVolume"],
          previousClose: json["previousClose"],
          image: json["image"],
          range: json["range"]);

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "changesPercentage": changesPercentage,
        "volume": volume,
        "avgVolume": avgVolume,
        "previousClose": previousClose,
        "image": image,
        "range": range,
      };
}
