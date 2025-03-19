import 'dart:convert';

import 'package:stocks_news_new/models/crypto_models/crypto_detail_res.dart';

CryptoFiatRes cryptoFiatResFromMap(String str) => CryptoFiatRes.fromMap(json.decode(str));

String cryptoFiatResToMap(CryptoFiatRes data) => json.encode(data.toMap());

class CryptoFiatRes {
  final ExchangeRates? exchangeRates;
  final CryptoData? cryptoData;

  CryptoFiatRes({
    this.exchangeRates,
    this.cryptoData,
  });

  factory CryptoFiatRes.fromMap(Map<String, dynamic> json) => CryptoFiatRes(
    exchangeRates: json["exchange_rates"] == null ? null : ExchangeRates.fromMap(json["exchange_rates"]),
    cryptoData: json["crypto_data"] == null ? null : CryptoData.fromMap(json["crypto_data"]),
  );

  Map<String, dynamic> toMap() => {
    "exchange_rates": exchangeRates?.toMap(),
    "crypto_data": cryptoData?.toMap(),
  };
}


class ExchangeRates {
  final String? title;
  final List<String>? header;
  final List<ValuesRes>? data;

  ExchangeRates({
    this.title,
    this.header,
    this.data,
  });

  factory ExchangeRates.fromMap(Map<String, dynamic> json) => ExchangeRates(
    title: json["title"],
    header: json["header"] == null ? [] : List<String>.from(json["header"]!.map((x) => x)),
    data: json["data"] == null ? [] : List<ValuesRes>.from(json["data"]!.map((x) => ValuesRes.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "header": header == null ? [] : List<dynamic>.from(header!.map((x) => x)),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class ValuesRes {
  final Info? info;
  final List<String>? data;

  ValuesRes({
    this.info,
    this.data,
  });

  factory ValuesRes.fromMap(Map<String, dynamic> json) => ValuesRes(
    info: json["info"] == null ? null : Info.fromMap(json["info"]),
    data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "info": info?.toMap(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}

class Info {
  final String? symbol;
  final String? name;
  final String? image;

  Info({
    this.symbol,
    this.name,
    this.image,
  });

  factory Info.fromMap(Map<String, dynamic> json) => Info(
    symbol: json["symbol"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "name": name,
    "image": image,
  };
}

