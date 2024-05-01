import 'dart:convert';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

// String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  ApiResponse({
    required this.status,
    this.message,
    this.data,
    this.session = true,
    this.totalAmount,
    this.totalCount,
    this.pagecount,
    this.extra,
  });

  final bool status;
  final bool session;
  final dynamic extra;

  final String? message;
  final dynamic data;
  final dynamic totalAmount;
  final dynamic totalCount;
  final dynamic pagecount;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] is List
            ? List<dynamic>.from(json["data"])
            // ? List<dynamic>.from(json["data"].map((x) => dynamic.fromJson(x)))
            : json["data"],
        totalAmount: json['total_amount'],
        totalCount: json['total_count'],
        pagecount: json["page_count"],
        extra: json["extra"] is List
            ? List<dynamic>.from(json["extra"])
            // ? List<dynamic>.from(json["data"].map((x) => dynamic.fromJson(x)))
            : json["extra"] == null
                ? null
                : Extra.fromJson(
                    json["extra"],
                  ),
      );
}

class Extra {
  final String? search;
  final int? notificationCount;
  final List<KeyValueElement>? exchangeShortName;
  final List<KeyValueElement>? priceRange;
  final List<KeyValueElement>? transactionType;
  final List<KeyValueElement>? cap;
  final List<KeyValueElement>? sector;
  final List<KeyValueElement>? txnSize;

  Extra({
    this.search,
    this.exchangeShortName,
    this.priceRange,
    this.transactionType,
    this.cap,
    this.sector,
    this.notificationCount,
    this.txnSize,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        search: json["search"],
        exchangeShortName: json["exchange_short_name"] == null
            ? []
            : List<KeyValueElement>.from(json["exchange_short_name"]!
                .map((x) => KeyValueElement.fromJson(x))),
        priceRange: json["price_range"] == null
            ? []
            : List<KeyValueElement>.from(
                json["price_range"]!.map((x) => KeyValueElement.fromJson(x))),
        transactionType: json["txn_type"] == null
            ? []
            : List<KeyValueElement>.from(
                json["txn_type"]!.map((x) => KeyValueElement.fromJson(x))),
        cap: json["market_cap"] == null
            ? []
            : List<KeyValueElement>.from(
                json["market_cap"]!.map((x) => KeyValueElement.fromJson(x))),
        sector: json["sector"] == null
            ? []
            : List<KeyValueElement>.from(
                json["sector"]!.map((x) => KeyValueElement.fromJson(x))),
        txnSize: json["txn_size"] == null
            ? []
            : List<KeyValueElement>.from(
                json["txn_size"]!.map((x) => KeyValueElement.fromJson(x))),

                notificationCount: json["notification_count"]
      );

  Map<String, dynamic> toJson() => {
        "search": search,
        "exchange_short_name": exchangeShortName == null
            ? []
            : List<dynamic>.from(exchangeShortName!.map((x) => x.toJson())),
        "price_range": priceRange == null
            ? []
            : List<dynamic>.from(priceRange!.map((x) => x.toJson())),
        "txn_type": transactionType == null
            ? []
            : List<dynamic>.from(transactionType!.map((x) => x.toJson())),
        "market_cap":
            cap == null ? [] : List<dynamic>.from(cap!.map((x) => x.toJson())),
        "sector": sector == null
            ? []
            : List<dynamic>.from(sector!.map((x) => x.toJson())),
        "txn_size": txnSize == null
            ? []
            : List<dynamic>.from(txnSize!.map((x) => x.toJson())),
            "notification_count":notificationCount,
      };
}

class KeyValueElement {
  final String? key;
  final String? value;

  KeyValueElement({
    this.key,
    this.value,
  });

  factory KeyValueElement.fromJson(Map<String, dynamic> json) =>
      KeyValueElement(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
