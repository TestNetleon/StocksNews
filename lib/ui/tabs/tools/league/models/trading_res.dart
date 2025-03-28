import 'dart:convert';

List<TradingRes> leaderboardByDateResFromJson(String str) =>
    List<TradingRes>.from(
        json.decode(str).map((x) => TradingRes.fromJson(x)));

class TradingRes {
  final num? tournamentID;
  final String? tournamentName;
  final String? tournamentImage;
  final num? userId;
  final num? battleId;
  final String? userName;
  final String? userImage;
  final num? totalChange;
  final String? imageType;
  final num? position;
  final num? level;
  final num? totalPoints;
  final String? rank;
  final num? status;
  final String? date;
  final num? rewards;
  final num? joinUsers;
  final num? performance;
  final num? performancePoint;
  final num? totalTrades;
  final num? winRatio;


  TradingRes({
    this.userId,
    this.battleId,
    this.userName,
    this.userImage,
    this.totalChange,
    this.position,
    this.level,
    this.totalPoints,
    this.rank,
    this.date,
    this.imageType,
    this.rewards,
    this.status,
    this.tournamentID,
    this.tournamentName,
    this.tournamentImage,
    this.joinUsers,
    this.performance,
    this.performancePoint,
    this.totalTrades,
    this.winRatio,
  });

  factory TradingRes.fromJson(Map<String, dynamic> json) => TradingRes(
    imageType: json['image_type'],
    rank: json['rank'],
    userId: json["user_id"],
    battleId: json["battle_id"],
    userName: json["user_name"],
    userImage: json["user_image"],
    totalChange: json["total_change"],
    level: json['level'],
    position: json['position'],
    totalPoints: json['total_points'],
    date: json['date'],
    rewards: json['rewards'],
    status: json['status'],
    tournamentID: json['tournament_id'],
    tournamentImage: json['tournament_image'],
    tournamentName: json['tournament_name'],
    joinUsers: json['join_users'],
    performance: json['performance'],
    performancePoint: json['performance_point'],
    totalTrades: json['total_trades'],
    winRatio: json['win_ratio'],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "battle_id": battleId,
    "name": userName,
    'rank': rank,
    "image": userImage,
    "image_type": imageType,
    "total_change": totalChange,
    'level': level,
    'position': position,
    'total_points': totalPoints,
    'date': date,
    'rewards': rewards,
    'status': status,
    'tournament_id': tournamentID,
    'tournament_image': tournamentImage,
    'tournament_name': tournamentName,
    'join_users': joinUsers,
    'performance': performance,
    'performance_point': performancePoint,
    'total_trades': totalTrades,
    'win_ratio': winRatio,
  };
}