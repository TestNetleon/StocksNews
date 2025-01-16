import 'dart:convert';

TsStockDetailRes tsStockDetailTabResFromJson(String str) =>
    TsStockDetailRes.fromJson(json.decode(str));

String tsStockDetailTabResToJson(TsStockDetailRes data) =>
    json.encode(data.toJson());

class TsStockDetailRes {
  final String? symbol;
  final String? company;
  final String? exchange;
  final String? image;
  num? currentPrice;
  num? change;
  num? changePercentage;
  final String? marketCap;
  String? marketType;
  String? marketTime;
  bool? executable;

  TsStockDetailRes({
    this.symbol,
    this.company,
    this.exchange,
    this.image,
    this.currentPrice,
    this.change,
    this.changePercentage,
    this.marketCap,
    this.marketType,
    this.marketTime,
    this.executable,
  });

  factory TsStockDetailRes.fromJson(Map<String, dynamic> json) =>
      TsStockDetailRes(
        symbol: json['symbol'],
        company: json['company'],
        exchange: json['exchange'],
        image: json['image'],
        currentPrice: json['current_price'],
        change: json['change'],
        changePercentage: json['change_percentage'],
        marketCap: json['marketCap'],
        marketTime: json['market_time'],
        marketType: json['marketType'],
        executable: json['is_trade_executable'],
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'company': company,
        'exchange': exchange,
        'image': image,
        'current_price': currentPrice,
        'change': change,
        'change_percentage': changePercentage,
        'marketCap': marketCap,
        'market_time': marketTime,
        'marketType': marketType,
        'is_trade_executable': executable,
      };
}
