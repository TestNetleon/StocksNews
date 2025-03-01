import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BaseGaugeItem extends StatelessWidget {
  final num value;
  final double width;
  final double tickOffset;
  final bool canScaleToFit;
  final double startAngle;
  final double endAngle;
  final double minimum;
  final double maximum;
  final double interval;
  final List<GaugeRange> ranges;

  const BaseGaugeItem({
    super.key,
    required this.value,
    this.width = 20,
    this.tickOffset = 1,
    this.canScaleToFit = true,
    this.startAngle = 180,
    this.endAngle = 0,
    this.minimum = -100,
    this.maximum = 100,
    this.interval = 10,
    this.ranges = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: startAngle,
          endAngle: endAngle,
          minimum: minimum,
          maximum: maximum,
          interval: interval,
          tickOffset: tickOffset,
          canScaleToFit: canScaleToFit,
          majorTickStyle: const MajorTickStyle(color: ThemeColors.divider),
          minorTickStyle: const MinorTickStyle(color: ThemeColors.divider),
          showLabels: false,
          ticksPosition: ElementsPosition.inside,
          ranges: ranges.isNotEmpty
              ? ranges
              : [
                  GaugeRange(
                    startValue: -100,
                    endValue: -50,
                    color: ThemeColors.error120,
                    startWidth: width,
                    endWidth: width,
                  ),
                  GaugeRange(
                    startValue: -50,
                    endValue: 0,
                    color: ThemeColors.orange120,
                    startWidth: width,
                    endWidth: width,
                  ),
                  GaugeRange(
                    startValue: 0,
                    endValue: 50,
                    color: ThemeColors.warning120,
                    startWidth: width,
                    endWidth: width,
                  ),
                  GaugeRange(
                    startValue: 50,
                    endValue: 100,
                    color: ThemeColors.success120,
                    startWidth: width,
                    endWidth: width,
                  ),
                ],
          pointers: [
            NeedlePointer(
              value: value.toDouble(),
              needleColor: ThemeColors.black,
              needleStartWidth: 0,
              needleEndWidth: 9,
              needleLength: .7,
              knobStyle: const KnobStyle(
                knobRadius: .06,
                color: ThemeColors.black,
              ),
            )
          ],
        )
      ],
    );
  }
}
