import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/penny_stocks.dart';
import 'package:stocks_news_new/providers/penny_stocks_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/pennyStocks/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class TopTodayPennyStocks extends StatefulWidget {
  const TopTodayPennyStocks({super.key});

  @override
  State<TopTodayPennyStocks> createState() => _TopTodayPennyStocksState();
}

class _TopTodayPennyStocksState extends State<TopTodayPennyStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PennyStocksProvider>().getData(type: 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    PennyStocksProvider provider = context.watch<PennyStocksProvider>();
    List<PennyStocksRes>? data = provider.data;

    return BaseUiContainer(
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getData(type: 3),
      child: RefreshControl(
        onRefresh: () async => provider.getData(type: 3),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getData(loadMore: true, type: 3),
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
                if (index == 0) HtmlTitle(subTitle: provider.extra?.subTitle),
                PennyStocksItem(
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
          itemCount: data?.length ?? 0,
        ),
      ),
    );
  }
}
