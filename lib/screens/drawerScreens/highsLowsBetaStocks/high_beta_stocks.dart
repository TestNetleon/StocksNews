import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/high_low_beta_stocks_res.dart';
import 'package:stocks_news_new/providers/high_beta_stocks_providers.dart';
import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

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
      if (context.read<HighBetaStocksProvider>().data != null) {
        return;
      }
      context.read<HighBetaStocksProvider>().getHighBetaStocks(type: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    HighBetaStocksProvider provider = context.watch<HighBetaStocksProvider>();
    List<HighLowBetaStocksRes>? data = provider.data;

    return BaseUiContainer(
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getHighBetaStocks(type: 1),
      child: RefreshControl(
        onRefresh: () async => provider.getHighBetaStocks(type: 1),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async =>
            provider.getHighBetaStocks(loadMore: true, type: 1),
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
                HighLowBetaStocksItem(
                  data: data[index],
                  isOpen: provider.openIndex == index,
                  onTap: () {
                    provider.setOpenIndex(
                      provider.openIndex == index ? -1 : index,
                    );
                  },
                )
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
