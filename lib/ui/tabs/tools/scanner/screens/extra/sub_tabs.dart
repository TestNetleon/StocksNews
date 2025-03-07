import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';

class ScannerSubHeaderTab extends StatefulWidget {
  const ScannerSubHeaderTab({
    super.key,
  });

  @override
  State<ScannerSubHeaderTab> createState() => _ScannerSubHeaderTabState();
}

class _ScannerSubHeaderTabState extends State<ScannerSubHeaderTab> {
  List<MarketResData> tabs = [
    MarketResData(title: 'Percent Change'),
    MarketResData(title: 'Volume'),
  ];

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  onTab(index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      setState(() {});
      context.read<ScannerManager>().onSubTabChange(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerManager>(
      builder: (context, value, child) {
        return BaseTabs(
          selectedIndex: value.selectedSubIndex,
          data: tabs,
          onTap: onTab,
          isScrollable: false,
        );
      },
    );

    // return Container(
    //   margin: EdgeInsets.only(top: 10),
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: Container(
    //           // padding: const EdgeInsets.all(5),
    //           margin: EdgeInsets.all(5),
    //           decoration: BoxDecoration(
    //             color: const Color.fromARGB(255, 21, 21, 21),
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: GestureDetector(
    //                   onTap: widget.onPercentClick,
    //                   child: Container(
    //                     padding: EdgeInsets.all(10),
    //                     decoration: BoxDecoration(
    //                       color: widget.isPercent == true
    //                           ? const Color.fromARGB(255, 0, 82, 4)
    //                           : null,
    //                       borderRadius: BorderRadius.circular(8),
    //                     ),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Visibility(
    //                           visible: widget.isPercent == true,
    //                           child: Container(
    //                             margin: EdgeInsets.only(right: 5),
    //                             child: FaIcon(
    //                               FontAwesomeIcons.sort,
    //                               size: 14,
    //                             ),
    //                           ),
    //                         ),
    //                         Text(
    //                           "Percent Change",
    //                           style: styleGeorgiaBold(fontSize: 14),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Expanded(
    //                 child: GestureDetector(
    //                   onTap: widget.onVolumnClick,
    //                   child: Container(
    //                     padding: EdgeInsets.all(10),
    //                     alignment: Alignment.center,
    //                     decoration: BoxDecoration(
    //                       color: widget.isVolume == true
    //                           ? const Color.fromARGB(255, 0, 82, 4)
    //                           : null,
    //                       borderRadius: BorderRadius.circular(8),
    //                     ),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Visibility(
    //                           visible: widget.isVolume == true,
    //                           child: Container(
    //                             margin: EdgeInsets.only(right: 5),
    //                             child: FaIcon(
    //                               // orderByAsc == true
    //                               //     ? FontAwesomeIcons.arrowDownLong
    //                               //     : FontAwesomeIcons.arrowUpLong,
    //                               FontAwesomeIcons.sort,
    //                               size: 14,
    //                             ),
    //                           ),
    //                         ),
    //                         Text(
    //                           "Volume",
    //                           style: styleGeorgiaBold(fontSize: 14),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
