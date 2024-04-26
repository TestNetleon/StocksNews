// // To parse this JSON data, do
// //
// //     final HomeNewRes = HomeNewResFromJson(jsonString);

// import 'dart:convert';

// import 'home_res.dart';

// HomeNewRes homeNewResFromJson(String str) =>
//     HomeNewRes.fromJson(json.decode(str));

// String homeNewResToJson(HomeNewRes data) => json.encode(data.toJson());

// class HomeNewRes {
//   final List<HomeTrendingData> trending;
//   final List<Top> gainers;
//   final List<Top> losers;

//   HomeNewRes({
//     required this.trending,
//     required this.gainers,
//     required this.losers,
//   });

//   factory HomeNewRes.fromJson(Map<String, dynamic> json) => HomeNewRes(
//         trending: List<HomeTrendingData>.from(
//             json["trending"].map((x) => HomeTrendingData.fromJson(x))),
//         gainers: List<Top>.from(json["gainers"].map((x) => Top.fromJson(x))),
//         losers: List<Top>.from(json["losers"].map((x) => Top.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "trending": List<dynamic>.from(trending.map((x) => x.toJson())),
//         "gainers": List<dynamic>.from(gainers.map((x) => x.toJson())),
//         "losers": List<dynamic>.from(losers.map((x) => x.toJson())),
//       };
// }

// class Top {
//   final String name;
//   final String symbol;
//   final String price;
//   final num changesPercentage;
//   final String image;
//   final bool gained;

//   Top({
//     required this.name,
//     required this.symbol,
//     required this.price,
//     required this.changesPercentage,
//     required this.image,
//     this.gained = false,
//   });

//   factory Top.fromJson(Map<String, dynamic> json) => Top(
//         name: json["name"],
//         symbol: json["symbol"],
//         price: json["price"],
//         changesPercentage: json["changesPercentage"]?.toDouble(),
//         image: json["image"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "symbol": symbol,
//         "price": price,
//         "changesPercentage": changesPercentage,
//         "image": image,
//       };
// }
