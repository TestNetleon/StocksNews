// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../providers/market.dart';
// import '../../../../service/socket/service.dart';
// import '../../../../utils/theme.dart';
// import 'dart:async';

// class MarketDataScreen extends StatefulWidget {
//   const MarketDataScreen({super.key});

//   @override
//   State<MarketDataScreen> createState() => _MarketDataScreenState();
// }

// class _MarketDataScreenState extends State<MarketDataScreen> {
//   late Timer _timer;
//   bool _isFetching = false;

//   @override
//   void initState() {
//     super.initState();
//     _getMarketData();
//     _timer = Timer.periodic(Duration(seconds: 10), (timer) {
//       if (!_isFetching) {
//         _getMarketData();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   _getMarketData() async {
//     if (_isFetching) return;

//     setState(() {
//       _isFetching = true;
//     });

//     try {
//       SocketApi().gotEvent(
//         'market-data',
//         (dynamic p0) {
//           if (p0 is List) {
//             List<dynamic> marketDataList = p0;
//             List<MarketData> dataList = marketDataList.map((data) {
//               return MarketData(
//                 symbol: data['symbol'],
//                 companyName: data['companyName'],
//                 time: data['time'],
//                 bid: data['bid'],
//                 ask: data['ask'],
//                 last: data['last'],
//                 netChange: data['netChange'],
//                 percentChange: data['percentChange'],
//                 volume: data['volume'],
//                 dollarVolume: data['dollarVolume'],
//               );
//             }).toList();

//             Provider.of<MarketDataProvider>(context, listen: false)
//                 .addMarketData(dataList);
//           }
//         },
//       );
//     } finally {
//       setState(() {
//         _isFetching = false;
//       });
//     }
//   }

//   Widget _buildDataTableCell(String text) {
//     return Text(text, style: styleGeorgiaRegular());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Market Data'),
//       ),
//       body: Consumer<MarketDataProvider>(
//         builder: (context, marketDataProvider, child) {
//           return SingleChildScrollView(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: const [
//                   DataColumn(label: Text('Symbol')),
//                   DataColumn(label: Text('Company Name')),
//                   DataColumn(label: Text('Time')),
//                   DataColumn(label: Text('Bid')),
//                   DataColumn(label: Text('Ask')),
//                   DataColumn(label: Text('Last')),
//                   DataColumn(label: Text('Net Change')),
//                   DataColumn(label: Text('Change%')),
//                   DataColumn(label: Text('Volume')),
//                   DataColumn(label: Text('\$Volume')),
//                 ],
//                 rows: [
//                   // Table Data Rows
//                   for (var data in marketDataProvider.marketDataList)
//                     DataRow(
//                       cells: [
//                         DataCell(_buildDataTableCell(data.symbol ?? 'N/A')),
//                         DataCell(
//                             _buildDataTableCell(data.companyName ?? 'N/A')),
//                         DataCell(_buildDataTableCell(data.time ?? '')),
//                         DataCell(_buildDataTableCell('${data.bid}')),
//                         DataCell(_buildDataTableCell('${data.ask}')),
//                         DataCell(_buildDataTableCell('${data.last}')),
//                         DataCell(_buildDataTableCell('${data.netChange}')),
//                         DataCell(_buildDataTableCell('${data.percentChange}%')),
//                         DataCell(_buildDataTableCell('${data.volume}')),
//                         DataCell(_buildDataTableCell('\$${data.dollarVolume}')),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
