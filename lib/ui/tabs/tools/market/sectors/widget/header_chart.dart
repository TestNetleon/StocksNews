import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/sectors/sectors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HeaderChart extends StatefulWidget {
  const HeaderChart({super.key});

  @override
  State<HeaderChart> createState() => _HeaderChartState();
}

class _HeaderChartState extends State<HeaderChart> {
  WebViewController controller = WebViewController();
  @override
  void initState() {
    super.initState();
    _renderData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _renderData() {
    SectorsManager manager = context.read<SectorsManager>();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            Utils().showLog("Error $error");
          },
        ),
      )
      ..loadHtmlString(
          _loadData(dates: manager.dataView?.chart?.dates, values: manager.dataView?.chart?.values));
    setState(() {});
  }

  String _loadData({
    List<String>? dates,
    List<double>? values,
  }) {
    String datesString = dates?.map((date) => "'$date'").join(',') ?? '';

    String valuesString = values?.map((sell) => "'$sell'").join(',') ?? '';

    return '''
    <canvas id="chart"></canvas>
      <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
      <script>
          var values = [$valuesString];

          // Determine column colors based on values
          var colors = values.map(value => value < 0 ? 'rgba(255, 0, 0, 0.7)' : 'rgba(0, 128, 0, 0.7)');

          // Create chart options
          var options = {
              type: 'bar',
        
              data: {
                  labels: [$datesString],
              datasets: [{
                  label: '',
                  data: values,
                  backgroundColor: colors,
                  borderColor: colors,
                  borderWidth: 1
              }]
          },
          options: {
              scales: {
                  x: {
                      grid: {
                          color: '#222' // Set x-axis grid color to white
                      },
                          ticks: {
                              color: 'white', // Set y-axis tick color to white
                          font: {
                              size: 15 // Set font size for y-axis ticks
                          }
                          }
                  },
                  y: {
                      beginAtZero: false,
                          title: {
                          display: false,
                      },
                          ticks: {
                              color: 'white', // Set y-axis tick color to white
                          font: {
                              size: 15 // Set font size for y-axis ticks
                          }

                          }
                  }
              },
              plugins: {
                  title: {
                      display: false,
                  },
                  legend: {
                      display: false
                  },
              }
          }
      };

          var ctx = document.getElementById('chart').getContext('2d');
          new Chart(ctx, options);
      </script>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenWidth / 2,
      width: ScreenUtil().screenWidth,
      child: WebViewWidget(controller: controller),
    );
  }
}