import 'dart:convert';

MyTickers myTickersFromJson(String str) => MyTickers.fromJson(json.decode(str));

String myTickersToJson(MyTickers data) => json.encode(data.toJson());

class MyTickers {
  final List<String>? alerts;
  final List<String>? watchlist;

  MyTickers({
    this.alerts,
    this.watchlist,
  });

  factory MyTickers.fromJson(Map<String, dynamic> json) => MyTickers(
        alerts: json["alerts"] == null
            ? []
            : List<String>.from(json["alerts"]!.map((x) => x)),
        watchlist: json["watchlist"] == null
            ? []
            : List<String>.from(json["watchlist"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "alerts":
            alerts == null ? [] : List<dynamic>.from(alerts!.map((x) => x)),
        "watchlist": watchlist == null
            ? []
            : List<dynamic>.from(watchlist!.map((x) => x)),
      };
}
