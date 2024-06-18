import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/fifty_two_weeks_res.dart';
import 'package:stocks_news_new/providers/fifty_two_weeks_provider.dart';
import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class FiftyTwoWeeksLowsStocks extends StatefulWidget {
  const FiftyTwoWeeksLowsStocks({super.key});

  @override
  State<FiftyTwoWeeksLowsStocks> createState() =>
      _FiftyTwoWeeksLowsStocksState();
}

class _FiftyTwoWeeksLowsStocksState extends State<FiftyTwoWeeksLowsStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.read<FiftyTwoWeeksProvider>().dataLows != null) {
        return;
      }
      context.read<FiftyTwoWeeksProvider>().getFiftyTwoWeekLows();
    });
  }

  @override
  Widget build(BuildContext context) {
    FiftyTwoWeeksProvider provider = context.watch<FiftyTwoWeeksProvider>();
    List<FiftyTwoWeeksRes>? data = provider.dataLows;

    return BaseUiContainer(
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getFiftyTwoWeekLows(),
      child: RefreshControl(
        onRefresh: () async => provider.getFiftyTwoWeekLows(),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getFiftyTwoWeekLows(loadMore: true),
        child: Column(
          children: [
            HtmlTitle(subTitle: provider.extraUp?.subTitle),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  bottom: Dimen.padding,
                  top: Dimen.padding,
                ),
                itemBuilder: (context, index) {
                  if (data == null || data.isEmpty) {
                    return const SizedBox();
                  }
                  return FiftyTwoWeeksItem(
                    data: data[index],
                    index: index,
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
          ],
        ),
      ),
    );
  }
}
