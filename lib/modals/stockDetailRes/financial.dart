import 'dart:convert';

SdFinancialRes sdFinancialResFromJson(String str) =>
    SdFinancialRes.fromJson(json.decode(str));

String sdFinancialResToJson(SdFinancialRes data) => json.encode(data.toJson());

class SdFinancialRes {
  final List<FinanceStatement>? financeStatement;

  SdFinancialRes({
    this.financeStatement,
  });

  factory SdFinancialRes.fromJson(Map<String, dynamic> json) => SdFinancialRes(
        financeStatement: json["finance_statement"] == null
            ? []
            : List<FinanceStatement>.from(json["finance_statement"]!
                .map((x) => FinanceStatement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
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
  final num? grossProfitRatio;
  final String? researchAndDevelopmentExpenses;
  final String? generalAdministrativeExpenses;
  final String? sellingMarketingExpenses;
  final String? sellingGeneralAdministrativeExpenses;
  final String? otherExpenses;
  final String? operatingExpenses;
  final String? costAndExpenses;
  final String? interestIncome;
  final String? interestExpense;
  final String? depreciationAmortization;
  final String? ebitda;
  final double? ebitdaRatio;
  final String? operatingIncome;
  final num? operatingIncomeRatio;
  final String? totalOtherIncomeExpensesNet;
  final String? incomeBeforeTax;
  final String? incomeBeforeTaxRatio;
  final String? incomeTaxExpense;
  final String? netIncome;
  final String? netIncomeRatio;
  final num? eps;
  final num? epsDiluted;
  final String? weightedAverageSharesOut;
  final String? weightedAverageSharesOutDiluted;
  final String? link;

  FinanceStatement({
    this.period,
    this.periodEnded,
    this.operatingRevenue,
    this.costOfRevenue,
    this.grossProfit,
    this.grossProfitRatio,
    this.researchAndDevelopmentExpenses,
    this.generalAdministrativeExpenses,
    this.sellingMarketingExpenses,
    this.sellingGeneralAdministrativeExpenses,
    this.otherExpenses,
    this.operatingExpenses,
    this.costAndExpenses,
    this.interestIncome,
    this.interestExpense,
    this.depreciationAmortization,
    this.ebitda,
    this.ebitdaRatio,
    this.operatingIncome,
    this.operatingIncomeRatio,
    this.totalOtherIncomeExpensesNet,
    this.incomeBeforeTax,
    this.incomeBeforeTaxRatio,
    this.incomeTaxExpense,
    this.netIncome,
    this.netIncomeRatio,
    this.eps,
    this.epsDiluted,
    this.weightedAverageSharesOut,
    this.weightedAverageSharesOutDiluted,
    this.link,
  });

  factory FinanceStatement.fromJson(Map<String, dynamic> json) =>
      FinanceStatement(
        period: json["Period"],
        periodEnded: json["Period Ended"],
        operatingRevenue: json["Operating Revenue"],
        costOfRevenue: json["Cost Of Revenue"],
        grossProfit: json["Gross Profit"],
        grossProfitRatio: json["Gross Profit Ratio"],
        researchAndDevelopmentExpenses:
            json["Research and Development Expenses"],
        generalAdministrativeExpenses:
            json["General & Administrative Expenses"],
        sellingMarketingExpenses: json["Selling & Marketing Expenses"],
        sellingGeneralAdministrativeExpenses:
            json["Selling, General & Administrative Expenses"],
        otherExpenses: json["Other Expenses"],
        operatingExpenses: json["Operating Expenses"],
        costAndExpenses: json["Cost And Expenses"],
        interestIncome: json["Interest Income"],
        interestExpense: json["Interest Expense"],
        depreciationAmortization: json["Depreciation & Amortization"],
        ebitda: json["EBITDA"],
        ebitdaRatio: json["EBITDA Ratio"],
        operatingIncome: json["Operating Income"],
        operatingIncomeRatio: json["Operating Income Ratio"],
        totalOtherIncomeExpensesNet: json["Total Other Income/Expenses Net"],
        incomeBeforeTax: json["Income Before Tax"],
        incomeBeforeTaxRatio: json["Income Before Tax Ratio"],
        incomeTaxExpense: json["Income Tax Expense"],
        netIncome: json["Net Income"],
        netIncomeRatio: json["Net Income Ratio"],
        eps: json["EPS"],
        epsDiluted: json["EPS Diluted"],
        weightedAverageSharesOut: json["Weighted Average Shares Out"],
        weightedAverageSharesOutDiluted:
            json["Weighted Average Shares Out Diluted"],
        link: json["Link"],
      );

  Map<String, dynamic> toJson() => {
        "Period": period,
        "Period Ended": periodEnded,
        "Operating Revenue": operatingRevenue,
        "Cost Of Revenue": costOfRevenue,
        "Gross Profit": grossProfit,
        "Gross Profit Ratio": grossProfitRatio,
        "Research and Development Expenses": researchAndDevelopmentExpenses,
        "General & Administrative Expenses": generalAdministrativeExpenses,
        "Selling & Marketing Expenses": sellingMarketingExpenses,
        "Selling, General & Administrative Expenses":
            sellingGeneralAdministrativeExpenses,
        "Other Expenses": otherExpenses,
        "Operating Expenses": operatingExpenses,
        "Cost And Expenses": costAndExpenses,
        "Interest Income": interestIncome,
        "Interest Expense": interestExpense,
        "Depreciation & Amortization": depreciationAmortization,
        "EBITDA": ebitda,
        "EBITDA Ratio": ebitdaRatio,
        "Operating Income": operatingIncome,
        "Operating Income Ratio": operatingIncomeRatio,
        "Total Other Income/Expenses Net": totalOtherIncomeExpensesNet,
        "Income Before Tax": incomeBeforeTax,
        "Income Before Tax Ratio": incomeBeforeTaxRatio,
        "Income Tax Expense": incomeTaxExpense,
        "Net Income": netIncome,
        "Net Income Ratio": netIncomeRatio,
        "EPS": eps,
        "EPS Diluted": epsDiluted,
        "Weighted Average Shares Out": weightedAverageSharesOut,
        "Weighted Average Shares Out Diluted": weightedAverageSharesOutDiluted,
        "Link": link,
      };
  Map<String, dynamic> toMap() => {
        "Period": period,
        "Period Ended": periodEnded,
        "Operating Revenue": operatingRevenue,
        "Cost Of Revenue": costOfRevenue,
        "Gross Profit": grossProfit,
        "Gross Profit Ratio": grossProfitRatio,
        "Research and Development Expenses": researchAndDevelopmentExpenses,
        "General & Administrative Expenses": generalAdministrativeExpenses,
        "Selling & Marketing Expenses": sellingMarketingExpenses,
        "Selling, General & Administrative Expenses":
            sellingGeneralAdministrativeExpenses,
        "Other Expenses": otherExpenses,
        "Operating Expenses": operatingExpenses,
        "Cost And Expenses": costAndExpenses,
        "Interest Income": interestIncome,
        "Interest Expense": interestExpense,
        "Depreciation & Amortization": depreciationAmortization,
        "EBITDA": ebitda,
        "EBITDA Ratio": ebitdaRatio,
        "Operating Income": operatingIncome,
        "Operating Income Ratio": operatingIncomeRatio,
        "Total Other Income/Expenses Net": totalOtherIncomeExpensesNet,
        "Income Before Tax": incomeBeforeTax,
        "Income Before Tax Ratio": incomeBeforeTaxRatio,
        "Income Tax Expense": incomeTaxExpense,
        "Net Income": netIncome,
        "Net Income Ratio": netIncomeRatio,
        "EPS": eps,
        "EPS Diluted": epsDiluted,
        "Weighted Average Shares Out": weightedAverageSharesOut,
        "Weighted Average Shares Out Diluted": weightedAverageSharesOutDiluted,
        "Link": link,
      };
}
