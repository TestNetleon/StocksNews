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

class HomeTopGainer extends StatefulWidget {
  const HomeTopGainer({super.key});

  @override
  State<HomeTopGainer> createState() => _HomeTopGainerState();
}

class _HomeTopGainerState extends State<HomeTopGainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HomeProvider provider = context.read<HomeProvider>();
      if (provider.homeTopGainerRes == null) {
        context.read<HomeProvider>().getHomeTopGainerData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (provider.homeTopGainerRes?.gainers?.isEmpty == true) {
      return const ErrorDisplayWidget(
        error: Const.errNoRecord,
        smallHeight: true,
      );
    }

    return BaseUiContainer(
      hasData: (provider.homeTopGainerRes != null &&
              provider.homeTopGainerRes?.gainers?.isNotEmpty == true) &&
          !provider.isLoadingGainers &&
          provider.statusGainers != Status.ideal,
      isLoading: provider.isLoadingGainers,
      showPreparingText: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpacerVertical(height: 10.sp),
          CustomReadMoreText(
            text: provider.homeTrendingRes?.text?.gainers ?? "",
          ),
          ListView.separated(
            itemCount: provider.homeTopGainerRes?.gainers?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 12.sp),
            itemBuilder: (context, index) {
              Top top = provider.homeTopGainerRes!.gainers![index];
              // return StocksItem(top: top, gainer: true);
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
              return const SpacerVertical(height: 12);
            },
          ),
        ],
      ),
    );
  }
}
