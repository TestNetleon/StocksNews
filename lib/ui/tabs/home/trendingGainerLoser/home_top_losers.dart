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

class HomeTopLosers extends StatefulWidget {
  const HomeTopLosers({super.key});

  @override
  State<HomeTopLosers> createState() => _HomeTopLosersState();
}

class _HomeTopLosersState extends State<HomeTopLosers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    HomeTabsManager manager = context.read<HomeTabsManager>();
    if (manager.dataTopLosers == null) {
      manager.getHomeTopLosers();
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeTabsManager manager = context.watch<HomeTabsManager>();
    return BaseLoaderContainer(
      isLoading: manager.isLoadingTopLosers,
      hasData: manager.dataTopLosers != null && !manager.isLoadingTopLosers,
      showPreparingText: true,
      error: manager.errorTopLosers,
      onRefresh: () async {},
      child: manager.dataTopLosers == null
          ? const SizedBox()
          : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0 && !isEmpty(manager.dataTopLosers?.subtitle))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Text(
                              manager.dataTopLosers?.subtitle ?? "",
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
                        Navigator.pushNamed(context, SDIndex.path, arguments: {
                          'symbol': value.symbol,
                        });
                      },
                      data: manager.dataTopLosers!.data![index],
                      index: index,
                      manager: manager,
                      slidable: true,
                    ),
                    if (index == manager.dataTopLosers!.data!.length - 1)
                      BaseButton(
                        onPressed: () {
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   Tabs.path,
                          //   arguments: {
                          //     'index': 2,
                          //     "childIndex": 1,
                          //     "innerChildIndex": 1,
                          //   },
                          // );
                          Navigator.pushNamed(
                            context,
                            MarketIndex.path,
                            arguments: {
                              'screenIndex': 0,
                              "marketIndex": 1,
                              "marketInnerIndex": 1,
                            },
                          );
                        },
                        text: "View More Top Losers",
                        margin: EdgeInsets.all(Pad.pad16),
                      )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
              itemCount: manager.dataTopLosers?.data?.length ?? 0,
            ),
    );
  }
}
