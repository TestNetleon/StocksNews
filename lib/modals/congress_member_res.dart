import 'dart:convert';

CongressMemberRes congressMemberResFromJson(String str) =>
    CongressMemberRes.fromJson(json.decode(str));

String congressMemberResToJson(CongressMemberRes data) =>
    json.encode(data.toJson());

class CongressMemberRes {
  final Profile profile;
  final List<TradeList> tradeLists;

  CongressMemberRes({
    required this.profile,
    required this.tradeLists,
  });

  factory CongressMemberRes.fromJson(Map<String, dynamic> json) =>
      CongressMemberRes(
        profile: Profile.fromJson(json["profile"]),
        tradeLists: List<TradeList>.from(
            json["trade_lists"].map((x) => TradeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile.toJson(),
        "trade_lists": List<dynamic>.from(tradeLists.map((x) => x.toJson())),
      };
}

class Profile {
  final dynamic name;
  final dynamic memberType;
  final dynamic office;
  final dynamic userImage;
  final dynamic description;
  final dynamic tradeCount;
  final dynamic companyCount;
  final dynamic volume;

  Profile({
    required this.name,
    required this.memberType,
    required this.office,
    required this.userImage,
    required this.description,
    required this.tradeCount,
    required this.companyCount,
    required this.volume,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        name: json["name"],
        memberType: json["member_type"],
        office: json["office"],
        userImage: json["user_image"],
        description: json["description"],
        tradeCount: json["trade_count"],
        companyCount: json["company_count"],
        volume: json["volume"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "member_type": memberType,
        "office": office,
        "user_image": userImage,
        "description": description,
        "trade_count": tradeCount,
        "company_count": companyCount,
        "volume": volume,
      };
}

class TradeList {
  final dynamic symbol;
  final dynamic company;
  final dynamic currentPrice;
  final dynamic type;
  final dynamic change;
  final dynamic changesPercentage;
  final dynamic amount;
  final dynamic dateFiled;
  final dynamic dateTraded;
  final dynamic image;
  num? isAlertAdded;
  num? isWatchlistAdded;

  TradeList({
    required this.symbol,
    required this.company,
    required this.currentPrice,
    required this.type,
    required this.change,
    required this.changesPercentage,
    required this.amount,
    required this.dateFiled,
    required this.dateTraded,
    required this.image,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory TradeList.fromJson(Map<String, dynamic> json) => TradeList(
        symbol: json["symbol"],
        company: json["company"],
        currentPrice: json["current_price"],
        type: json["type"],
        change: json["change"],
        changesPercentage: json["changesPercentage"]?.toDouble(),
        amount: json["amount"],
        dateFiled: json["date_filed"],
        dateTraded: json["date_traded"],
        image: json["image"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "company": company,
        "current_price": currentPrice,
        "type": type,
        "change": change,
        "changesPercentage": changesPercentage,
        "amount": amount,
        "date_filed": dateFiled,
        "date_traded": dateTraded,
        "image": image,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}
