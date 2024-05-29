import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/Earnings_res.dart';
import 'package:stocks_news_new/providers/Earnings_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/drawerScreens/Earnings/Earnings_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class EarningsList extends StatefulWidget {
  const EarningsList({super.key});

  @override
  State<EarningsList> createState() => _EarningsListState();
}

class _EarningsListState extends State<EarningsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      navigatorKey.currentContext!.read<EarningsProvider>().getEarningsStocks();
      Utils().showLog("hahaja");
    });
  }

  @override
  Widget build(BuildContext context) {
    EarningsProvider provider =
        navigatorKey.currentContext!.watch<EarningsProvider>();
    List<EarningsRes>? data = provider.data;

    return BaseUiContainer(
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
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
            if (data == null || data.isEmpty) {
              return const SizedBox();
            }
            dynamic dataItem = data[index];

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
          itemCount: data?.length ?? 0,
        ),
      ),
    );
  }
}
