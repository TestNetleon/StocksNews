import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/stocks_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';

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
    return BaseUiContainer(
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
          return StocksItem(top: top, gainer: false);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: ThemeColors.greyBorder,
            height: 20.sp,
          );
        },
      ),
    );
  }
}
