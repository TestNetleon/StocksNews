import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TechnicalAnalysisGaugeItem extends StatelessWidget {
  final double value;
  const TechnicalAnalysisGaugeItem({super.key, this.value = 80});
//
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 180,
          endAngle: 0,
          minimum: -100,
          interval: 20,
          maximum: 100,
          tickOffset: 5,
          canScaleToFit: true,
          majorTickStyle: const MajorTickStyle(color: ThemeColors.divider),
          minorTickStyle: const MinorTickStyle(color: ThemeColors.divider),
          showLabels: false,
          ticksPosition: ElementsPosition.inside,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: -100,
              endValue: -50,
              color: Colors.red,
              startWidth: 7.sp,
              endWidth: 7.sp,
            ),
            GaugeRange(
              startValue: -50,
              endValue: 0,
              color: Colors.orange,
              startWidth: 7.sp,
              endWidth: 7.sp,
            ),
            GaugeRange(
              startValue: 0,
              endValue: 50,
              color: const Color.fromARGB(255, 181, 240, 105),
              startWidth: 7.sp,
              endWidth: 7.sp,
            ),
            GaugeRange(
              startValue: 50,
              endValue: 100,
              color: Colors.green,
              startWidth: 7.sp,
              endWidth: 7.sp,
            )
          ],
          pointers: [
            NeedlePointer(
              value: value, // -100 to max 100
              needleColor: Colors.white,
              needleStartWidth: 0,
              needleEndWidth: 1.sp,
              needleLength: .7.sp,
              // tailStyle: TailStyle(color: Colors.white, length: .1, width: 9),
              knobStyle: KnobStyle(
                knobRadius: .06.sp,
                color: Colors.white,
              ),
            )
          ],
        )
      ],
    );
  }
}
