import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/common_stock_item.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeTopLoser extends StatefulWidget {
  const HomeTopLoser({super.key});

  @override
  State<HomeTopLoser> createState() => _HomeTopLoserState();
}

class _HomeTopLoserState extends State<HomeTopLoser> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HomeProvider provider = context.read<HomeProvider>();
      if (provider.homeTopLosersRes == null) {
        context.read<HomeProvider>().getHomeTopLoserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (provider.homeTopLosersRes?.losers?.isEmpty == true) {
      return const ErrorDisplayWidget(
        error: Const.errNoRecord,
        smallHeight: true,
      );
    } //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpacerVertical(height: 10.sp),
        CustomReadMoreText(
          text: provider.homeTrendingRes?.text?.losers ?? "",
        ),
        BaseUiContainer(
          hasData: (provider.homeTopLosersRes != null &&
                  provider.homeTopLosersRes?.losers?.isNotEmpty == true) &&
              !provider.isLoadingLosers &&
              provider.statusLosers != Status.ideal,
          isLoading: provider.isLoadingLosers,
          showPreparingText: true,
          child: ListView.separated(
            itemCount: provider.homeTopLosersRes?.losers?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 12.sp),
            itemBuilder: (context, index) {
              Top top = provider.homeTopLosersRes!.losers![index];
              return CommonStockItem(
                change: top.displayChange,
                changesPercentage: top.changesPercentage,
                image: top.image,
                name: top.name,
                price: top.price,
                symbol: top.symbol,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SpacerVertical(height: 10);
            },
          ),
        ),
      ],
    );
  }
}
