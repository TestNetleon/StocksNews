import 'dart:convert';

List<TsTickerRes> tsTickerResFromJson(String str) => List<TsTickerRes>.from(
    json.decode(str).map((x) => TsTickerRes.fromJson(x)));

String tsTickerResToJson(List<TsTickerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TsTickerRes {
  final num? id;
  final String? symbol;
  final String? image;
  final String? company;
  final num? avgPrice;
  final num? previousClose;
  num? currentPrice;
  num? change;
  num? changesPercentage;
  final num? quantity;
  final num? invested;
  num? currentInvested;
  num? investedChange;
  num? investedChangePercentage;
  final DateTime? createdAt;
  final bool? executable;

  TsTickerRes({
    this.id,
    this.symbol,
    this.image,
    this.company,
    this.avgPrice,
    this.previousClose,
    this.executable,
    this.createdAt,
    this.quantity,
    this.currentPrice,
    this.invested,
    this.currentInvested,
    this.investedChange,
    this.investedChangePercentage,
    this.change,
    this.changesPercentage,
  });

  factory TsTickerRes.fromJson(Map<String, dynamic> json) => TsTickerRes(
        id: json['id'],
        symbol: json["symbol"],
        previousClose: json['previous_close'],
        executable: json['is_trade_executable'],
        avgPrice: json['average_price'],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        quantity: json["quantity"],
        currentPrice: json["currentPrice"],
        invested: json["total_invested"],
        currentInvested: json['current_invested'],
        investedChange: json['invested_change'],
        investedChangePercentage: json['invested_change_percentage'],
        image: json["image"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        "symbol": symbol,
        'previous_close': previousClose,
        'is_trade_executable': executable,
        "quantity": quantity,
        "currentPrice": currentPrice,
        "total_invested": invested,
        "image": image,
        "created_at": createdAt,
        "change": change,
        "changesPercentage": changesPercentage,
        "company": company,
        "average_price": avgPrice,
      };
}
