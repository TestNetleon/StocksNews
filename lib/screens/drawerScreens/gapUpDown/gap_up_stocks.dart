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

class GapUpStocks extends StatefulWidget {
  const GapUpStocks({super.key});

  @override
  State<GapUpStocks> createState() => _GapUpStocksState();
}

class _GapUpStocksState extends State<GapUpStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.read<GapUpDownProvider>().dataUp != null) {
        return;
      }
      context.read<GapUpDownProvider>().getGapUpStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    GapUpDownProvider provider = context.watch<GapUpDownProvider>();
    List<GapUpRes>? data = provider.dataUp;

    return BaseUiContainer(
      error: provider.errorUp,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoadingUp,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getGapUpStocks(),
      child: RefreshControl(
        onRefresh: () async => provider.getGapUpStocks(),
        canLoadMore: provider.canLoadMoreUp,
        onLoadMore: () async => provider.getGapUpStocks(loadMore: true),
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
