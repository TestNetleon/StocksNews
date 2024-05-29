import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/earnings_res.dart';
import 'package:stocks_news_new/providers/earnings_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/drawerMarketDataScSimmer/simmer_sc_common.dart';
import 'package:stocks_news_new/screens/drawerScreens/earnings/earnings_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/html_title.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

class EarningsList extends StatefulWidget {
  const EarningsList({super.key});

  @override
  State<EarningsList> createState() => _EarningsListState();
}

class _EarningsListState extends State<EarningsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EarningsProvider>().getEarningsStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    EarningsProvider provider = context.watch<EarningsProvider>();

    return BaseUiContainer(
      placeholder: const SimmerScreenDrawerCommon(),
      error: provider.error,
      hasData: provider.data != null && provider.data!.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getEarningsStocks(),
      child: RefreshControl(
        onRefresh: () async => provider.getEarningsStocks(),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getEarningsStocks(loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            if (provider.data == null || provider.data!.isEmpty) {
              return const SizedBox();
            }
            EarningsRes dataItem = provider.data![index] as EarningsRes;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0) HtmlTitle(subTitle: provider.extraUp?.subTitle),
                EarningsItem(data: dataItem, index: index)
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
          },
          itemCount: provider.data?.length ?? 0,
        ),
      ),
    );
  }
}
