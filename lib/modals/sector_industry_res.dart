import 'dart:convert';

SectorIndustryRes sectorIndustryResFromJson(String str) =>
    SectorIndustryRes.fromJson(json.decode(str));

String sectorIndustryResToJson(SectorIndustryRes data) =>
    json.encode(data.toJson());

class SectorIndustryRes {
  final num currentPage;
  final List<SectorIndustryData> data;
  final num total;
  final num lastPage;

  SectorIndustryRes({
    required this.currentPage,
    required this.data,
    required this.total,
    required this.lastPage,
  });

  factory SectorIndustryRes.fromJson(Map<String, dynamic> json) =>
      SectorIndustryRes(
        currentPage: json["current_page"],
        data: List<SectorIndustryData>.from(
            json["data"].map((x) => SectorIndustryData.fromJson(x))),
        total: json["total"],
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
        "last_page": lastPage,
      };
}

class SectorIndustryData {
  // final String id;
  final String symbol;
  final String name;
  final String image;
  final String price;
  final num change;
  final num changesPercentage;

  SectorIndustryData({
    // required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.change,
    required this.changesPercentage,
  });

  factory SectorIndustryData.fromJson(Map<String, dynamic> json) =>
      SectorIndustryData(
        // id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
      };
}
