import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MsMetricsGauge extends StatelessWidget {
  const MsMetricsGauge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                showLabels: false,
                showTicks: false,
                startAngle: 270,
                endAngle: 270,
                axisLineStyle: const AxisLineStyle(
                  thickness: 1,
                  color: Color.fromARGB(255, 60, 209, 30),
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: const <GaugePointer>[
                  RangePointer(
                    value: 25.0,
                    width: 0.15,
                    color: Colors.white,
                    pointerOffset: 0.1,
                    cornerStyle: CornerStyle.bothCurve,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  RangePointer(
                    value: 80.0,
                    width: 0.15,
                    color: Color.fromARGB(255, 243, 243, 243),
                    pointerOffset: 0.1,
                    cornerStyle: CornerStyle.bothCurve,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 60,
            child: Column(
              children: [
                Text('80%', style: stylePTSansBold(fontSize: 25)),
                const SizedBox(
                  height: 3.0,
                ),
                Text(
                  'Satisfaction Index',
                  style: stylePTSansRegular(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
