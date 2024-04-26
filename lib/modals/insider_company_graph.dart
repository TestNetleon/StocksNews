import 'dart:convert';

InsiderCompanyGraph insiderCompanyGraphFromJson(String str) =>
    InsiderCompanyGraph.fromJson(json.decode(str));

String insiderCompanyGraphToJson(InsiderCompanyGraph data) =>
    json.encode(data.toJson());

class InsiderCompanyGraph {
  final List<String>? chartDates;
  final List<int>? chartPurchase;
  final List<int>? chartSale;

  InsiderCompanyGraph({
    this.chartDates,
    this.chartPurchase,
    this.chartSale,
  });

  factory InsiderCompanyGraph.fromJson(Map<String, dynamic> json) =>
      InsiderCompanyGraph(
        chartDates: json["chart_dates"] == null
            ? []
            : List<String>.from(json["chart_dates"]!.map((x) => x)),
        chartPurchase: json["chart_purchase"] == null
            ? []
            : List<int>.from(json["chart_purchase"]!.map((x) => x)),
        chartSale: json["chart_sale"] == null
            ? []
            : List<int>.from(json["chart_sale"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "chart_dates": chartDates == null
            ? []
            : List<dynamic>.from(chartDates!.map((x) => x)),
        "chart_purchase": chartPurchase == null
            ? []
            : List<dynamic>.from(chartPurchase!.map((x) => x)),
        "chart_sale": chartSale == null
            ? []
            : List<dynamic>.from(chartSale!.map((x) => x)),
      };
}
