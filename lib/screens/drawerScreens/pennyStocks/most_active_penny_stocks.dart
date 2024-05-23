import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/penny_stocks.dart';
import 'package:stocks_news_new/providers/penny_stocks_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/pennyStocks/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/drawer_screen_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class MostActivePennyStocks extends StatefulWidget {
  const MostActivePennyStocks({super.key});

  @override
  State<MostActivePennyStocks> createState() => _MostActivePennyStocksState();
}

class _MostActivePennyStocksState extends State<MostActivePennyStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PennyStocksProvider>().getData();
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
      onRefresh: () => provider.getData(),
      child: RefreshControl(
        onRefresh: () async => provider.getData(),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getData(loadMore: true),
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
              children: [
                if (index == 0)
                  DrawerScreenTitle(subTitle: provider.extra?.subTitle),
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
