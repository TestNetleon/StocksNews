import 'dart:convert';

import 'package:stocks_news_new/ui/tabs/tools/simulator/models/show_button_res.dart';


List<SearchRes> searchResFromJson(String str) =>
    List<SearchRes>.from(json.decode(str).map((x) => SearchRes.fromJson(x)));

String searchResToJson(List<SearchRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchRes {
  final String symbol;
  final String name;
  final String? image;
  final num? currentPrice;
  final num? change;
  final num? changesPercentage;
   final ShowButtonRes? showButton;
//
  SearchRes({
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.change,
    this.changesPercentage,
     this.showButton,
  });

  factory SearchRes.fromJson(Map<String, dynamic> json) => SearchRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        currentPrice: json['current_price'],
        change: json['change'],
        changesPercentage: json['changesPercentage'],
        showButton: json["show_button"] == null
            ? null
            : ShowButtonRes.fromJson(json["show_button"]),
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        'current_price': currentPrice,
        "change": change,
        "changesPercentage": changesPercentage,
         "show_button": showButton?.toJson(),
      };
}
