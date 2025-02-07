import 'dart:convert';

import '../../tradingSimulator/modals/trading_search_res.dart';

TournamentTickerDetailRes tournamentTickerDetailResFromJson(String str) =>
    TournamentTickerDetailRes.fromJson(json.decode(str));

String tournamentTickerDetailResToJson(TournamentTickerDetailRes data) =>
    json.encode(data.toJson());

class TournamentTickerDetailRes {
  final ShowButtonRes? showButton;
  final TradingSearchTickerRes? ticker;

  TournamentTickerDetailRes({
    this.showButton,
    this.ticker,
  });

  factory TournamentTickerDetailRes.fromJson(Map<String, dynamic> json) =>
      TournamentTickerDetailRes(
        showButton: json["show_button"] == null
            ? null
            : ShowButtonRes.fromJson(json["show_button"]),
        ticker: json["ticker"] == null
            ? null
            : TradingSearchTickerRes.fromJson(json["ticker"]),
      );

  Map<String, dynamic> toJson() => {
        "show_button": showButton?.toJson(),
        "ticker": ticker?.toJson(),
      };
}

class ShowButtonRes {
  final bool? alreadyTraded;
  final String? btn1;
  final String? btn2;
  final String? btn3;
  final num? tradeId;
  final num? orderPrice;
  num? orderChange;
  final String? orderType;

  ShowButtonRes({
    this.alreadyTraded,
    this.btn1,
    this.btn2,
    this.btn3,
    this.tradeId,
    this.orderPrice,
    this.orderChange,
    this.orderType,
  });

  factory ShowButtonRes.fromJson(Map<String, dynamic> json) => ShowButtonRes(
        alreadyTraded: json["already_traded"],
        btn1: json["btn_1"],
        btn2: json["btn_2"],
        btn3: json["btn_3"],
        orderPrice: json['order_price'],
        tradeId: json['trade_id'],
        orderChange: json['order_change'],
        orderType: json['order_type'],
      );

  Map<String, dynamic> toJson() => {
        "already_traded": alreadyTraded,
        "btn_1": btn1,
        "btn_2": btn2,
        "btn_3": btn3,
        'trade_id': tradeId,
        'order_price': orderPrice,
        'order_change': orderChange,
        'order_type': orderType,
      };
}

// class TournamentTickerRes {
//   final String? id;
//   final String? symbol;
//   final String? name;
//   final String? exchange;
//   final String? exchangeShortName;
//   final String? image;
//   final num? price;
//   final num? change;
//   final num? changesPercentage;

//   TournamentTickerRes({
//     this.id,
//     this.symbol,
//     this.name,
//     this.exchange,
//     this.exchangeShortName,
//     this.image,
//     this.price,
//     this.change,
//     this.changesPercentage,
//   });

//   factory TournamentTickerRes.fromJson(Map<String, dynamic> json) =>
//       TournamentTickerRes(
//         id: json["_id"],
//         symbol: json["symbol"],
//         name: json["name"],
//         exchange: json["exchange"],
//         exchangeShortName: json["exchange_short_name"],
//         image: json["image"],
//         price: json["price"],
//         change: json["change"],
//         changesPercentage: json["changesPercentage"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "symbol": symbol,
//         "name": name,
//         "exchange": exchange,
//         "exchange_short_name": exchangeShortName,
//         "image": image,
//         "price": price,
//         "change": change,
//         "changesPercentage": changesPercentage,
//       };
// }
