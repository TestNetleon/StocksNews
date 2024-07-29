import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/trade_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../modals/home_trending_res.dart';
import '../../../../modals/top_search_res.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/loading.dart';
import '../searchField/field.dart';
import 'item.dart';

class SdSearchContainer extends StatefulWidget {
  final bool buy;
  const SdSearchContainer({
    super.key,
    this.buy = true,
  });

  @override
  State<SdSearchContainer> createState() => _SdSearchContainerState();
}

class _SdSearchContainerState extends State<SdSearchContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TradeProviderNew>().getSearchDefaults();
    });
  }

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        context.read<SearchProvider>().clearSearch();
      },
      child: BaseContainer(
        appBar: const AppBarHome(isPopback: true),
        body: provider.isLoading &&
                (provider.topSearch?.isEmpty == true ||
                    provider.topSearch == null)
            ? const Loading()
            : provider.topSearch?.isNotEmpty == true &&
                    provider.topSearch != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Dimen.padding, 0, Dimen.padding, 0),
                      child: Column(
                        children: [
                          SdTradeSearchField(
                            buy: widget.buy,
                          ),
                          SdTradeDefaultSearch(
                            buy: widget.buy,
                          ),
                        ],
                      ),
                    ),
                  )
                : ErrorDisplayWidget(
                    error: provider.error,
                  ),
      ),
    );
  }
}

class SdTradeDefaultSearch extends StatelessWidget {
  final bool buy;

  const SdTradeDefaultSearch({super.key, required this.buy});

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();

    return Column(
      children: [
        const SpacerVertical(),
        const ScreenTitle(
          title: "Top Searches",
          dividerPadding: EdgeInsets.only(bottom: 10),
        ),
        ListView.separated(
          itemCount: provider.topSearch?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TopSearch topSearch = provider.topSearch![index];
            Top top = Top(
              name: topSearch.name,
              symbol: topSearch.symbol,
              price: topSearch.price,
              changesPercentage: topSearch.changes,
              image: topSearch.image,
              displayChange: "",
            );
            return SdTradeDefaultItem(
              top: top,
              buy: buy,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 16,
              color: ThemeColors.greyBorder,
            );
          },
        ),
      ],
    );
  }
}
