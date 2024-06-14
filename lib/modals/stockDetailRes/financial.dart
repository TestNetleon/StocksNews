import 'dart:convert';

SdFinancialRes sdFinancialResFromJson(String str) =>
    SdFinancialRes.fromJson(json.decode(str));

String sdFinancialResToJson(SdFinancialRes data) => json.encode(data.toJson());

class SdFinancialRes {
  final List<String>? period;
  final List<String>? type;
  final List<FinanceStatement>? financeStatement;

  SdFinancialRes({
    this.period,
    this.type,
    this.financeStatement,
  });

  factory SdFinancialRes.fromJson(Map<String, dynamic> json) => SdFinancialRes(
        period: json["period"] == null
            ? []
            : List<String>.from(json["period"]!.map((x) => x)),
        type: json["type"] == null
            ? []
            : List<String>.from(json["type"]!.map((x) => x)),
        financeStatement: json["finance_statement"] == null
            ? []
            : List<FinanceStatement>.from(json["finance_statement"]!
                .map((x) => FinanceStatement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "period":
            period == null ? [] : List<dynamic>.from(period!.map((x) => x)),
        "type": type == null ? [] : List<dynamic>.from(type!.map((x) => x)),
        "finance_statement": financeStatement == null
            ? []
            : List<dynamic>.from(financeStatement!.map((x) => x.toJson())),
      };
}

class FinanceStatement {
  final String? period;
  final String? periodEnded;
  final String? operatingRevenue;
  final String? costOfRevenue;
  final String? grossProfit;
  final double? grossProfitRatio;

  FinanceStatement({
    this.period,
    this.periodEnded,
    this.operatingRevenue,
    this.costOfRevenue,
    this.grossProfit,
    this.grossProfitRatio,
  });

  factory FinanceStatement.fromJson(Map<String, dynamic> json) =>
      FinanceStatement(
        period: json["Period"],
        periodEnded: json["Period Ended"],
        operatingRevenue: json["Operating Revenue"],
        costOfRevenue: json["Cost Of Revenue"],
        grossProfit: json["Gross Profit"],
        grossProfitRatio: json["Gross Profit Ratio"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Period": period,
        "Period Ended": periodEnded,
        "Operating Revenue": operatingRevenue,
        "Cost Of Revenue": costOfRevenue,
        "Gross Profit": grossProfit,
        "Gross Profit Ratio": grossProfitRatio,
      };
}
