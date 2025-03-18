import 'subscription.dart';

class Layout1Res {
  final String? title;
  final String? btn;
  final bool? showRestore;
  final LayoutDataRes? basic;
  final LayoutDataRes? pro;
  final LayoutDataRes? elite;

  Layout1Res({
    this.title,
    this.btn,
    this.showRestore,
    this.basic,
    this.pro,
    this.elite,
  });

  factory Layout1Res.fromJson(Map<String, dynamic> json) => Layout1Res(
        title: json["title"],
        btn: json["btn"],
        showRestore: json["show_restore"],
        basic: json["Basic"] == null
            ? null
            : LayoutDataRes.fromJson(json["Basic"]),
        pro: json["Pro"] == null ? null : LayoutDataRes.fromJson(json["Pro"]),
        elite: json["Elite"] == null
            ? null
            : LayoutDataRes.fromJson(json["Elite"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "btn": btn,
        "show_restore": showRestore,
        "Basic": basic?.toJson(),
        "Pro": pro?.toJson(),
        "Elite": elite?.toJson(),
      };
}

class LayoutDataRes {
  final List<String>? features;
  List<ProductPlanRes>? data;

  LayoutDataRes({
    this.features,
    this.data,
  });

  factory LayoutDataRes.fromJson(Map<String, dynamic> json) => LayoutDataRes(
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<ProductPlanRes>.from(
                json["data"]!.map((x) => ProductPlanRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
