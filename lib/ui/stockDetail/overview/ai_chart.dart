import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../models/stockDetail/overview.dart';
import '../../../utils/colors.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../base/heading.dart';

//MARK: AI Chart
class SDAiChart extends StatefulWidget {
  // final String? title;
  // final List<RadarChartRes>? data;
  final SDAiAnalysisRes? aiAnalysis;

  const SDAiChart({
    super.key,
    // this.data,
    // this.title,
    this.aiAnalysis,
  });

  @override
  State<SDAiChart> createState() => _SDAiChartState();
}

class _SDAiChartState extends State<SDAiChart> {
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

            _detailSheet(
              label: clickedName,
              value: "$clickedValue",
              description: clickedDescription,
            );
          } catch (e) {
            //
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _fetchChartData(apiData: widget.aiAnalysis?.radarChart);
          },
        ),
      );
  }

  Future<void> _fetchChartData({List<RadarChartRes>? apiData}) async {
    if (apiData == null || apiData.isEmpty) {
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
  }) {
    BaseBottomSheet().bottomSheet(
      barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
      child: SDAiChartDetail(
        label: label,
        value: value,
        description: description,
      ),
    );
  }

  final List<Color> colors = [
    Color(0xFFFF5733), // #ff5733
    Color(0xFF33C1FF), // #33c1ff
    Color(0xFFFFEA00), // #ffea00
    Color(0xFF28A745), // #28a745
    Color(0xFFFF8C00), // #ff8c00
    Color(0xFF6F42C1), // #6f42c1
  ];

  @override
  Widget build(BuildContext context) {
    BaseKeyValueRes? recommendation = widget.aiAnalysis?.recommendation;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerVertical(height: Pad.pad24),
          BaseHeading(title: widget.aiAnalysis?.title),
          BaseBorderContainer(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Visibility(
                  visible: recommendation?.value != null &&
                      recommendation?.value != '',
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: ThemeColors.orange10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      recommendation?.value ?? '',
                      style: styleBaseBold(
                        fontSize: 23,
                        color: recommendation?.color?.toLowerCase() == 'orange'
                            ? ThemeColors.orange120
                            : recommendation?.color?.toLowerCase() == 'red'
                                ? ThemeColors.error120
                                : ThemeColors.accent,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: recommendation?.title != null &&
                      recommendation?.title != '',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      recommendation?.title ?? '',
                      style: styleBaseRegular(
                          fontSize: 16, color: ThemeColors.neutral80),
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: WebViewWidget(
                    controller: _controller,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 16,
                    runSpacing: 6,
                    children: List.generate(
                      widget.aiAnalysis?.radarChart?.length ?? 0,
                      (index) {
                        return Container(
                          margin: EdgeInsets.all(3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                  color: colors[index % colors.length],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SpacerHorizontal(width: 8),
                              Flexible(
                                child: Text(
                                  '${widget.aiAnalysis?.radarChart?[index].label}',
                                  style: styleBaseRegular(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//MARK: AI Sheet
class SDAiChartDetail extends StatelessWidget {
  final String label;
  final String value;
  final String description;

  const SDAiChartDetail({
    super.key,
    required this.label,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: styleBaseBold(fontSize: 30),
        ),
        BaseListDivider(),
        SpacerVertical(height: 10),
        HtmlWidget(
          description,
          textStyle: styleBaseRegular(color: ThemeColors.neutral60),
        ),
        SpacerVertical(height: 30),
      ],
    );
  }
}
