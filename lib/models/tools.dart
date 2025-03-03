// To parse this JSON data, do
//
//     final toolsRes = toolsResFromJson(jsonString);

import 'dart:convert';

ToolsRes toolsResFromJson(String str) => ToolsRes.fromJson(json.decode(str));

String toolsResToJson(ToolsRes data) => json.encode(data.toJson());

class ToolsRes {
  final ToolsCardsRes? compare;
  final ToolsCardsRes? plaid;
  final PlaidConfigRes? plaidConfig;
  final ToolsCardsRes? scanner;
  final ToolsCardsRes? simulator;
  final ToolsCardsRes? league;
  ToolsRes({
    this.compare,
    this.plaid,
    this.plaidConfig,
    this.scanner,
    this.simulator,
    this.league,
  });

  factory ToolsRes.fromJson(Map<String, dynamic> json) => ToolsRes(
        compare: json["compare"] == null
            ? null
            : ToolsCardsRes.fromJson(json["compare"]),
        plaid: json["plaid"] == null
            ? null
            : ToolsCardsRes.fromJson(json["plaid"]),
        plaidConfig: json["plaid_config"] == null
            ? null
            : PlaidConfigRes.fromJson(json["plaid_config"]),
    scanner: json["scanner"] == null
        ? null
        : ToolsCardsRes.fromJson(json["scanner"]),
    simulator: json["simulator"] == null
        ? null
        : ToolsCardsRes.fromJson(json["simulator"]),
    league: json["league"] == null
        ? null
        : ToolsCardsRes.fromJson(json["league"]),
      );

  Map<String, dynamic> toJson() => {
        "compare": compare?.toJson(),
        "plaid": plaid?.toJson(),
        "plaid_config": plaidConfig?.toJson(),
    "scanner": scanner?.toJson(),
    "simulator":simulator?.toJson(),
    "league": league?.toJson(),
      };
}

class ToolsCardsRes {
  final String? image;
  final String? title;
  final String? subTitle;
  final String? buttonText;
  final bool? connected;

  ToolsCardsRes({
    this.image,
    this.title,
    this.subTitle,
    this.buttonText,
    this.connected,
  });

  factory ToolsCardsRes.fromJson(Map<String, dynamic> json) => ToolsCardsRes(
        image: json["image"],
        title: json["title"],
        subTitle: json["sub_title"],
        buttonText: json["button_text"],
        connected: json['is_connected'],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
        "sub_title": subTitle,
        "button_text": buttonText,
        "is_connected": connected,
      };
}

class PlaidConfigRes {
  final String? clientId;
  final String? secret;
  final String? clientName;
  final List<String>? products;
  final List<String>? countryCodes;
  final String? language;
  final String? androidPackageName;
  final String? createUrl;
  final String? exchangeUrl;

  PlaidConfigRes({
    this.clientId,
    this.secret,
    this.clientName,
    this.products,
    this.countryCodes,
    this.language,
    this.androidPackageName,
    this.createUrl,
    this.exchangeUrl,
  });

  factory PlaidConfigRes.fromJson(Map<String, dynamic> json) => PlaidConfigRes(
        clientId: json["client_id"],
        secret: json["secret"],
        clientName: json["client_name"],
        products: json["products"] == null
            ? []
            : List<String>.from(json["products"]!.map((x) => x)),
        countryCodes: json["country_codes"] == null
            ? []
            : List<String>.from(json["country_codes"]!.map((x) => x)),
        language: json["language"],
        androidPackageName: json["android_package_name"],
        createUrl: json["create_url"],
        exchangeUrl: json["exchange_url"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "secret": secret,
        "client_name": clientName,
        "products":
            products == null ? [] : List<dynamic>.from(products!.map((x) => x)),
        "country_codes": countryCodes == null
            ? []
            : List<dynamic>.from(countryCodes!.map((x) => x)),
        "language": language,
        "android_package_name": androidPackageName,
        "create_url": createUrl,
        "exchange_url": exchangeUrl,
      };
}
