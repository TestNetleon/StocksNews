import 'dart:convert';

List<LiveScannerRes> liveScannerResFromJson(List<dynamic> data) =>
    List<LiveScannerRes>.from(data.map((x) => LiveScannerRes.fromJson(x)));

String liveScannerResToJson(List<LiveScannerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LiveScannerRes {
  final String? identifier;
  final Security? security;
  final String? sector;
  final num? ask;
  final num? bid;
  final num? change;
  final num? percentChange;
  final String? time;
  final int? volume;
  final String? previousCloseDate;
  final num? price;
  final String? extendedHoursDate;
  final String? extendedHoursTime;
  final String? extendedHoursType;
  final num? extendedHoursPrice;
  final num? extendedHoursChange;
  final num? extendedHoursPercentChange;
  final String? date;
  final int? utcOffset;
  final num? open;
  final num? close;
  final num? high;
  final num? low;
  final num? last;
  final int? lastSize;
  final String? volumeDate;
  final num? previousClose;
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

  LiveScannerRes({
    this.price,
    this.image,
    this.extendedHoursDate,
    this.extendedHoursTime,
    this.extendedHoursType,
    this.extendedHoursPrice,
    this.extendedHoursChange,
    this.extendedHoursPercentChange,
    this.date,
    this.time,
    this.utcOffset,
    this.open,
    this.close,
    this.high,
    this.low,
    this.last,
    this.lastSize,
    this.volume,
    this.volumeDate,
    this.previousClose,
    this.security,
    this.previousCloseDate,
    this.change,
    this.percentChange,
    this.bid,
    this.bidSize,
    this.bidDate,
    this.bidTime,
    this.ask,
    this.askSize,
    this.askDate,
    this.askTime,
    this.tradingHalted,
    this.identifier,
    this.identifierType,
    this.outcome,
    this.message,
    this.identity,
    this.sector,
  });

  factory LiveScannerRes.fromJson(Map<String, dynamic> json) => LiveScannerRes(
        price: json['price'],
        security: json["Security"] == null
            ? null
            : Security.fromJson(json["Security"]),
        image: json['image'],
        extendedHoursDate: json["ExtendedHoursDate"],
        extendedHoursTime: json["ExtendedHoursTime"],
        extendedHoursType: json["ExtendedHoursType"],
        extendedHoursPrice: json["ExtendedHoursPrice"],
        extendedHoursChange: json["ExtendedHoursChange"],
        extendedHoursPercentChange: json["ExtendedHoursPercentChange"],
        date: json["Date"],
        time: json["Time"],
        utcOffset: json["UTCOffset"],
        open: json["Open"],
        close: json["Close"],
        high: json["High"],
        low: json["Low"],
        last: json["Last"],
        lastSize: json["LastSize"],
        volume: json["Volume"],
        volumeDate: json["VolumeDate"],
        previousClose: json["PreviousClose"],
        previousCloseDate: json["PreviousCloseDate"],
        change: json["Change"],
        percentChange: json["PercentChange"],
        bid: json["Bid"],
        bidSize: json["BidSize"],
        bidDate: json["BidDate"],
        bidTime: json["BidTime"],
        ask: json["Ask"],
        askSize: json["AskSize"],
        askDate: json["AskDate"],
        askTime: json["AskTime"],
        tradingHalted: json["TradingHalted"],
        identifier: json["Identifier"],
        identifierType: json["IdentifierType"],
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
        "Outcome": outcome,
        "Message": message,
        "Identity": identity,
        "sector": sector,
        "Security": security?.toJson(),
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
