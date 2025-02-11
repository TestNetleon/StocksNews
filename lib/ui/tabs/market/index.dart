import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../base/common_tab.dart';

class MarketIndex extends StatefulWidget {
  const MarketIndex({super.key});

  @override
  State<MarketIndex> createState() => _MarketIndexState();
}

class _MarketIndexState extends State<MarketIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    MarketManager provider = context.read<MarketManager>();
    provider.getData();
  }

  @override
  Widget build(BuildContext context) {
    MarketManager provider = context.watch<MarketManager>();
    return BaseContainer(
      body: BaseLoaderContainer(
        isLoading: provider.isLoading,
        hasData: provider.data != null && !provider.isLoading,
        showPreparingText: true,
        error: provider.error,
        onRefresh: () {},
        child: provider.data == null
            ? const SizedBox()
            : Column(
                children: [
                  CommonTabs(
                    data: provider.data!.data!,
                    onTap: (index) {},
                    rightChild: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                  CommonTabs(
                    data: provider.data!.data!,
                    onTap: (index) {},
                    rightChild: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
      ),
    );

    // return BaseContainer(
    //   body: Column(
    //     children: [
    //       CommonTabs(
    //         data: [
    //           {
    //             "label": "Stocks",
    //           },
    //           {
    //             "label": "Sectors",
    //           },
    //           {
    //             "label": "Industries",
    //           }
    //         ],
    //         onTap: (index) {},
    //         rightChild: Icon(
    //           Icons.search,
    //           color: Colors.black,
    //         ),
    //       ),
    //       CommonTabs(
    //         data: [
    //           {
    //             "label": "Stocks",
    //           },
    //           {
    //             "label": "Sectors",
    //           },
    //           {
    //             "label": "Industries",
    //           }
    //         ],
    //         onTap: (index) {},
    //         rightChild: Icon(
    //           Icons.search,
    //           color: Colors.black,
    //         ),
    //       ),
    //     ],
    //   ),
    //   // body: Text("HERE"),
    // );
  }
}
