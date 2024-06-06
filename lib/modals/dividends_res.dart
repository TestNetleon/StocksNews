import 'dart:convert';

List<DividendsRes> dividendsResFromJson(String str) => List<DividendsRes>.from(
    json.decode(str).map((x) => DividendsRes.fromJson(x)));

String dividendsResToJson(List<DividendsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DividendsRes {
  final dynamic symbol;
  final dynamic name;
  final dynamic exchangeShortName;
  final dynamic price;
  final dynamic dividend;
  final dynamic adjDividend;
  final dynamic change;
  final dynamic date;
  final dynamic paymentDate;
  final dynamic recordDate;
  final dynamic declarationDate;
  final dynamic image;

  DividendsRes({
    this.symbol,
    this.name,
    this.exchangeShortName,
    this.price,
    this.dividend,
    this.adjDividend,
    this.change,
    this.date,
    this.paymentDate,
    this.recordDate,
    this.declarationDate,
    this.image,
  });

  factory DividendsRes.fromJson(Map<String, dynamic> json) => DividendsRes(
        symbol: json["symbol"],
        name: json["name"],
        exchangeShortName: json["exchange_short_name"],
        price: json["price"],
        dividend: json["dividend"],
        adjDividend: json["adjDividend"],
        change: json["change"],
        date: json["date"],
        paymentDate: json["paymentDate"],
        recordDate: json["recordDate"],
        declarationDate: json["declarationDate"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "exchange_short_name": exchangeShortName,
        "price": price,
        "dividend": dividend,
        "adjDividend": adjDividend,
        "change": change,
        "date": date,
        "paymentDate": paymentDate,
        "recordDate": recordDate,
        "declarationDate": declarationDate,
        "image": image,
      };
}
