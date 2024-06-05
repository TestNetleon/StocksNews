import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/insider_trading_company_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InsiderDetailGraph extends StatefulWidget {
  final bool isCompany;
  const InsiderDetailGraph({super.key, this.isCompany = true});

  @override
  State<InsiderDetailGraph> createState() => _InsiderDetailGraphState();
}

//
class _InsiderDetailGraphState extends State<InsiderDetailGraph> {
  WebViewController controller = WebViewController();
  @override
  void initState() {
    super.initState();
    _renderData();
  }

  void _renderData() {
    InsiderTradingDetailsProvider provider =
        context.read<InsiderTradingDetailsProvider>();
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
      ..loadHtmlString(widget.isCompany
          ? _loadData(
              chartDates: provider.chartDates,
              chartPurchase: provider.chartPurchase,
              chartSale: provider.chartSale,
            )
          : _loadDataInsider(
              chartDatesInsider: provider.chartDatesInsider,
              chartPurchaseInsider: provider.chartPurchaseInsider,
              chartSaleInsider: provider.chartSaleInsider,
            ));
  }

  String _loadData({
    List<String>? chartDates,
    List<int>? chartPurchase,
    List<int>? chartSale,
  }) {
    String categoriesString =
        chartDates?.map((date) => "'$date'").join(',') ?? '';

    String purchaseString =
        chartPurchase?.map((purchase) => "'$purchase'").join(',') ?? '';

    String sellString = chartSale?.map((sell) => "'$sell'").join(',') ?? '';

    double fontSize = isPhone ? 20 : 15;

    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    </style>
      </head>
      <body>
    <div id="chart" style="height: 500px; font-size: 16px;"></div>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script>
    var height = "500";
    var options = {
    legend: {
        fontSize: '20px',
    },
        series: [{
          name: 'Purchase',
          data: [$purchaseString]
        }, {
          name: 'Sell',
          data: [$sellString]
        }],
        chart: {
          height: height,
          type: 'area',
          zoom: {
              enabled: false
          },
          toolbar: {
              show: false
          }
        },
        dataLabels: {
          enabled: false
        },
        stroke: {
          curve: 'smooth'
        },
        xaxis: {
          type: 'date',
          categories: [$categoriesString],
          labels: {
            style: {
              fontSize: '${fontSize}px' 
            }
          }
        },
        tooltip: {
          x: {
            format: 'MM/dd/yy',
          },
          style: {
            fontSize: '20px'  
          }
        },
        colors: ['green', 'red'],
        theme: {
          mode: 'dark',
          palette: 'palette7', 
        },
    };

    var chart = new ApexCharts(document.querySelector("#chart"), options);
    chart.render();
</script>
      </body>
      </html>
    ''';
  }

  String _loadDataInsider({
    List<String>? chartDatesInsider,
    List<int>? chartPurchaseInsider,
    List<int>? chartSaleInsider,
  }) {
    String categoriesString =
        chartDatesInsider?.map((date) => "'$date'").join(',') ?? '';

    String purchaseString =
        chartPurchaseInsider?.map((purchase) => "'$purchase'").join(',') ?? '';

    String sellString =
        chartSaleInsider?.map((sell) => "'$sell'").join(',') ?? '';

    double fontSize = isPhone ? 20 : 15;

    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    </style>
      </head>
      <body>
      <div id="chart" style="height: 500px; font-size: 16px;"></div>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
        <script>
            var height = "500";
            var options = {
                legend: {
                    fontSize: '20px',
                },
                series: [{
                  name: 'Purchase',
                  data: [$purchaseString]
                }, {
                  name: 'Sell',
                  data: [$sellString]
                }],
                chart: {
                  height: height,
                  type: 'area',
                  zoom: {
                      enabled: false
                  },
                  toolbar: {
                      show: false
                  }
                },
                dataLabels: {
                  enabled: false
                },
                stroke: {
                  curve: 'smooth'
                },
                xaxis: {
                  type: 'date',
                  categories: [$categoriesString],
                  labels: {
                    style: {
                      fontSize: '${fontSize}px' 
                    }
                  }
                },
                tooltip: {
                  x: {
                    format: 'MM/dd/yy',
                  },
                  style: {
                    fontSize: '20px'  
                  }
                },
                colors: ['green', 'red'],
                theme: {
                  mode: 'dark',
                  palette: 'palette7', 
                },
            };

            var chart = new ApexCharts(document.querySelector("#chart"), options);
            chart.render();
        </script>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenWidth / (isPhone ? 2 : 1.5),
      width: ScreenUtil().screenWidth,
      child: WebViewWidget(controller: controller),
    );
  }
}
