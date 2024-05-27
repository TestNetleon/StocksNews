import 'dart:convert';

List<HighLowBetaStocksRes> highLowBetaStocksResFromJson(String str) => List<HighLowBetaStocksRes>.from(json.decode(str).map((x) => HighLowBetaStocksRes.fromJson(x)));

String highLowBetaStocksResToJson(List<HighLowBetaStocksRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HighLowBetaStocksRes {
    final dynamic symbol;
    final dynamic name;
    final dynamic price;
    final dynamic beta;
    final dynamic pe;
    final dynamic marketCap;
    final dynamic volume;
    final dynamic avgVolume;
    final dynamic image;

    HighLowBetaStocksRes({
         this.symbol,
         this.name,
         this.price,
         this.beta,
         this.pe,
         this.marketCap,
         this.volume,
         this.avgVolume,
         this.image,
    });

    factory HighLowBetaStocksRes.fromJson(Map<String, dynamic> json) => HighLowBetaStocksRes(
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        beta: json["beta"],
        pe: json["pe"],
        marketCap: json["marketCap"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "beta": beta,
        "pe": pe,
        "marketCap": marketCap,
        "volume": volume,
        "avgVolume": avgVolume,
        "image": image,
    };
}
