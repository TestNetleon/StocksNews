import 'dart:convert';

MsPeerComparisonRes msPeerComparisonResFromJson(String str) =>
    MsPeerComparisonRes.fromJson(json.decode(str));

String msPeerComparisonResToJson(MsPeerComparisonRes data) =>
    json.encode(data.toJson());

class MsPeerComparisonRes {
  final List<String>? headers;
  final List<PeerComparison>? peerComparison;

  MsPeerComparisonRes({
    this.headers,
    this.peerComparison,
  });

  factory MsPeerComparisonRes.fromJson(Map<String, dynamic> json) =>
      MsPeerComparisonRes(
        headers: json["headers"] == null
            ? []
            : List<String>.from(json["headers"]!.map((x) => x)),
        peerComparison: json["peer_comparison"] == null
            ? []
            : List<PeerComparison>.from(json["peer_comparison"]!
                .map((x) => PeerComparison.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "headers":
            headers == null ? [] : List<dynamic>.from(headers!.map((x) => x)),
        "peer_comparison": peerComparison == null
            ? []
            : List<dynamic>.from(peerComparison!.map((x) => x.toJson())),
      };
}

class PeerComparison {
  final String? symbol;
  final String? name;
  final String? image;

  final num? peRatio;
  final num? roe;
  final num? returns;
  final num? salesGrowth;
  final num? profitGrowth;

  PeerComparison({
    this.symbol,
    this.name,
    this.image,
    this.peRatio,
    this.returns,
    this.roe,
    this.salesGrowth,
    this.profitGrowth,
  });

  factory PeerComparison.fromJson(Map<String, dynamic> json) => PeerComparison(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        peRatio: json["pe_ratio"],
        returns: json['returns'],
        roe: json["roe"],
        salesGrowth: json["sales_growth"],
        profitGrowth: json["profit_growth"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        'returns': returns,
        "pe_ratio": peRatio,
        "roe": roe,
        "sales_growth": salesGrowth,
        "profit_growth": profitGrowth,
      };
}
