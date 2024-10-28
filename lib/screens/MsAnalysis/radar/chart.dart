import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../modals/msAnalysis/radar_chart.dart';
import '../../../utils/colors.dart';
import 'detail.dart';

class MsRadarChartView extends StatelessWidget {
  final List<MsRadarChartRes>? data;
  const MsRadarChartView({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      // child: fl.RadarChart(
      //   fl.RadarChartData(
      //     radarShape: fl.RadarShape.polygon,
      //     radarTouchData: fl.RadarTouchData(
      //       enabled: false,
      //       touchCallback: (event, response) {
      //         // Utils()
      //         //     .showLog("Direction -> ${event.localPosition?.direction}");
      //         // Utils().showLog("Distance -> ${event.localPosition?.distance}");
      //         // Utils().showLog(
      //         //     "Distance Squared -> ${event.localPosition?.distanceSquared}");
      //         // Utils().showLog("DX -> ${event.localPosition?.dx}");
      //         // Utils().showLog("DY -> ${event.localPosition?.dy}");
      //       },
      //     ),
      //     titlePositionPercentageOffset: 0.05,
      //     getTitle: (index, angle) {
      //       return fl.RadarChartTitle(
      //         text: (data?[index].label?.toUpperCase()) ?? "N/A",
      //         // angle: angle,
      //       );
      //     },
      //     titleTextStyle: styleSansBold(color: ThemeColors.white),
      //     dataSets: [
      //       fl.RadarDataSet(
      //         fillColor: Colors.orange.withOpacity(0.8),
      //         borderColor: Colors.orange,
      //         borderWidth: 3,
      //         entryRadius: 0,
      //         dataEntries: List.generate(
      //           data?.length ?? 0,
      //           (index) {
      //             return fl.RadarEntry(
      //                 value: data?[index].value?.toDouble() ?? 0);
      //           },
      //         ),
      //       ),
      //     ],
      //     radarBackgroundColor: Colors.transparent,
      //     borderData: fl.FlBorderData(show: false),
      //     radarBorderData: const BorderSide(
      //       color: ThemeColors.greyBorder,
      //     ),
      //     tickCount: 4,
      //     tickBorderData: BorderSide(
      //       color: ThemeColors.greyBorder.withOpacity(0.5),
      //       width: 2,
      //       style: BorderStyle.solid,
      //     ),
      //     ticksTextStyle: const TextStyle(color: Colors.transparent),
      //     gridBorderData: BorderSide(
      //       color: ThemeColors.greyBorder.withOpacity(0.5),
      //       width: 2,
      //     ),
      //   ),
      // ),
      child: HighChartsPage(),
    );
  }
}

class HighChartsPage extends StatefulWidget {
  const HighChartsPage({super.key});

  @override
  State<HighChartsPage> createState() => _HighChartsPageState();
}

class _HighChartsPageState extends State<HighChartsPage> {
  WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadFlutterAsset(Images.chartHTML)
      ..addJavaScriptChannel(
        'ChartDataChannel',
        onMessageReceived: (message) {
          try {
            final data = jsonDecode(message.message);
            String clickedName = data['name'];
            String clickedDescription = data['description'];
            num clickedValue = data['value'];

            // Handle the clicked section data
            print(
                'Clicked section: $clickedName with value: $clickedValue with description: $clickedDescription');
            _detailSheet(
              label: clickedName,
              value: "$clickedValue",
              description: clickedDescription,
            );
          } catch (e) {
            print('Error parsing JSON: $e');
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _fetchChartData();
          },
        ),
      );
  }

  Future<void> _fetchChartData() async {
    MSAnalysisProvider provider = context.read<MSAnalysisProvider>();
    List<MsRadarChartRes>? apiData = provider.completeData?.radarChart;

    if (apiData == null) {
      return;
    }

    List<Map<String, dynamic>> chartData = apiData.map((item) {
      return {
        'name': item.label,
        'y': 72,
        'z': item.value,
        'description': item.description ?? 'No Description',
      };
    }).toList();

    _updateChartData(chartData);
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }

  void _updateChartData(List<Map<String, dynamic>> data) {
    String jsonData = jsonEncode(data);
    _controller.runJavaScript('createChart($jsonData)');
  }

  _detailSheet({
    required String label,
    required String value,
    required String description,
  }) async {
    await showModalBottomSheet(
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      backgroundColor: ThemeColors.transparent,
      isScrollControlled: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return RadarChartDetail(
          label: label,
          value: value,
          description: description,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}
