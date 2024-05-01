import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/notification_res.dart';
import 'package:stocks_news_new/providers/notification_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/notifications/item.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NotificationsContainer extends StatefulWidget {
  static const String path = "Notifications";
//
  const NotificationsContainer({super.key});

  @override
  State<NotificationsContainer> createState() => _NotificationsContainerState();
}

class _NotificationsContainerState extends State<NotificationsContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NotificationProvider>().getData(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    NotificationProvider provider = context.watch<NotificationProvider>();
    List<NotificationData>? data =
        context.watch<NotificationProvider>().data?.data;
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(
          isPopback: true, showTrailing: false, canSearch: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: Column(
          children: [
            const ScreenTitle(title: "Notifications"),
            Expanded(
              child: BaseUiContainer(
                error: provider.error,
                hasData: data != null && data.isNotEmpty,
                isLoading: provider.isLoading,
                errorDispCommon: true,
                onRefresh: () => provider.getData(showProgress: true),
                child: RefreshControll(
                  onRefresh: () => provider.getData(showProgress: true),
                  canLoadmore: provider.canLoadMore,
                  onLoadMore: () => provider.getData(loadMore: true),
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: Dimen.padding.sp),
                    itemBuilder: (context, index) {
                      if (data == null || data.isEmpty) {
                        return const SizedBox();
                      }
                      return NotificationsItem(data: data[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SpacerVertical(height: 14);
                    },
                    itemCount: data?.length ?? 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
