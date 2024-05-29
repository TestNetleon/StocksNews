import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/most_active_stocks_res.dart';
import 'package:stocks_news_new/providers/most_active_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/drawerMarketDataScSimmer/simmer_sc_common.dart';
import 'package:stocks_news_new/screens/drawerScreens/mostActive/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class MostVolatileStocks extends StatefulWidget {
  const MostVolatileStocks({super.key});

  @override
  State<MostVolatileStocks> createState() => _MostVolatileStocksState();
}

class _MostVolatileStocksState extends State<MostVolatileStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MostActiveProvider>().getMostActiveData(type: 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    MostActiveProvider provider = context.watch<MostActiveProvider>();
    List<MostActiveStocksRes>? data = provider.data;

    return BaseUiContainer(
      placeholder: const SimmerScreenDrawerCommon(),
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getMostActiveData(type: 2),
      child: RefreshControl(
        onRefresh: () async => provider.getMostActiveData(type: 2),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async =>
            provider.getMostActiveData(loadMore: true, type: 2),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0) HtmlTitle(subTitle: provider.extraUp?.subTitle),
                MostActiveItem(
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
