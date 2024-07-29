import 'dart:convert';

AnalysisRes analysisResFromJson(String str) =>
    AnalysisRes.fromJson(json.decode(str));

String analysisResToJson(AnalysisRes data) => json.encode(data.toJson());

class AnalysisRes {
  final List<PeersDatum>? peersData;
  final num fundamentalPercent;
  final num shortTermPercent;
  final num longTermPercent;
  final num valuationPercent;
  final num analystRankingPercent;
  final num overallPercent;
  final num setimentPercent;
  final String? text;

  AnalysisRes({
    this.peersData,
    required this.fundamentalPercent,
    required this.shortTermPercent,
    required this.longTermPercent,
    required this.valuationPercent,
    required this.analystRankingPercent,
    required this.overallPercent,
    required this.setimentPercent,
    required this.text,
  });

  factory AnalysisRes.fromJson(Map<String, dynamic> json) => AnalysisRes(
        peersData: json["peers_data"] == null
            ? []
            : List<PeersDatum>.from(
                json["peers_data"]!.map((x) => PeersDatum.fromJson(x))),
        fundamentalPercent: json["fundamental_percent"],
        shortTermPercent: json["short_term_percent"],
        longTermPercent: json["long_term_percent"],
        valuationPercent: json["valuation_percent"],
        analystRankingPercent: json["analyst_ranking_percent"],
        overallPercent: json["overall_percent"]?.toDouble(),
        setimentPercent: json["sentiment_percent"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "peers_data": peersData == null
            ? []
            : List<dynamic>.from(peersData!.map((x) => x.toJson())),
        "fundamental_percent": fundamentalPercent,
        "short_term_percent": shortTermPercent,
        "long_term_percent": longTermPercent,
        "valuation_percent": valuationPercent,
        "analyst_ranking_percent": analystRankingPercent,
        "overall_percent": overallPercent,
        "sentiment_percent": setimentPercent,
        "text": text,
      };
}

class PeersDatum {
  final String symbol;
  final String name;
  final String? image;
  final String price;
  final String change;
  final num changesPercentage;
  num? isAlertAdded;
  num? isWatchlistAdded;

  PeersDatum({
    required this.symbol,
    required this.name,
    this.image,
    required this.price,
    required this.change,
    required this.changesPercentage,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory PeersDatum.fromJson(Map<String, dynamic> json) => PeersDatum(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}
