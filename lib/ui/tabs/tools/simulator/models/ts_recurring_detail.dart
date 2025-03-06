import 'dart:convert';

RecurringDetailRes recurringDetailResFromMap(String str) => RecurringDetailRes.fromMap(json.decode(str));

String recurringDetailResToMap(RecurringDetailRes data) => json.encode(data.toMap());

class RecurringDetailRes {
  final TradeInfo? tradeInfo;
  final Settlement? settlement;
  final List<Transaction>? transactions;

  RecurringDetailRes({
    this.tradeInfo,
    this.settlement,
    this.transactions,
  });

  factory RecurringDetailRes.fromMap(Map<String, dynamic> json) => RecurringDetailRes(
    tradeInfo: json["trade_info"] == null ? null : TradeInfo.fromMap(json["trade_info"]),
    settlement: json["settlement"] == null ? null : Settlement.fromMap(json["settlement"]),
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "trade_info": tradeInfo?.toMap(),
    "settlement": settlement?.toMap(),
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toMap())),
  };
}

class Settlement {
  final int? id;
  final int? recurringInvestmentId;
  final int? totalQuantity;
  final num? avgPurchasePrice;
  final num? totalInvestedValue;
  final num? salePrice;
  final num? totalSettlementValue;
  final String? settlementDate;
  final String? createdAt;
  final String? updatedAt;

  Settlement({
    this.id,
    this.recurringInvestmentId,
    this.totalQuantity,
    this.avgPurchasePrice,
    this.totalInvestedValue,
    this.salePrice,
    this.totalSettlementValue,
    this.settlementDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Settlement.fromMap(Map<String, dynamic> json) => Settlement(
    id: json["id"],
    recurringInvestmentId: json["recurring_investment_id"],
    totalQuantity: json["total_quantity"],
    avgPurchasePrice: json["avg_purchase_price"],
    totalInvestedValue: json["total_invested_value"],
    salePrice: json["sale_price"],
    totalSettlementValue: json["total_settlement_value"],
    settlementDate: json["settlement_date"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "recurring_investment_id": recurringInvestmentId,
    "total_quantity": totalQuantity,
    "avg_purchase_price": avgPurchasePrice,
    "total_invested_value": totalInvestedValue,
    "sale_price": salePrice,
    "total_settlement_value": totalSettlementValue,
    "settlement_date": settlementDate,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class TradeInfo {
  final int? id;
  final String? symbol;
  final int? quantity;
  final String? orderTypeOriginal;
  final String? company;
  final String? image;
  final num? currentPrice;
  final num? change;
  final num? changesPercentage;
  final num? averagePrice;
  final num? totalInvested;
  final num? currentValuation;
  final String? frequency;
  final String? recurringDate;
  final num? recurringAmount;
  final String? frequencyString;
  final String? createdAt;
  final String? updatedAt;
  final num? previousClose;
  final String? statusType;
  final String? statusTypeString;

  TradeInfo({
    this.id,
    this.symbol,
    this.quantity,
    this.orderTypeOriginal,
    this.company,
    this.image,
    this.currentPrice,
    this.change,
    this.changesPercentage,
    this.averagePrice,
    this.totalInvested,
    this.currentValuation,
    this.frequency,
    this.recurringDate,
    this.recurringAmount,
    this.frequencyString,
    this.createdAt,
    this.updatedAt,
    this.previousClose,
    this.statusType,
    this.statusTypeString,
  });

  factory TradeInfo.fromMap(Map<String, dynamic> json) => TradeInfo(
    id: json["id"],
    symbol: json["symbol"],
    quantity: json["quantity"],
    orderTypeOriginal: json["order_type_original"],
    company: json["company"],
    image: json["image"],
    currentPrice: json["currentPrice"],
    change: json["change"],
    changesPercentage: json["changesPercentage"],
    averagePrice: json["average_price"],
    totalInvested: json["total_invested"],
    currentValuation: json["current_valuation"],
    frequency: json["frequency"],
    recurringDate: json["recurring_date"],
    recurringAmount: json["recurring_amount"],
    frequencyString: json["frequency_string"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    previousClose: json["previous_close"],
    statusType: json["status_type"],
    statusTypeString: json["status_type_string"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "symbol": symbol,
    "quantity": quantity,
    "order_type_original": orderTypeOriginal,
    "company": company,
    "image": image,
    "currentPrice": currentPrice,
    "change": change,
    "changesPercentage": changesPercentage,
    "average_price": averagePrice,
    "total_invested": totalInvested,
    "current_valuation": currentValuation,
    "frequency": frequency,
    "recurring_date": recurringDate,
    "recurring_amount": recurringAmount,
    "frequency_string": frequencyString,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "previous_close": previousClose,
    "status_type": statusType,
    "status_type_string": statusTypeString,
  };
}

class Transaction {
  final int? id;
  final String? symbol;
  final int? quantity;
  final num? recurringAmount;
  final num? stockPrice;
  final num? usedAmount;
  final String? failureReason;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? statusString;

  Transaction({
    this.id,
    this.symbol,
    this.quantity,
    this.recurringAmount,
    this.stockPrice,
    this.usedAmount,
    this.failureReason,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.statusString,
  });

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    symbol: json["symbol"],
    quantity: json["quantity"],
    recurringAmount: json["recurring_amount"],
    stockPrice: json["stock_price"],
    usedAmount: json["used_amount"],
    failureReason: json["failure_reason"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    statusString: json["status_string"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "symbol": symbol,
    "quantity": quantity,
    "recurring_amount": recurringAmount,
    "stock_price": stockPrice,
    "used_amount": usedAmount,
    "failure_reason": failureReason,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "status_string": statusString,
  };
}
