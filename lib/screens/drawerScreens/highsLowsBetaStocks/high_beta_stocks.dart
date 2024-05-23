import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/high_low_beta_stocks_res_dart';
import 'package:stocks_news_new/providers/high_low_beta_stocks_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/drawer_screen_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class HighBetaStocks extends StatefulWidget {
  const HighBetaStocks({super.key});

  @override
  State<HighBetaStocks> createState() => _HighBetaStocksState();
}

class _HighBetaStocksState extends State<HighBetaStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<HighLowBetaStocksProvider>()
          .getHighLowNegativeBetaStocks(type: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    HighLowBetaStocksProvider provider =
        context.watch<HighLowBetaStocksProvider>();
    List<HighLowBetaStocksRes>? data = provider.data;

    return BaseUiContainer(
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getHighLowNegativeBetaStocks(type: 1),
      child: RefreshControl(
        onRefresh: () async => provider.getHighLowNegativeBetaStocks(type: 1),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async =>
            provider.getHighLowNegativeBetaStocks(loadMore: true, type: 1),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
            top: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            if (data == null || data.isEmpty) {
              return const SizedBox();
            }
            return Column(
              children: [
                if (index == 0)
                  DrawerScreenTitle(subTitle: provider.extraUp?.subTitle),
                HighLowBetaStocksItem(
                  data: data[index],
                  index: index,
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
          },
          // itemCount: up?.length ?? 0,
          itemCount: data?.length ?? 0,
        ),
      ),
    );
  }
}
