import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home_tabs.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class HomeTrending extends StatefulWidget {
  const HomeTrending({super.key});

  @override
  State<HomeTrending> createState() => _HomeTrendingState();
}

class _HomeTrendingState extends State<HomeTrending> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    HomeTabsManager manager = context.read<HomeTabsManager>();
    if (manager.dataTrending == null) {
      manager.getHomeTrending();
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeTabsManager manager = context.watch<HomeTabsManager>();
    return BaseLoaderContainer(
      isLoading: manager.isLoadingTrending,
      hasData: manager.dataTrending != null && !manager.isLoadingTrending,
      showPreparingText: true,
      error: manager.errorTrending,
      onRefresh: () async {},
      child: manager.dataTrending == null
          ? const SizedBox()
          : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0 && !isEmpty(manager.dataTrending?.subtitle))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            child: Text(
                              manager.dataTrending?.subtitle ?? "",
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
                      onTap: (value) {
                        Navigator.pushNamed(context, SDIndex.path, arguments: {
                          'symbol': value.symbol,
                        });
                      },
                      data: manager.dataTrending!.data![index],
                      index: index,
                      manager: manager,
                      slidable: true,
                    ),
                    if (index == manager.dataTrending!.data!.length - 1)
                      BaseButton(
                        onPressed: () {},
                        text: "View More Trending",
                        margin: EdgeInsets.all(Pad.pad16),
                      )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
              itemCount: manager.dataTrending?.data?.length ?? 0,
            ),
    );
  }
}
