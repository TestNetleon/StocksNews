import 'dart:convert';

import 'package:intl/intl.dart';

TournamentUserDetailRes tournamentUserDetailResFromMap(String str) => TournamentUserDetailRes.fromMap(json.decode(str));

String tournamentUserDetailResToMap(TournamentUserDetailRes data) => json.encode(data.toMap());

class TournamentUserDetailRes {
  final String? title;
  final UserStats? userStats;
  final RecentTrades? recentTrades;
  final RecentBattles? recentBattles;
  final Chart? chart;

  TournamentUserDetailRes({
    this.title,
    this.userStats,
    this.recentTrades,
    this.recentBattles,
    this.chart,
  });

  factory TournamentUserDetailRes.fromMap(Map<String, dynamic> json) => TournamentUserDetailRes(
    title: json["title"],
    userStats: json["user"] == null ? null : UserStats.fromMap(json["user"]),
    recentTrades: json["recent_trades"] == null ? null : RecentTrades.fromMap(json["recent_trades"]),
    recentBattles: json["recent_battles"] == null ? null : RecentBattles.fromMap(json["recent_battles"]),
    chart: json["chart"] == null ? null : Chart.fromMap(json["chart"]),

  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "user": userStats?.toMap(),
    "recent_trades": recentTrades?.toMap(),
    "recent_battles": recentBattles?.toMap(),
    "chart": chart?.toMap(),
  };
}

class Chart {
  final String? title;
  final String? subTitle;
  final List<GChart>? gChart;

  Chart({
    this.title,
    this.subTitle,
    this.gChart,
  });

  factory Chart.fromMap(Map<String, dynamic> json) => Chart(
    title: json["title"],
    subTitle: json["sub_title"],
    gChart: json["data"] == null ? [] : List<GChart>.from(json["data"]!.map((x) => GChart.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "data": gChart == null ? [] : List<dynamic>.from(gChart!.map((x) => x.toMap())),
  };
}

class GChart {
  final num? performance;
  final String? battleDate1;
  final DateTime? battleDate;
  final String? formatPerformance;

  GChart({
    this.performance,
    this.battleDate1,
    this.battleDate,
    this.formatPerformance,
  });

  factory GChart.fromMap(Map<String, dynamic> json) => GChart(
    performance: json["performance"],
    battleDate1: json["battle_date"],
    battleDate: DateFormat("MM/dd/yyyy").parse(json["battle_date"]),
    formatPerformance: json["format_performance"],
  );

  Map<String, dynamic> toMap() => {
    "performance": performance,
    "battle_date": battleDate1,
    "battle_date": battleDate,
    "format_performance": formatPerformance,
  };
}

class RecentBattles {
  final String? title;
  final String? subTitle;
  final bool? status;
  final List<RecentBattlesRes>? data;
  final String? message;

  RecentBattles({
    this.title,
    this.subTitle,
    this.status,
    this.data,
    this.message,
  });

  factory RecentBattles.fromMap(Map<String, dynamic> json) => RecentBattles(
    title: json["title"],
    subTitle: json["sub_title"],
    status: json["status"],
    data: json["data"] == null ? [] : List<RecentBattlesRes>.from(json["data"]!.map((x) => RecentBattlesRes.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "message": message,
  };
}

class RecentBattlesRes {
  final String? tournamentName;
  final String? tournamentImage;
  final String? date;
  final int? status;
  final num? performance;
  final num? points;
  final num? performancePoints;

  RecentBattlesRes({
    this.tournamentName,
    this.tournamentImage,
    this.date,
    this.status,
    this.performance,
    this.points,
    this.performancePoints,
  });

  factory RecentBattlesRes.fromMap(Map<String, dynamic> json) => RecentBattlesRes(
    tournamentName: json["tournament_name"],
    tournamentImage: json["tournament_image"],
    date: json["date"],
    status: json["status"],
    performance: json["performance"],
    points: json["points"],
    performancePoints: json["performance_points"],
  );

  Map<String, dynamic> toMap() => {
    "tournament_name": tournamentName,
    "tournament_image": tournamentImage,
    "date": date,
    "status": status,
    "performance": performance,
    "points": points,
    "performance_points": performancePoints,
  };
}


class RecentTrades {
  final String? title;
  final String? subTitle;
  final String? message;
  final bool? status;
  final List<RecentTradeRes>? dataTrade;

  RecentTrades({
    this.title,
    this.subTitle,
    this.message,
    this.status,
    this.dataTrade,
  });

  factory RecentTrades.fromMap(Map<String, dynamic> json) => RecentTrades(
    title: json["title"],
    subTitle: json["sub_title"],
    message: json["message"],
    status: json["status"],
    dataTrade: json["data"] == null ? [] : List<RecentTradeRes>.from(json["data"]!.map((x) => RecentTradeRes.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "message": message,
    "status": status,
    "data": dataTrade == null ? [] : List<dynamic>.from(dataTrade!.map((x) => x.toMap())),
  };
}
class RecentTradeRes {
  final String? symbol;
  final String? name;
  final String? image;
  final String? type;
  final int? status;
   num? orderPrice;
  num? closePrice;
  num? currentPrice;
  num? gainLoss;
  num? performance;

  RecentTradeRes({
    this.symbol,
    this.name,
    this.image,
    this.type,
    this.status,
    this.orderPrice,
    this.closePrice,
    this.currentPrice,
    this.gainLoss,
    this.performance,

  });

  factory RecentTradeRes.fromMap(Map<String, dynamic> json) => RecentTradeRes(
    symbol: json["symbol"],
    name: json["name"],
    image: json["image"],
    type: json["type"],
    status: json["status"],
    orderPrice: json["order_price"],
    closePrice: json["close_price"],
    currentPrice: json['price'],
    gainLoss: json["gain_loss"],
    performance: json["performance"]?.toDouble(),

  );

  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "name": name,
    "image": image,
    "type":type,
    "status": status,
    "order_price": orderPrice,
    "close_price": closePrice,
    "price": currentPrice,
    "gain_loss": gainLoss,
    "performance": performance,
  };
}

class UserStats {
  final String? userId;
  final String? name;
  final String? image;
  final String? imageType;
  final String? rank;
  final num? performance;
  final String? exp;
  final List<Info>? info;

  UserStats({
    this.userId,
    this.name,
    this.image,
    this.imageType,
    this.rank,
    this.info,
    this.performance,
    this.exp,
  });

  factory UserStats.fromMap(Map<String, dynamic> json) => UserStats(
    userId: json["user_id"],
    name: json["user_name"],
    image: json["user_image"],
    imageType: json["image_type"],
    rank: json["rank"],
    performance: json["performance"],
    exp: json["experience"],
    info: json["info"] == null ? [] : List<Info>.from(json["info"]!.map((x) => Info.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "user_name": name,
    "user_image": image,
    "image_type": imageType,
    "rank": rank,
    "performance": performance,
    "experience": exp,
    "info": info == null ? [] : List<dynamic>.from(info!.map((x) => x.toMap())),
  };
}

class Info {
  final String? title;
  final String? value;
  final String? tooltip;

  Info({
    this.title,
    this.value,
    this.tooltip,
  });

  factory Info.fromMap(Map<String, dynamic> json) => Info(
    title: json["title"],
    value: json["value"],
    tooltip: json["tooltip"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "value": value,
    "tooltip": tooltip,
  };
}