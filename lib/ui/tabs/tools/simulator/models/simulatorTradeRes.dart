class SimulatorTradeRes {
  String? image, name, price, change;
  num? changePercentage, invested, current, shares;
  DateTime? date;
  bool isBuy;

  SimulatorTradeRes({
    required this.isBuy,
    this.image,
    this.name,
    this.price,
    this.change,
    this.changePercentage,
    this.invested,
    this.current,
    this.shares,
    this.date,
  });
}