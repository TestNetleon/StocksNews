import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/highlow_pe_res.dart';
import 'package:stocks_news_new/providers/high_low_pe.dart';
import 'package:stocks_news_new/utils/colors.dart';

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
      hasData: true,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getData(showProgress: true, type: "high"),
      child: RefreshControl(
        onRefresh: () => provider.getData(showProgress: true, type: "high"),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () =>
            provider.getData(showProgress: false, type: "high", loadMore: true),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text(
              //   "data",
              //   style: stylePTSansRegular(),
              // ),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: Dimen.padding.sp,
                  top: Dimen.padding.sp,
                ),
                itemBuilder: (context, index) {
                  HIghLowPeRes? high = provider.data?[index];

                  return HighLowPEItem(
                    index: index,
                    data: high,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: ThemeColors.greyBorder,
                    height: 20.sp,
                  );
                },
                itemCount: provider.data?.length ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
