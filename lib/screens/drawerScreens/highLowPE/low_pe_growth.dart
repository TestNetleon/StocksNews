import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/highLowPE/item.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../modals/highlow_pe_res.dart';
import '../../../providers/high_low_pe.dart';
import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/drawer_screen_title.dart';
import '../../../widgets/refresh_controll.dart';

class LowPEGrowthStocks extends StatefulWidget {
  const LowPEGrowthStocks({super.key});

  @override
  State<LowPEGrowthStocks> createState() => _LowPEGrowthStocksState();
}

class _LowPEGrowthStocksState extends State<LowPEGrowthStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<HighLowPeProvider>()
          .getData(showProgress: true, type: "lowGrowth");
    });
  }

  @override
  Widget build(BuildContext context) {
    HighLowPeProvider provider = context.watch<HighLowPeProvider>();

    return BaseUiContainer(
      error: provider.error,
      // hasData: up != null && up.isNotEmpty,
      hasData: true,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getData(showProgress: true, type: "low"),
      child: RefreshControl(
        onRefresh: () => provider.getData(showProgress: true, type: "low"),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () =>
            provider.getData(showProgress: false, type: "low", loadMore: true),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerScreenTitle(
                subTitle: provider.subTitle,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: Dimen.padding.sp,
                  top: Dimen.padding.sp,
                ),
                itemBuilder: (context, index) {
                  HIghLowPeRes? low = provider.data?[index];

                  // if (up == null || up.isEmpty) {
                  //   return const SizedBox();
                  // }
                  // return GainerLoserItem(
                  //   data: up[index],
                  //   index: index,
                  // );
                  return HighLowPEItem(
                    index: index,
                    data: low,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: ThemeColors.greyBorder,
                    height: 20.sp,
                  );
                },
                // itemCount: up?.length ?? 0,
                itemCount: provider.data?.length ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
