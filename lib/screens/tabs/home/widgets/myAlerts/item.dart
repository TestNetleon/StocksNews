import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeMyAlertItem extends StatelessWidget {
  const HomeMyAlertItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        // color: ThemeColors.greyBorder,
        borderRadius: BorderRadius.circular(10.sp),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 23, 23, 23),
            // ThemeColors.greyBorder,
            Color.fromARGB(255, 48, 48, 48),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: ThemeColors.greyBorder,
              ),
              const SpacerHorizontal(width: 8),
              Column(
                children: [
                  Text(
                    "AAPL",
                    style: styleGeorgiaBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "Apple Inc.",
                    style: styleGeorgiaRegular(
                      color: ThemeColors.greyText,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
          Container(
            // color: ThemeColors.greyBorder,
            // height: 200,
            child: SfCartesianChart(
              plotAreaBorderColor: Colors.transparent,
              primaryXAxis: const CategoryAxis(
                isVisible: false,
                // Set the axis line color to transparent
                majorGridLines: MajorGridLines(color: Colors.transparent),
              ),
              primaryYAxis: const NumericAxis(
                isVisible: false,

                // Set the axis line color to transparent
                majorGridLines: MajorGridLines(color: Colors.transparent),
              ), // Chart title
              // Enable legend
              legend: const Legend(isVisible: false),
              // Enable tooltip

              series: <LineSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                  color: ThemeColors.accent,
                  dataSource: <SalesData>[
                    SalesData('Jan', 35),
                    SalesData('Feb', 28),
                    SalesData('Mar', 34),
                    SalesData('Apr', 32),
                    SalesData('May', 40),
                  ],

                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  // Enable data label
                  // dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
