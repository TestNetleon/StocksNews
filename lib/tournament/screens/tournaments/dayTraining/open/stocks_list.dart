// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/tournament/provider/search.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import '../../../../../tradingSimulator/modals/trading_search_res.dart';
// import '../../../../../widgets/cache_network_image.dart';
// import '../../../../../widgets/custom_tab_container.dart';
// import '../../../../provider/trades.dart';

// class OpenTopStock extends StatefulWidget {
//   const OpenTopStock({
//     super.key,
//   });

//   @override
//   State<OpenTopStock> createState() => _OpenTopStockState();
// }

// class _OpenTopStockState extends State<OpenTopStock>
//     with SingleTickerProviderStateMixin {
//   int selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     Utils().showLog('INIT Stock');
//     TournamentSearchProvider searchProvider =
//         context.read<TournamentSearchProvider>();

//     TournamentTradesProvider provider =
//         context.read<TournamentTradesProvider>();

//     if (searchProvider.topSearch != null && provider.selectedStock != null) {
//       selectedIndex = searchProvider.topSearch!.indexWhere(
//         (element) => element.symbol == provider.selectedStock?.symbol,
//       );
//       if (selectedIndex == -1) {
//         selectedIndex = 0;
//       }
//     }
//   }

//   void onChange({TradingSearchTickerRes? data}) {
//     TournamentTradesProvider provider =
//         context.read<TournamentTradesProvider>();

//     provider.setSelectedStock(stock: data);
//     setState(() {
//       selectedIndex = selectedIndex;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TournamentProvider provider = context.watch<TournamentProvider>();
//     TournamentSearchProvider searchProvider =
//         context.watch<TournamentSearchProvider>();

//     return Container(
//       margin: EdgeInsets.only(top: 15),
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 60),
//             child: CustomTabContainer(
//               padding: EdgeInsets.only(right: 20),
//               hideIndicator: true,
//               decorateTabBar: false,
//               widgets: [],
//               isScrollable: true,
//               onChange: (index) {
//                 Utils().showLog('change....');
//                 if (selectedIndex != index) {
//                   // selectedIndex = index;
//                   // setState(() {});
//                   onChange(data: searchProvider.topSearch?[index]);
//                 }
//               },
//               tabs: List.generate(
//                 searchProvider.topSearch?.length ?? 0,
//                 (index) {
//                   TradingSearchTickerRes? data =
//                       searchProvider.topSearch?[index];
//                   return Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: const Color.fromARGB(255, 64, 64, 64),
//                       border: selectedIndex == index
//                           ? Border.all(
//                               color: ThemeColors.accent,
//                               width: 2,
//                             )
//                           : null,
//                     ),
//                     child: CachedNetworkImagesWidget(
//                       data?.image ?? '',
//                       height: 38,
//                       width: 38,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Container(
//             height: 60,
//             width: 60,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color.fromARGB(255, 37, 37, 37),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color.fromARGB(255, 0, 16, 3),
//                   offset: Offset(4, 0),
//                   blurRadius: 10,
//                   spreadRadius: 15,
//                 ),
//               ],
//             ),
//             child: Text(
//               'All',
//               style: styleGeorgiaBold(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/search.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../../../tradingSimulator/modals/trading_search_res.dart';
import '../../../../../widgets/cache_network_image.dart';
import '../../../../provider/trades.dart';
import '../../searchTradingTicker/index.dart';

class OpenTopStock extends StatefulWidget {
  const OpenTopStock({
    super.key,
  });

  @override
  State<OpenTopStock> createState() => _OpenTopStockState();
}

class _OpenTopStockState extends State<OpenTopStock>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Utils().showLog('Stock INIT');
    // Initialize the TabController and selectedIndex here, only once
    TournamentSearchProvider searchProvider =
        context.read<TournamentSearchProvider>();

    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();

    if (searchProvider.topSearch != null && provider.selectedStock != null) {
      selectedIndex = searchProvider.topSearch!.indexWhere(
        (element) => element.symbol == provider.selectedStock?.symbol,
      );
      if (selectedIndex == -1) {
        selectedIndex = 0;
      }
    }

    _tabController = TabController(
        length: searchProvider.topSearch?.length ?? 0, vsync: this);
    _tabController.index = selectedIndex;
  }

  void onChange({TradingSearchTickerRes? data}) {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();

    provider.setSelectedStock(stock: data);
  }

  @override
  Widget build(BuildContext context) {
    TournamentSearchProvider provider =
        context.watch<TournamentSearchProvider>();

    return Container(
      margin: EdgeInsets.only(top:5),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TabBar(
            indicator: null,
            indicatorColor: Colors.transparent,
            isScrollable: true,
            controller: _tabController,
            labelPadding: EdgeInsets.only(right: 8),
            onTap: (index) {
              if (selectedIndex != index) {
                selectedIndex = index;
                setState(() {});
                onChange(data: provider.topSearch?[index]);
              }
            },
            tabs: List.generate(
              provider.topSearch?.length ?? 0,
              (index) {
                TradingSearchTickerRes? data = provider.topSearch?[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 64, 64, 64),
                    border: selectedIndex == index
                        ? Border.all(
                            color: ThemeColors.accent,
                            width: 2,
                          )
                        : null,
                  ),
                  child: CachedNetworkImagesWidget(
                    data?.image ?? '',
                    height: 30,
                    width: 30,
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                createRoute(
                  TournamentSearch(),
                ),
              );
            },
            child: Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 37, 37, 37),
                ),
                child: Icon(Icons.search)
                ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
