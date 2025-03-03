import 'dart:convert';


List<MarketScannerRes> marketScannerResFromJson(List<dynamic> data) =>
    List<MarketScannerRes>.from(data.map((x) => MarketScannerRes.fromJson(x)));


String marketScannerResToJson(List<MarketScannerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarketScannerRes {
  final String? identifier;
  final Security? security;
  final String? sector;
  final double? ask;
  final double? bid;
  final double? change;
  final double? percentChange;
  final String? time;
  final int? volume;
  final String? previousCloseDate;
  final num? price;
  final String? extendedHoursDate;
  final String? extendedHoursTime;
  final String? extendedHoursType;
  final double? extendedHoursPrice;
  final double? extendedHoursChange;
  final double? extendedHoursPercentChange;
  final String? date;
  final int? utcOffset;
  final double? open;
  final double? close;
  final double? high;
  final double? low;
  final double? last;
  final int? lastSize;
  final String? volumeDate;
  final double? previousClose;
  final int? bidSize;
  final String? bidDate;
  final String? bidTime;
  final int? askSize;
  final String? askDate;
  final String? askTime;
  final bool? tradingHalted;
  final String? identifierType;
  final String? outcome;
  final dynamic message;
  final String? identity;
  final String? image;

  MarketScannerRes({
    this.price,
    this.image,
    required this.extendedHoursDate,
    required this.extendedHoursTime,
    required this.extendedHoursType,
    required this.extendedHoursPrice,
    required this.extendedHoursChange,
    required this.extendedHoursPercentChange,
    required this.date,
    required this.time,
    required this.utcOffset,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
    required this.last,
    required this.lastSize,
    required this.volume,
    required this.volumeDate,
    required this.previousClose,
    required this.previousCloseDate,
    required this.change,
    required this.percentChange,
    required this.bid,
    required this.bidSize,
    required this.bidDate,
    required this.bidTime,
    required this.ask,
    required this.askSize,
    required this.askDate,
    required this.askTime,
    required this.tradingHalted,
    required this.identifier,
    required this.identifierType,
    required this.security,
    required this.outcome,
    required this.message,
    required this.identity,
    required this.sector,
  });

  factory MarketScannerRes.fromJson(Map<String, dynamic> json) =>
      MarketScannerRes(
        price: json['price'],
        image: json['image'],
        extendedHoursDate: json["ExtendedHoursDate"],
        extendedHoursTime: json["ExtendedHoursTime"],
        extendedHoursType: json["ExtendedHoursType"],
        extendedHoursPrice: json["ExtendedHoursPrice"]?.toDouble(),
        extendedHoursChange: json["ExtendedHoursChange"]?.toDouble(),
        extendedHoursPercentChange:
            json["ExtendedHoursPercentChange"]?.toDouble(),
        date: json["Date"],
        time: json["Time"],
        utcOffset: json["UTCOffset"],
        open: json["Open"]?.toDouble(),
        close: json["Close"]?.toDouble(),
        high: json["High"]?.toDouble(),
        low: json["Low"]?.toDouble(),
        last: json["Last"]?.toDouble(),
        lastSize: json["LastSize"],
        volume: json["Volume"],
        volumeDate: json["VolumeDate"],
        previousClose: json["PreviousClose"]?.toDouble(),
        previousCloseDate: json["PreviousCloseDate"],
        change: json["Change"]?.toDouble(),
        percentChange: json["PercentChange"]?.toDouble(),
        bid: json["Bid"]?.toDouble(),
        bidSize: json["BidSize"],
        bidDate: json["BidDate"],
        bidTime: json["BidTime"],
        ask: json["Ask"]?.toDouble(),
        askSize: json["AskSize"],
        askDate: json["AskDate"],
        askTime: json["AskTime"],
        tradingHalted: json["TradingHalted"],
        identifier: json["Identifier"],
        identifierType: json["IdentifierType"],
        security: json["Security"] == null
            ? null
            : Security.fromJson(json["Security"]),
        outcome: json["Outcome"],
        message: json["Message"],
        identity: json["Identity"],
        sector: json["sector"],
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'image': image,
        "ExtendedHoursDate": extendedHoursDate,
        "ExtendedHoursTime": extendedHoursTime,
        "ExtendedHoursType": extendedHoursType,
        "ExtendedHoursPrice": extendedHoursPrice,
        "ExtendedHoursChange": extendedHoursChange,
        "ExtendedHoursPercentChange": extendedHoursPercentChange,
        "Date": date,
        "Time": time,
        "UTCOffset": utcOffset,
        "Open": open,
        "Close": close,
        "High": high,
        "Low": low,
        "Last": last,
        "LastSize": lastSize,
        "Volume": volume,
        "VolumeDate": volumeDate,
        "PreviousClose": previousClose,
        "PreviousCloseDate": previousCloseDate,
        "Change": change,
        "PercentChange": percentChange,
        "Bid": bid,
        "BidSize": bidSize,
        "BidDate": bidDate,
        "BidTime": bidTime,
        "Ask": ask,
        "AskSize": askSize,
        "AskDate": askDate,
        "AskTime": askTime,
        "TradingHalted": tradingHalted,
        "Identifier": identifier,
        "IdentifierType": identifierType,
        "Security": security?.toJson(),
        "Outcome": outcome,
        "Message": message,
        "Identity": identity,
        "sector": sector,
      };
}

class Security {
  final String? cik;
  final dynamic cusip;
  final String? symbol;
  final dynamic isin;
  final String? valoren;
  final String? name;
  final String? market;
  final String? marketIdentificationCode;
  final bool? mostLiquidExchange;
  final String? categoryOrIndustry;

  Security({
    required this.cik,
    required this.cusip,
    required this.symbol,
    required this.isin,
    required this.valoren,
    required this.name,
    required this.market,
    required this.marketIdentificationCode,
    required this.mostLiquidExchange,
    required this.categoryOrIndustry,
  });

  factory Security.fromJson(Map<String, dynamic> json) => Security(
        cik: json["CIK"],
        cusip: json["CUSIP"],
        symbol: json["Symbol"],
        isin: json["ISIN"],
        valoren: json["Valoren"],
        name: json["Name"],
        market: json["Market"],
        marketIdentificationCode: json["MarketIdentificationCode"],
        mostLiquidExchange: json["MostLiquidExchange"],
        categoryOrIndustry: json["CategoryOrIndustry"],
      );

  Map<String, dynamic> toJson() => {
        "CIK": cik,
        "CUSIP": cusip,
        "Symbol": symbol,
        "ISIN": isin,
        "Valoren": valoren,
        "Name": name,
        "Market": market,
        "MarketIdentificationCode": marketIdentificationCode,
        "MostLiquidExchange": mostLiquidExchange,
        "CategoryOrIndustry": categoryOrIndustry,
      };
}
