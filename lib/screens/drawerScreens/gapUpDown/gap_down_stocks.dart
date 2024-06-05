import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/gap_up_down_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/gapUpDown/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class GapDownStocks extends StatefulWidget {
  const GapDownStocks({super.key});

  @override
  State<GapDownStocks> createState() => _GapDownStocksState();
}

class _GapDownStocksState extends State<GapDownStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<GapUpDownProvider>().getGapDownStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    GapUpDownProvider provider = context.watch<GapUpDownProvider>();
    List<GapUpRes>? data = provider.dataDown;
    return BaseUiContainer(
      error: provider.errorDown,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoadingDown,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getGapDownStocks(),
      child: RefreshControl(
        onRefresh: () async => provider.getGapDownStocks(),
        canLoadMore: provider.canLoadMoreDown,
        onLoadMore: () async => provider.getGapDownStocks(loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
            top: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0) HtmlTitle(subTitle: provider.extraUp?.subTitle),
                UpDownStocksItem(data: data![index], index: index),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: ThemeColors.greyBorder, height: 20.sp);
          },
          itemCount: data?.length ?? 0,
        ),
      ),
    );
  }
}
