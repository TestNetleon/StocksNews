import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/trending_industries.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrendingIndustriesGraph extends StatefulWidget {
  const TrendingIndustriesGraph({super.key});

  @override
  State<TrendingIndustriesGraph> createState() =>
      _TrendingIndustriesGraphState();
}

class _TrendingIndustriesGraphState extends State<TrendingIndustriesGraph> {
  WebViewController controller = WebViewController();
  @override
  void initState() {
    super.initState();
    _renderData();
  }

//
  void _renderData() {
    TrendingIndustriesProvider provider =
        context.read<TrendingIndustriesProvider>();
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
      ..loadHtmlString(_loadData(
        labels: provider.labels,
        negativeMentions: provider.negativeMentions,
        neutralMentions: provider.neutralMentions,
        positiveMentions: provider.positiveMentions,
        totalMentions: provider.totalMentions,
      ));
  }

//   String _loadData({
//     List<String>? labels,
//     List<int>? totalMentions,
//     List<int>? positiveMentions,
//     List<int>? negativeMentions,
//     List<int>? neutralMentions,
//   }) {
//     String labelsString = labels?.map((date) => "'$date'").join(',') ?? '';

//     String totalMentionsString =
//         totalMentions?.map((purchase) => "'$purchase'").join(',') ?? '';

//     String positiveMentionsString =
//         positiveMentions?.map((sell) => "'$sell'").join(',') ?? '';
//     String negativeMentionsString =
//         negativeMentions?.map((purchase) => "'$purchase'").join(',') ?? '';

//     String neutralMentionsString =
//         neutralMentions?.map((sell) => "'$sell'").join(',') ?? '';

//     return '''
// <canvas id="chart"></canvas>
// <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
// <script>
//     // Get chart canvas
//     var ctx = document.getElementById('chart').getContext('2d');

//     // Create the column chart
//    // Create the column chart
// var chart = new Chart(ctx, {
//     type: 'bar',
//     data: {
//         labels: ["Semiconductors","Banks\u2014Regional","Auto Manufacturers","Biotechnology","Software\u2014Application","Credit Services","Consumer Electronics","Internet Retail","Electrical Equipment & Parts","Marine Shipping","Asset Management","Aerospace & Defense","Drug Manufacturers\u2014General","Airlines","REIT\u2014Residential","Gambling","Software\u2014Infrastructure","Metal Fabrication","Uranium","Medical Devices","Specialty Chemicals","Telecom Services","Oil & Gas Midstream","REIT\u2014Specialty","Medical Instruments & Supplies","Shell Companies","Specialty Industrial Machinery","Furnishings, Fixtures & Appliances","Drug Manufacturers\u2014Specialty & Generic","Banks\u2014Diversified","Broadcasting","Auto Parts","Specialty Retail","Conglomerates","Oil & Gas E&P","Information Technology Services","Lodging","REIT\u2014Diversified","Financial Conglomerates","Farm Products","Advertising Agencies","Discount Stores","Consulting Services","Medical Care Facilities","Healthcare Plans","","Engineering & Construction","Steel","Building Materials","Personal Services","Communication Equipment","Specialty Business Services","Aluminum","Household & Personal Products","Entertainment","Oil & Gas Integrated","Restaurants","Solar","Railroads","Utilities\u2014Regulated Electric","Farm & Heavy Construction Machinery","Packaging & Containers","Industrial Distribution","Footwear & Accessories","Travel Services","Insurance\u2014Property & Casualty","Capital Markets","Confectioners","Utilities\u2014Diversified","Internet Content & Information","Utilities\u2014Regulated Gas","Utilities\u2014Regulated Water","Banks - Regional","REIT - Office","Computer Hardware","Financial Data & Stock Exchanges","Diagnostics & Research","Mortgage Finance","Waste Management","Paper & Paper Products","Semiconductor Equipment & Materials","REIT\u2014Mortgage","REIT\u2014Office","Electronic Components","Auto & Truck Dealerships","Insurance\u2014Specialty","REIT\u2014Retail","Packaged Foods","REIT\u2014Healthcare Facilities","Oil & Gas Equipment & Services","REIT\u2014Industrial","Tobacco","Rental & Leasing Services","Infrastructure Operations","Health Information Services","Agricultural Inputs","Residential Construction","Insurance Brokers","Utilities\u2014Renewable","Beverages\u2014Wineries & Distilleries","Copper","Scientific & Technical Instruments","Electronics & Computer Distribution","Recreational Vehicles","Home Improvement Retail","Beverages\u2014Non-Alcoholic","Integrated Freight & Logistics","Department Stores","REIT\u2014Hotel & Motel","Other Industrial Metals & Mining","Education & Training Services","Real Estate Services","Grocery Stores","Leisure","Pharmaceutical Retailers","Building Products & Equipment","Security & Protection Services","Other Precious Metals & Mining","Gold","N\/A","Resorts & Casinos"],
//         datasets: [
//             {
//                 label: 'Total Mentions',
//                 data: [1336,1363,1260,1207,856,495,484,634,373,286,469,465,373,264,217,233,536,201,365,288,234,210,248,202,248,267,365,223,281,160,140,235,105,134,233,294,122,108,158,152,136,108,98,112,95,210,148,89,73,98,146,90,117,114,138,145,170,120,119,95,137,122,78,91,83,59,119,45,64,144,95,66,63,38,87,39,69,34,43,59,82,56,59,29,45,26,30,40,49,40,40,46,30,23,53,48,31,26,46,17,17,32,15,30,19,44,25,12,29,18,17,17,10,25,10,10,15,8,8,7,5],
//                 backgroundColor: 'rgba(173, 216, 230, 0.7)',
//             },
//             {
//                 label: 'Positive Mentions',
//                 data: [1331,1352,1129,1120,851,495,484,498,70,130,462,348,326,264,217,233,414,201,315,288,143,202,248,179,237,267,365,218,178,160,140,235,53,124,205,294,84,50,44,145,136,103,98,7,95,201,140,15,73,98,142,90,117,93,126,124,170,120,119,86,124,80,78,91,83,47,91,45,64,144,90,13,63,38,87,39,69,34,43,50,82,51,48,29,45,26,30,40,49,16,40,46,30,23,53,48,31,26,46,17,17,32,15,30,19,44,25,12,29,18,17,17,0,25,10,10,6,8,8,7,0],
//                 backgroundColor: 'rgba(0, 128, 0, 0.7)',
//             },
//             {
//                 label: 'Negative Mentions',
//                 data: [5,11,131,87,5,0,0,136,303,156,7,117,47,0,0,0,122,0,50,0,91,8,0,23,11,0,0,5,98,0,0,0,52,10,28,0,32,26,114,7,0,5,0,105,0,9,8,74,0,0,4,0,0,21,12,0,0,0,0,0,9,42,0,0,0,12,28,0,0,0,5,53,0,0,0,0,0,0,0,9,0,5,11,0,0,0,0,0,0,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,5],
//                 backgroundColor: 'rgba(255, 0, 0, 0.7)',
//             },
//             {
//                 label: 'Neutral Mentions',
//                 data: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,6,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,21,0,0,0,9,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0],
//                 backgroundColor: 'rgba(54, 162, 235, 0.7)',
//             }
//         ]
//     },
//     options: {
//         scales: {
//             x: {
//                 type: 'category',
//                 grid: {
//                     color: '#222' // Set x-axis grid color to white
//                 },
//                 ticks: {
//                     color: 'white' // Set x-axis tick color to white

//                 }
//             },
//             y: {
//                 beginAtZero: true,
//                 ticks: {
//                     color: 'white' // Set y-axis tick color to white

//                 }
//             }
//         },
//         plugins: {
//             legend: {
//                 labels: {
//                     color: 'white' // Set legend label color to white
//                 }
//             }
//         }
//     }
// });

// </script>
//     ''';
//   }

  String _loadData({
    List<String>? labels,
    List<int>? totalMentions,
    List<int>? positiveMentions,
    List<int>? negativeMentions,
    List<int>? neutralMentions,
  }) {
    String labelsString = labels?.map((date) => "'$date'").join(',') ?? '';

    String totalMentionsString =
        totalMentions?.map((purchase) => "'$purchase'").join(',') ?? '';

    String positiveMentionsString =
        positiveMentions?.map((sell) => "'$sell'").join(',') ?? '';
    String negativeMentionsString =
        negativeMentions?.map((purchase) => "'$purchase'").join(',') ?? '';

    String neutralMentionsString =
        neutralMentions?.map((sell) => "'$sell'").join(',') ?? '';

    return '''
<canvas id="chart"></canvas>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Get chart canvas
    var ctx = document.getElementById('chart').getContext('2d');

    // Create the column chart
   // Create the column chart
var chart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: [$labelsString],
        datasets: [
            {
                label: 'Total Mentions',
                data: [$totalMentionsString],
                backgroundColor: 'rgba(173, 216, 230, 0.7)',
            },
            {
                label: 'Positive Mentions',
                data: [$positiveMentionsString],
                backgroundColor: 'rgba(0, 128, 0, 0.7)',
            },
            {
                label: 'Negative Mentions',
                data: [$negativeMentionsString],
                backgroundColor: 'rgba(255, 0, 0, 0.7)',
            },
            {
                label: 'Neutral Mentions',
                data: [$neutralMentionsString],
                backgroundColor: 'rgba(54, 162, 235, 0.7)',
            }
        ]
    },
    options: {
        scales: {
            x: {
                type: 'category',
                grid: {
                    color: '#222' // Set x-axis grid color to white
                },
                ticks: {
                    color: 'white', // Set x-axis tick color to white
                    font: {
                        size: 15 // Set font size for y-axis ticks
                    }
                }
            },
            y: {
                beginAtZero: true,
                ticks: {
                    color: 'white', // Set y-axis tick color to white
                    font: {
                        size: 20 // Set font size for y-axis ticks
                    }
                }
            }
        },
        plugins: {
            legend: {
                labels: {
                    color: 'white' // Set legend label color to white
                }
            }
        }
    }
});

</script>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenWidth / 1.9,
      width: ScreenUtil().screenWidth,
      child: WebViewWidget(controller: controller),
    );
  }
}
