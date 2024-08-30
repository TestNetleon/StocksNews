import 'dart:convert';

MsPriceVolatilityRes msPriceVolatilityResFromJson(String str) =>
    MsPriceVolatilityRes.fromJson(json.decode(str));

String msPriceVolatilityResToJson(MsPriceVolatilityRes data) =>
    json.encode(data.toJson());

class MsPriceVolatilityRes {
  final int? volatility;

  MsPriceVolatilityRes({
    this.volatility,
  });

  factory MsPriceVolatilityRes.fromJson(Map<String, dynamic> json) =>
      MsPriceVolatilityRes(
        volatility: json["volatility"],
      );

  Map<String, dynamic> toJson() => {
        "volatility": volatility,
      };
}
