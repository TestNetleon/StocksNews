import 'dart:convert';

InsiderTradingRes insiderTradingResFromJson(String str) =>
    InsiderTradingRes.fromJson(json.decode(str));

String insiderTradingResToJson(InsiderTradingRes data) =>
    json.encode(data.toJson());

class InsiderTradingRes {
  // final num currentPage;
  final List<InsiderTradingData> data;
  final num lastPage;
  final String perPage;
  final num total;
//
  InsiderTradingRes({
    // required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory InsiderTradingRes.fromJson(Map<String, dynamic> json) =>
      InsiderTradingRes(
        // currentPage: json["current_page"],
        data: List<InsiderTradingData>.from(
            json["data"].map((x) => InsiderTradingData.fromJson(x))),
        lastPage: json["last_page"],
        perPage: json["per_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        // "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "last_page": lastPage,
        "per_page": perPage,
        "total": total,
      };
}

class InsiderTradingData {
  // final String id;
  final String symbol;
  // final DateTime transactionDate;
  // final String reportingCik;
  final num securitiesTransacted;
  // final DateTime filingDate;
  final String transactionType;
  final String securitiesOwned;
  // final String companyCik;
  final String reportingName;
  final String reportingSlug;
  final String typeOfOwner;
  // final String acquistionOrDisposition;
  // final String formType;
  final String price;
  // final String securityName;
  final String link;
  // final num change;
  // final String image;
  final String exchangeShortName;
  final String companyName;
  final String companySlug;
  // final String exchange;
  // final DateTime updatedAt;
  // final DateTime createdAt;
  final String totalTransaction;
  final String transactionDateNew;
  // bool isOpen;

  InsiderTradingData({
    // required this.id,
    required this.symbol,
    // required this.transactionDate,
    // required this.reportingCik,
    required this.securitiesTransacted,
    // required this.filingDate,
    required this.transactionType,
    required this.securitiesOwned,
    // required this.companyCik,
    required this.reportingName,
    required this.reportingSlug,
    required this.typeOfOwner,
    // required this.acquistionOrDisposition,
    // required this.formType,
    required this.price,
    // required this.securityName,
    required this.link,
    // required this.change,
    // required this.image,
    required this.exchangeShortName,
    required this.companyName,
    required this.companySlug,
    // required this.exchange,
    // required this.updatedAt,
    // required this.createdAt,
    required this.totalTransaction,
    required this.transactionDateNew,
    // this.isOpen = false,
  });

  factory InsiderTradingData.fromJson(Map<String, dynamic> json) =>
      InsiderTradingData(
        // id: json["_id"],
        symbol: json["symbol"],
        // transactionDate: DateTime.parse(json["transactionDate"]),
        // reportingCik: json["reportingCik"],
        securitiesTransacted: json["securitiesTransacted"],
        // filingDate: DateTime.parse(json["filingDate"]),
        transactionType: json["transactionType"],
        securitiesOwned: json["securitiesOwned"],
        // companyCik: json["companyCik"],
        reportingName: json["reportingName"],
        reportingSlug: json["reportingSlug"],
        typeOfOwner: json["typeOfOwner"],
        // acquistionOrDisposition: json["acquistionOrDisposition"],
        // formType: json["formType"],
        price: json["price"],
        // securityName: json["securityName"],
        link: json["link"],
        // change: json["change"].toDouble(),
        // image: json["image"],
        exchangeShortName: json["exchange_short_name"],
        companyName: json["companyName"],
        companySlug: json["companySlug"],
        // exchange: json["exchange"],
        // updatedAt: DateTime.parse(json["updated_at"]),
        // createdAt: DateTime.parse(json["created_at"]),
        totalTransaction: json["totalTransaction"],
        transactionDateNew: json["transactionDateNew"],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "symbol": symbol,
        // "transactionDate": transactionDate.toIso8601String(),
        // "reportingCik": reportingCik,
        "securitiesTransacted": securitiesTransacted,
        // "filingDate": filingDate.toIso8601String(),
        "transactionType": transactionType,
        "securitiesOwned": securitiesOwned,
        // "companyCik": companyCik,
        "reportingName": reportingName,
        "reportingSlug": reportingSlug,
        "typeOfOwner": typeOfOwner,
        // "acquistionOrDisposition": acquistionOrDisposition,
        // "formType": formType,
        "price": price,
        // "securityName": securityName,
        "link": link,
        // "change": change,
        // "image": image,
        "exchange_short_name": exchangeShortName,
        "companyName": companyName,
        "companySlug": companySlug,
        // "exchange": exchange,
        // "updated_at": updatedAt.toIso8601String(),
        // "created_at": createdAt.toIso8601String(),
        "totalTransaction": totalTransaction,
        "transactionDateNew": transactionDateNew,
      };
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
