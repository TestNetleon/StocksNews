// import 'package:flutter/material.dart';

// class MarketData {
//   final dynamic symbol;
//   final dynamic companyName;
//   final dynamic time;
//   final dynamic bid;
//   final dynamic ask;
//   final dynamic last;
//   final dynamic netChange;
//   final dynamic percentChange;
//   final dynamic volume;
//   final dynamic dollarVolume;

//   MarketData({
//     this.symbol,
//     this.companyName,
//     this.time,
//     this.bid,
//     this.ask,
//     this.last,
//     this.netChange,
//     this.percentChange,
//     this.volume,
//     this.dollarVolume,
//   });
// }

// class MarketDataProvider with ChangeNotifier {
//   List<MarketData> _marketDataList = [];
//   List<MarketData> get marketDataList => _marketDataList;

//   void addMarketData(List<MarketData> dataList) {
//     _marketDataList.insertAll(0, dataList);
//     notifyListeners();
//   }

//   void clearData() {
//     _marketDataList.clear();
//     notifyListeners();
//   }
// }
