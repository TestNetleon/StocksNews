import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/notification/notifications.dart';
import 'package:stocks_news_new/models/notification_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/notifications/item.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class NotificationIndex extends StatefulWidget {
  static const String path = "NotificationIndex";

  const NotificationIndex({super.key});

  @override
  State<NotificationIndex> createState() => _NotificationIndexState();
}

class _NotificationIndexState extends State<NotificationIndex> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    NotificationsManager manager = context.read<NotificationsManager>();
    manager.getNotifications(showProgress: false);
  }


  @override
  Widget build(BuildContext context) {
    NotificationsManager manager = context.watch<NotificationsManager>();
    return  BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.notificationData?.title ?? "Notifications",
      ),
        body: BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.notificationData != null && !manager.isLoading,
          showPreparingText: true,
          error: manager.error,
          onRefresh: () {
            _callAPI();
          },
          child:  BaseLoadMore(
            onRefresh: manager.getNotifications,
            onLoadMore: () async => manager.getNotifications(loadMore: true),
            canLoadMore: manager.canLoadMore,
            child: ListView.separated(
              itemBuilder: (context, index) {
                Notifications? data = manager.notificationData?.notifications?[index];
                if (data == null) {
                  return SizedBox();
                }
                return NotificationItem(data: data);
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
              itemCount: manager.notificationData?.notifications?.length ?? 0,
            ),
          ),
        )
    );
  }
}
