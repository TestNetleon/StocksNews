import 'dart:convert';

TournamentUserDetailRes tournamentUserDetailResFromMap(String str) => TournamentUserDetailRes.fromMap(json.decode(str));

String tournamentUserDetailResToMap(TournamentUserDetailRes data) => json.encode(data.toMap());

class TournamentUserDetailRes {
  final String? title;
  final UserStats? userStats;
  final List<RecentTradeRes>? recentTrades;
  final List<RecentBattle>? recentBattles;
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
    userStats: json["user_stats"] == null ? null : UserStats.fromMap(json["user_stats"]),
    recentTrades: json["recent_trades"] == null ? [] : List<RecentTradeRes>.from(json["recent_trades"]!.map((x) => RecentTradeRes.fromMap(x))),
    recentBattles: json["recent_battles"] == null ? [] : List<RecentBattle>.from(json["recent_battles"]!.map((x) => RecentBattle.fromMap(x))),
    chart: json["chart"] == null ? null : Chart.fromMap(json["chart"]),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "user_stats": userStats?.toMap(),
    "recent_trades": recentTrades == null ? [] : List<dynamic>.from(recentTrades!.map((x) => x.toMap())),
    "recent_battles": recentBattles == null ? [] : List<dynamic>.from(recentBattles!.map((x) => x.toMap())),
    "chart": chart?.toMap(),
  };
}

class Chart {
  final List<String>? changes;
  final List<DateTime>? dates;

  Chart({
    this.changes,
    this.dates,
  });

  factory Chart.fromMap(Map<String, dynamic> json) => Chart(
    changes: json["changes"] == null ? [] : List<String>.from(json["changes"]!.map((x) => x)),
    dates: json["dates"] == null ? [] : List<DateTime>.from(json["dates"]!.map((x) => DateTime.parse(x))),
  );

  Map<String, dynamic> toMap() => {
    "changes": changes == null ? [] : List<dynamic>.from(changes!.map((x) => x)),
    "dates": dates == null ? [] : List<dynamic>.from(dates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
  };
}

class RecentBattle {
  final int? tournamentId;
  final String? tournamentName;
  final String? imageType;
  final String? image;
  final String? date;
  final int? status;
  final int? position;
  final double? totalChange;
  final int? points;
  final int? rewards;

  RecentBattle({
    this.tournamentId,
    this.tournamentName,
    this.imageType,
    this.image,
    this.date,
    this.status,
    this.position,
    this.totalChange,
    this.points,
    this.rewards,
  });

  factory RecentBattle.fromMap(Map<String, dynamic> json) => RecentBattle(
    tournamentId: json["tournament_id"],
    tournamentName: json["tournament_name"],
    imageType: json["imageType"],
    image: json["image"],
    date: json["date"],
    status: json["status"],
    position: json["position"],
    totalChange: json["total_change"]?.toDouble(),
    points: json["points"],
    rewards: json["rewards"],
  );

  Map<String, dynamic> toMap() => {
    "tournament_id": tournamentId,
    "tournament_name": tournamentName,
    "imageType": imageType,
    "image": image,
    "date": date,
    "status": status,
    "position": position,
    "total_change": totalChange,
    "points": points,
    "rewards": rewards,
  };
}

class RecentTradeRes {
  final int? tournamentId;
  final String? tournamentName;
  final String? imageType;
  final String? image;
  final String? closed;
  final String? type;
  final String? symbol;
  final int? change;

  RecentTradeRes({
    this.tournamentId,
    this.tournamentName,
    this.imageType,
    this.image,
    this.closed,
    this.type,
    this.symbol,
    this.change,
  });

  factory RecentTradeRes.fromMap(Map<String, dynamic> json) => RecentTradeRes(
    tournamentId: json["tournament_id"],
    tournamentName: json["tournament_name"],
    imageType: json["imageType"],
    image: json["image"],
    closed: json["closed"],
    type: json["type"],
    symbol: json["symbol"],
    change: json["change"],
  );

  Map<String, dynamic> toMap() => {
    "tournament_id": tournamentId,
    "tournament_name": tournamentName,
    "imageType": imageType,
    "image": image,
    "closed": closed,
    "type": type,
    "symbol": symbol,
    "change": change,
  };
}

class UserStats {
  final String? userId;
  final String? name;
  final String? image;
  final List<Info>? info;

  UserStats({
    this.userId,
    this.name,
    this.image,
    this.info,
  });

  factory UserStats.fromMap(Map<String, dynamic> json) => UserStats(
    userId: json["user_id"],
    name: json["name"],
    image: json["image"],
    info: json["info"] == null ? [] : List<Info>.from(json["info"]!.map((x) => Info.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "name": name,
    "image": image,
    "info": info == null ? [] : List<dynamic>.from(info!.map((x) => x.toMap())),
  };
}

class Info {
  final String? title;
  final dynamic value;

  Info({
    this.title,
    this.value,
  });

  factory Info.fromMap(Map<String, dynamic> json) => Info(
    title: json["title"],
    value: json["value"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "value": value,
  };
}