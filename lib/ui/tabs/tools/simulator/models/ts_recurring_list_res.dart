import 'dart:convert';

List<TsRecurringListRes> tsRecurringListResFromJson(String str) =>
    List<TsRecurringListRes>.from(
        json.decode(str).map((x) => TsRecurringListRes.fromMap(x)));

String tsRecurringListResFromJsonListResToJson(List<TsRecurringListRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class TsRecurringListRes {
  final int? id;
  final String? symbol;
  num? quantity;
  final String? orderTypeOriginal;
  final String? company;
  final String? image;
  num? currentPrice;
  num? change;
  num? changesPercentage;
  num? averagePrice;
  num? totalInvested;
  num? investedChange;
  num? investedChangePercentage;
  num? todayReturn;
  final String? frequency;
  final String? frequencyString;
  final String? recurringDate;
  final String? recurringStringDate;
  final num? recurringAmount;
  DateTime? createdAt;
  final String? updatedAt;
  num? previousClose;
  num? currentValuation;
  final num? transactionCount;
  final String? statusType;
  final String? statusTypeString;

  TsRecurringListRes({
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
    this.investedChange,
    this.investedChangePercentage,
    this.todayReturn,
    this.frequency,
    this.frequencyString,
    this.recurringDate,
    this.recurringStringDate,
    this.recurringAmount,
    this.createdAt,
    this.updatedAt,
    this.previousClose,
    this.currentValuation,
    this.statusType,
    this.statusTypeString,
    this.transactionCount,
  });

  factory TsRecurringListRes.fromMap(Map<String, dynamic> json) =>
      TsRecurringListRes(
        id: json["id"],
        symbol: json["symbol"],
        quantity: json["quantity"],
        orderTypeOriginal: json["order_type_original"],
        company: json["company"],
        image: json["image"],
        currentPrice: json["currentPrice"],
        change: json["change"]?.toDouble(),
        changesPercentage: json["changesPercentage"],
        averagePrice: json["average_price"],
        totalInvested: json["total_invested"],
        investedChange: json["invested_change"],
        investedChangePercentage: json["invested_change_percentage"],
        todayReturn: json["today_return"],
        frequency: json["frequency"],
        frequencyString: json["frequency_string"],
        recurringDate: json["recurring_date"],
        recurringStringDate: json["recurring_date_string"],
        recurringAmount: json["recurring_amount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        previousClose: json["previous_close"],
        currentValuation: json["current_valuation"],
        statusType: json["status_type"],
        statusTypeString: json["status_type_string"],
        transactionCount: json["transaction_count"],
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
        "invested_change": investedChange,
        "invested_change_percentage": investedChangePercentage,
        "today_return": todayReturn,
        "frequency": frequency,
        "frequency_string": frequencyString,
        "recurring_date": recurringDate,
        "recurring_date_string": recurringStringDate,
        "recurring_amount": recurringAmount,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "previous_close": previousClose,
        "current_valuation": currentValuation,
        "status_type": statusType,
        "status_type_string": statusTypeString,
        "transaction_count": transactionCount,
      };
}
