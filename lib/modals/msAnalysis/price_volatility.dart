import 'dart:convert';

MsPriceVolatilityRes msPriceVolatilityResFromJson(String str) =>
    MsPriceVolatilityRes.fromJson(json.decode(str));

String msPriceVolatilityResToJson(MsPriceVolatilityRes data) =>
    json.encode(data.toJson());

class MsPriceVolatilityRes {
  final int? volatility;
  final List<String>? keyHighlights;
  MsPriceVolatilityRes({
    this.volatility,
    this.keyHighlights,
  });

  factory MsPriceVolatilityRes.fromJson(Map<String, dynamic> json) =>
      MsPriceVolatilityRes(
        volatility: json["volatility"],
        keyHighlights: json["key_highlights"] == null
            ? []
            : List<String>.from(json["key_highlights"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "volatility": volatility,
        "key_highlights": keyHighlights == null
            ? []
            : List<dynamic>.from(keyHighlights!.map((x) => x)),
      };
}
