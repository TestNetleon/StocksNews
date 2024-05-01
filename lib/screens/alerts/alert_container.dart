import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/alerts_res.dart';
import 'package:stocks_news_new/providers/alert_provider.dart';
import 'package:stocks_news_new/screens/alerts/alert_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

class AlertContainer extends StatelessWidget {
  const AlertContainer({super.key});

  @override
  Widget build(BuildContext context) {
    AlertProvider provider = context.watch<AlertProvider>();
//
    return RefreshControll(
      onRefresh: () => provider.getAlerts(showProgress: true),
      canLoadmore: provider.canLoadMore,
      onLoadMore: () => provider.getAlerts(loadMore: true),
      child: ListView.separated(
        itemCount: provider.data?.length ?? 0,
        padding: EdgeInsets.only(top: 5.sp, bottom: 16.sp),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          AlertData data = provider.data![index];
          return AlertsItem(
            data: data,
            index: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          // return const SpacerVerticel(height: 12);
          return Divider(
            color: ThemeColors.greyBorder,
            height: 12.sp,
          );
        },
      ),
    );
  }
}
