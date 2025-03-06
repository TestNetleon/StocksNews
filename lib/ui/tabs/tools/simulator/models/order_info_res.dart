import 'dart:convert';
OrderInfoRes orderInfoResFromMap(String str) => OrderInfoRes.fromMap(json.decode(str));

String orderInfoResToMap(OrderInfoRes data) => json.encode(data.toMap());

class OrderInfoRes {
  final String? html;

  OrderInfoRes({
    this.html,
  });

  factory OrderInfoRes.fromMap(Map<String, dynamic> json) => OrderInfoRes(
    html: json["html"],
  );

  Map<String, dynamic> toMap() => {
    "html": html,
  };
}
