import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/highlow_pe_res.dart';
import 'package:stocks_news_new/providers/high_low_pe.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import 'item.dart';

class HighPeStocks extends StatefulWidget {
  const HighPeStocks({super.key});

  @override
  State<HighPeStocks> createState() => _HighPeStocksState();
}

class _HighPeStocksState extends State<HighPeStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.read<HighLowPeProvider>().dataHighPERatio != null) {
        return;
      }
      context
          .read<HighLowPeProvider>()
          .getData(showProgress: true, type: "high");
    });
  }

  @override
  Widget build(BuildContext context) {
    HighLowPeProvider provider = context.watch<HighLowPeProvider>();

    return BaseUiContainer(
      error: provider.error,
      // hasData: up != null && up.isNotEmpty,
      hasData: !provider.isLoading &&
          provider.dataHighPERatio != null &&
          provider.dataHighPERatio?.isNotEmpty == true,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getData(showProgress: true, type: "high"),
      child: RefreshControl(
        onRefresh: () async =>
            provider.getData(showProgress: true, type: "high"),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async =>
            provider.getData(showProgress: false, type: "high", loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
            // top: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            HIghLowPeRes? high = provider.dataHighPERatio?[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (index == 0) HtmlTitle(subTitle: provider.subTitle),
                HighLowPEItem(index: index, data: high),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: ThemeColors.greyBorder, height: 20.sp);
          },
          itemCount: provider.dataHighPERatio?.length ?? 0,
        ),
      ),
    );
  }
}
