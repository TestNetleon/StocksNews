class ShowButtonRes {
  final bool? alreadyTraded;
  final String? btn1;
  final String? btn2;
  final String? btn3;
  final num? tradeId;
  final num? orderPrice;
  num? orderChange;
  final String? orderType;

  ShowButtonRes({
    this.alreadyTraded,
    this.btn1,
    this.btn2,
    this.btn3,
    this.tradeId,
    this.orderPrice,
    this.orderChange,
    this.orderType,
  });

  factory ShowButtonRes.fromJson(Map<String, dynamic> json) => ShowButtonRes(
    alreadyTraded: json["already_traded"],
    btn1: json["btn_1"],
    btn2: json["btn_2"],
    btn3: json["btn_3"],
    orderPrice: json['order_price'],
    tradeId: json['trade_id'],
    orderChange: json['order_change'],
    orderType: json['order_type'],
  );

  Map<String, dynamic> toJson() => {
    "already_traded": alreadyTraded,
    "btn_1": btn1,
    "btn_2": btn2,
    "btn_3": btn3,
    'trade_id': tradeId,
    'order_price': orderPrice,
    'order_change': orderChange,
    'order_type': orderType,
  };
}
