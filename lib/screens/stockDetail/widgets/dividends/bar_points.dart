import 'package:collection/collection.dart';

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoint {
  final data = <double>[2, 4, 6, 8, 15, 17, 24];
  return data
      .mapIndexed(
          ((index, element) => PricePoint(x: index.toDouble(), y: element)))
      .toList();
}
