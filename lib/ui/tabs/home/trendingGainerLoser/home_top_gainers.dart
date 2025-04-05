import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home_tabs.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/market/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class HomeTopGainers extends StatefulWidget {
  const HomeTopGainers({super.key});

  @override
  State<HomeTopGainers> createState() => _HomeTopGainersState();
}

class _HomeTopGainersState extends State<HomeTopGainers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    HomeTabsManager manager = context.read<HomeTabsManager>();
    if (manager.dataTopGainers == null) {
      manager.getHomeTopGainers();
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeTabsManager manager = context.watch<HomeTabsManager>();
    return BaseLoaderContainer(
      isLoading: manager.isLoadingTopGainers,
      hasData: manager.dataTopGainers != null && !manager.isLoadingTopGainers,
      showPreparingText: true,
      error: manager.errorTopGainers,
      onRefresh: () async {},
      child: manager.dataTopGainers == null
          ? const SizedBox()
          : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0 &&
                        !isEmpty(manager.dataTopGainers?.subtitle))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Text(
                              manager.dataTopGainers?.subtitle ?? "",
                              style: styleBaseRegular(
                                fontSize: 14,
                                color: ThemeColors.neutral40,
                              ),
                            ),
                          ),
                          BaseListDivider(),
                        ],
                      ),
                    BaseStockAddItem(
                      size: 30,
                      onTap: (value) {
                        // Navigator.pushNamed(context, SDIndex.path, arguments: {
                        //   'symbol': value.symbol,
                        // });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SDIndex(
                                      symbol: value.symbol ?? "",
                                    )));
                      },
                      data: manager.dataTopGainers!.data![index],
                      index: index,
                      manager: manager,
                      slidable: true,
                    ),
                    if (index == manager.dataTopGainers!.data!.length - 1)
                      BaseButton(
                        onPressed: () {
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   Tabs.path,
                          //   arguments: {
                          //     'index': 2,
                          //     "childIndex": 1,
                          //     "innerChildIndex": 0,
                          //   },
                          // );

                          // Navigator.pushNamed(
                          //   context,
                          //   MarketIndex.path,
                          //   arguments: {
                          //     'screenIndex': 0,
                          //     "marketIndex": 1,
                          //     "marketInnerIndex": 0,
                          //   },
                          // );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MarketIndex(
                                        screenIndex: 0,
                                        marketIndex: 1,
                                        marketInnerIndex: 0,
                                      )));
                        },
                        text: "View More Top Gainers",
                        margin: EdgeInsets.all(Pad.pad16),
                      )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
              itemCount: manager.dataTopGainers?.data?.length ?? 0,
            ),
    );
  }
}
