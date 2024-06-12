import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/dividends_res.dart';
import 'package:stocks_news_new/providers/dividends_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/dividends/dividends_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class DividendsList extends StatefulWidget {
  const DividendsList({super.key});

  @override
  State<DividendsList> createState() => _DividendsListState();
}

class _DividendsListState extends State<DividendsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.read<DividendsProvider>().data != null) {
        return;
      }
      context.read<DividendsProvider>().getDividendsStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    DividendsProvider provider = context.watch<DividendsProvider>();
    List<DividendsRes>? data = provider.data;

    return Column(
      children: [
        ScreenTitle(
          htmlTitle: true,
          title: provider.extraUp?.title ?? "Dividend Announcements",
          subTitleHtml: true,
          subTitle: provider.extraUp?.subTitle,
        ),
        Expanded(
          child: BaseUiContainer(
            error: provider.error,
            hasData: data != null && data.isNotEmpty,
            isLoading: provider.isLoading,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getDividendsStocks(),
            child: RefreshControl(
              onRefresh: () async => provider.getDividendsStocks(),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async =>
                  provider.getDividendsStocks(loadMore: true),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimen.padding,
                ),
                itemBuilder: (context, index) {
                  if (data == null || data.isEmpty) {
                    return const SizedBox();
                  }
                  return DividendsItem(data: data[index], index: index);
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
          ),
        ),
      ],
    );
  }
}
