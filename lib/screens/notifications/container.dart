// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/notification_res.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/notification_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/notifications/item.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/no_data.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/login_error.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

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
      UserRes? res = context.read<UserProvider>().user;
      if (res != null) {
        _callAPi();
      }
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Notifications"},
      );
    });
  }

  Future _callAPi() async {
    context.read<NotificationProvider>().getData(showProgress: false);
  }

  @override
  Widget build(BuildContext context) {
    NotificationProvider provider = context.watch<NotificationProvider>();
    List<NotificationData>? data =
        context.watch<NotificationProvider>().data?.data;

    UserRes? res = context.watch<UserProvider>().user;

    return BaseContainer(
      drawer: const BaseDrawer(
        resetIndex: true,
      ),
      appBar: const AppBarHome(
        isPopback: true,
        title: "Notifications",
        showTrailing: false,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding.sp, 0),
        child: Column(
          children: [
            // res == null
            //     ? const SizedBox()
            //     : const ScreenTitle(
            //         title: "Notifications",
            //         dividerPadding: EdgeInsets.only(bottom: Dimen.itemSpacing),
            //       ),
            Expanded(
              child: res == null
                  ? Column(
                      children: [
                        Expanded(
                            child: LoginError(
                          state: "notification",
                          title: "Notifications",
                          onClick: () async {
                            isPhone
                                ? await loginSheet()
                                : await loginSheetTablet();
                            _callAPi();
                          },
                        ))
                      ],
                    )
                  : BaseUiContainer(
                      error: provider.error,
                      hasData: data != null && data.isNotEmpty,
                      isLoading: provider.isLoading,
                      errorDispCommon: true,
                      showPreparingText: true,
                      onRefresh: () => provider.getData(showProgress: false),
                      child: RefreshControl(
                        onRefresh: () async =>
                            provider.getData(showProgress: false),
                        canLoadMore: provider.canLoadMore,
                        onLoadMore: () async =>
                            provider.getData(loadMore: true),
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
