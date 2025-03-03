// ignore_for_file: equal_keys_in_map

import 'dart:convert';

SDFinancialsRes SDFinancialResFromJson(String str) =>
    SDFinancialsRes.fromJson(json.decode(str));

String SDFinancialResToJson(SDFinancialsRes data) => json.encode(data.toJson());

class SDFinancialsRes {
  final List<FinanceStatement>? financeStatement;

  SDFinancialsRes({
    this.financeStatement,
  });

  factory SDFinancialsRes.fromJson(Map<String, dynamic> json) =>
      SDFinancialsRes(
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
  final dynamic period;
  final dynamic periodEnded;
  final dynamic operatingRevenue;
  final dynamic costOfRevenue;
  final dynamic grossProfit;
  final dynamic grossProfitRatio;
  final dynamic researchAndDevelopmentExpenses;
  final dynamic generalAdministrativeExpenses;
  final dynamic sellingMarketingExpenses;
  final dynamic sellingGeneralAdministrativeExpenses;
  final dynamic otherExpenses;
  final dynamic operatingExpenses;
  final dynamic costAndExpenses;
  final dynamic interestIncome;
  final dynamic interestExpense;
  final dynamic depreciationAmortization;
  final dynamic ebitda;
  final num? ebitdaRatio;
  final dynamic operatingIncome;
  final num? operatingIncomeRatio;
  final dynamic totalOtherIncomeExpensesNet;
  final dynamic incomeBeforeTax;
  final dynamic incomeBeforeTaxRatio;
  final dynamic incomeTaxExpense;
  final dynamic netIncome;
  final dynamic netIncomeRatio;
  final num? eps;
  final num? epsDiluted;
  final dynamic weightedAverageSharesOut;
  final dynamic weightedAverageSharesOutDiluted;
  final dynamic link;
  final dynamic revenue;
  final dynamic totalAssets;
  final dynamic totalLiabilities;
  final dynamic revenueChangePercentage;
  final dynamic totalAssetsChangePercentage;
  final dynamic totalLiabilitiesChangePercentage;
  final dynamic netIncomeChangePercentage;

  final dynamic operatingCashFlow;
  final dynamic investingCashFlow;
  final dynamic financingCashFlow;
  final dynamic operatingCashFlowChangePercentage;
  final dynamic investingCashFlowChangePercentage;
  final dynamic financingCashFlowChangePercentage;
  final dynamic eBITDAChangePercentage;
  final dynamic totalEquity;
  final dynamic totalEquityChangePercentage;
  final dynamic cep;
  final dynamic cashAtBeginningOfPeriod;
  final dynamic investingCashFlowChange;

  final dynamic netIncomePerRatio;
  final dynamic investingPerRatio;

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
    this.revenue,
    this.totalAssets,
    this.totalLiabilities,
    this.revenueChangePercentage,
    this.totalAssetsChangePercentage,
    this.totalLiabilitiesChangePercentage,
    this.netIncomeChangePercentage,
    this.operatingCashFlow,
    this.investingCashFlow,
    this.financingCashFlow,
    this.operatingCashFlowChangePercentage,
    this.investingCashFlowChangePercentage,
    this.financingCashFlowChangePercentage,
    this.eBITDAChangePercentage,
    this.totalEquity,
    this.totalEquityChangePercentage,
    this.cep,
    this.cashAtBeginningOfPeriod,
    this.investingCashFlowChange,
    this.netIncomePerRatio,
    this.investingPerRatio,
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
        revenue: json["Revenue"],
        totalAssets: json["Total Assets"],
        totalLiabilities: json["Total Liabilities"],
        revenueChangePercentage: json["Revenue Change Percentage"],
        totalAssetsChangePercentage: json["Total Assets Change Percentage"],
        totalLiabilitiesChangePercentage:
            json["Total Liabilities Change Percentage"],
        netIncomeChangePercentage: json["Net Income Change Percentage"],
        operatingCashFlow: json["Operating Cash Flow"],
        investingCashFlow: json["Investing Cash Flow"],
        financingCashFlow: json["Financing Cash Flow"],
        operatingCashFlowChangePercentage:
            json["Operating Cash Flow Change Percentage"],
        investingCashFlowChangePercentage:
            json["Investing Cash Flow Change Percentage"],
        financingCashFlowChangePercentage:
            json["Financing Cash Flow Change Percentage"],
        eBITDAChangePercentage: json["EBITDA Change Percentage"],
        totalEquity: json["Total Equity"],
        totalEquityChangePercentage: json["Total Equity Change Percentage"],
        cep: json["Cash at End of Period"],
        cashAtBeginningOfPeriod: json["Cash at Beginning of Period"],
        investingCashFlowChange: json["Investing Cash Flow Change"],
        investingPerRatio: json["Investing Cash Flow Change"],
        netIncomePerRatio: json["Net Income percentage"],
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
        "Revenue": revenue,
        "Total Assets": totalAssets,
        "Total Liabilities": totalLiabilities,
        "Revenue Change Percentage": revenueChangePercentage,
        "Total Assets Change Percentage": totalAssetsChangePercentage,
        "Total Liabilities Change Percentage": totalLiabilitiesChangePercentage,
        "Net Income Change Percentage": netIncomeChangePercentage,
        "Operating Cash Flow": operatingCashFlow,
        "Investing Cash Flow": investingCashFlow,
        "Financing Cash Flow": financingCashFlow,
        "Operating Cash Flow Change Percentage":
            operatingCashFlowChangePercentage,
        "Investing Cash Flow Change Percentage":
            investingCashFlowChangePercentage,
        "Financing Cash Flow Change Percentage":
            financingCashFlowChangePercentage,
        "EBITDA Change Percentage": eBITDAChangePercentage,
        "Total Equity": totalEquity,
        "Total Equity Change Percentage": totalEquityChangePercentage,
        "Cash at End of Period": cep,
        "Cash at Beginning of Period": cashAtBeginningOfPeriod,
        "Investing Cash Flow Change": investingCashFlowChange,
        "Net Income percentage": netIncomePerRatio,
        "Investing Cash Flow Change": investingPerRatio,
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
        "Revenue": revenue,
        "Total Assets": totalAssets,
        "Total Liabilities": totalLiabilities,
        "Revenue Change Percentage": revenueChangePercentage,
        "Total Assets Change Percentage": totalAssetsChangePercentage,
        "Total Liabilities Change Percentage": totalLiabilitiesChangePercentage,
        "Net Income Change Percentage": netIncomeChangePercentage,
        "Operating Cash Flow": operatingCashFlow,
        "Investing Cash Flow": investingCashFlow,
        "Financing Cash Flow": financingCashFlow,
        "Operating Cash Flow Change Percentage":
            operatingCashFlowChangePercentage,
        "Investing Cash Flow Change Percentage":
            investingCashFlowChangePercentage,
        "Financing Cash Flow Change Percentage":
            financingCashFlowChangePercentage,
        "EBITDA Change Percentage": eBITDAChangePercentage,
        "Total Equity": totalEquity,
        "Total Equity Change Percentage": totalEquityChangePercentage,
        "Cash at End of Period": cep,
        "Cash at Beginning of Period": cashAtBeginningOfPeriod,
        "Investing Cash Flow Change": investingCashFlowChange,
        "Net Income percentage": netIncomePerRatio,
        "Investing Per Ratio": investingPerRatio,
      };
}
