import 'dart:convert';

enum ToolsEnum {
  scanner,
  simulator,
  portfolio,
  compare,
  league,
  market,
  signals,
}

ToolsEnum? toolsEnumFromString(String? value) {
  if (value == null) return null;
  return ToolsEnum.values.firstWhere(
    (e) => e.toString().split('.').last == value,
    orElse: () => ToolsEnum.scanner,
  );
}

String? toolsEnumToString(ToolsEnum? value) {
  return value?.toString().split('.').last;
}

ToolsRes toolsResFromJson(String str) => ToolsRes.fromJson(json.decode(str));
String toolsResToJson(ToolsRes data) => json.encode(data.toJson());

class ToolsRes {
  final PlaidConfigRes? plaidConfig;
  final List<ToolsCardsRes>? tools;
  final bool? status;
  final HomePlaidDataRes? top;

  ToolsRes({
    this.plaidConfig,
    this.tools,
    this.top,
    this.status,
  });

  factory ToolsRes.fromJson(Map<String, dynamic> json) => ToolsRes(
        status: json["status"],
        top:
            json["top"] == null ? null : HomePlaidDataRes.fromJson(json["top"]),
        plaidConfig: json["plaid_config"] == null
            ? null
            : PlaidConfigRes.fromJson(json["plaid_config"]),
        tools: json["tools"] == null
            ? []
            : List<ToolsCardsRes>.from(
                json["tools"]!.map((x) => ToolsCardsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "top": top?.toJson(),
        "plaid_config": plaidConfig?.toJson(),
        "tools": tools == null
            ? []
            : List<dynamic>.from(tools!.map((x) => x.toJson())),
      };
}

class HomePlaidDataRes {
  final String? title;
  final String? subTitle;
  final String? p1;
  final String? p2;
  final String? p3;
  final String? portfolioEarnPoint;

  HomePlaidDataRes({
    this.title,
    this.subTitle,
    this.p1,
    this.p2,
    this.p3,
    this.portfolioEarnPoint,
  });

  factory HomePlaidDataRes.fromJson(Map<String, dynamic> json) =>
      HomePlaidDataRes(
        title: json["title"],
        subTitle: json["sub_title"],
        p1: json["p1"],
        p2: json["p2"],
        p3: json["p3"],
        portfolioEarnPoint: json["portfolio_earn_point"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "p1": p1,
        "p2": p2,
        "p3": p3,
        "portfolio_earn_point": portfolioEarnPoint,
      };
}

class ToolsCardsRes {
  final String? image;
  final String? title;
  final ToolsEnum? slug;
  final String? subTitle;
  final String? buttonText;
  final bool? connected;

  ToolsCardsRes({
    this.image,
    this.title,
    this.slug,
    this.subTitle,
    this.buttonText,
    this.connected,
  });

  factory ToolsCardsRes.fromJson(Map<String, dynamic> json) => ToolsCardsRes(
        image: json["image"],
        title: json["title"],
        slug: toolsEnumFromString(json['slug']),
        subTitle: json["sub_title"],
        buttonText: json["button_text"],
        connected: json['is_connected'],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
        "slug": toolsEnumToString(slug),
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
