import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/fifty_two_weeks_res.dart';
import 'package:stocks_news_new/providers/fifty_two_weeks_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/fiftyTwoWeeks/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/drawer_screen_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class FiftyTwoWeeksHighsStocks extends StatefulWidget {
  const FiftyTwoWeeksHighsStocks({super.key});

  @override
  State<FiftyTwoWeeksHighsStocks> createState() =>
      _FiftyTwoWeeksHighsStocksState();
}

class _FiftyTwoWeeksHighsStocksState extends State<FiftyTwoWeeksHighsStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FiftyTwoWeeksProvider>().getFiftyTwoWeekHigh();
    });
  }

  @override
  Widget build(BuildContext context) {
    FiftyTwoWeeksProvider provider = context.watch<FiftyTwoWeeksProvider>();
    List<FiftyTwoWeeksRes>? data = provider.data;

    return BaseUiContainer(
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getFiftyTwoWeekHigh(),
      child: RefreshControl(
        onRefresh: () async => provider.getFiftyTwoWeekHigh(),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getFiftyTwoWeekHigh(loadMore: true),
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
                FiftyTwoWeeksItem(
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
