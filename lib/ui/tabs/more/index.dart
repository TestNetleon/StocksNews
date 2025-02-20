import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/subscription/screens/start/subscription.dart';
import 'package:stocks_news_new/ui/tabs/more/articles/index.dart';
import 'package:stocks_news_new/ui/tabs/more/more_item.dart';
import 'package:stocks_news_new/ui/tabs/more/notificationSettings/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'news/index.dart';

class MoreIndex extends StatelessWidget {
  const MoreIndex({super.key});

  void _navigateToNotificationSettings(context) {
    Navigator.pushNamed(context, NotificationSettings.path);
  }

  void _navigateToNews(context) {
    Navigator.pushNamed(context, CategoriesNewsIndex.path);
  }

  void _navigateToBlogs(context) {
    Navigator.pushNamed(context, BlogsIndex.path);
  }

  void _navigateToMySubscription(context) {
    Navigator.pushNamed(context, MySubscriptionIndex.path);
  }

  @override
  Widget build(BuildContext context) {
    UserManager manager = context.watch<UserManager>();
    UserRes? user = manager.user;
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: ThemeColors.neutral5, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.all(Pad.pad16),
              padding: EdgeInsets.all(Pad.pad16),
              child: Column(
                children: [
                  Image.asset(
                    Images.userPlaceholderNew,
                    width: 64,
                    height: 64,
                  ),
                  SpacerVertical(height: Pad.pad8),
                  Text(
                    user?.name ?? 'User',
                    style: styleBaseBold(fontSize: 25, height: 1.5),
                  ),
                  // SpacerVertical(height: Pad.pad5),
                  Visibility(
                    visible: user?.email != null && user?.email != '',
                    child: Text(
                      user?.email ?? '',
                      style: styleBaseRegular(fontSize: 16, height: 1.5),
                    ),
                  )
                ],
              ),
            ),
            BaseHeading(
              margin: EdgeInsets.only(left: Pad.pad16, top: Pad.pad8),
              title: "My Account",
              titleStyle: styleBaseBold(fontSize: 20),
            ),
            MoreItem(
              icon: Images.morePersonalDetails,
              label: "Personal Details",
              onTap: () {},
            ),
            MoreItem(
              icon: Images.moreStockAlerts,
              label: "Stock Alerts",
              onTap: () {},
            ),
            MoreItem(
              icon: Images.watchlist,
              label: "Watchlist",
              onTap: () {},
            ),
            MoreItem(
              icon: Images.moreMySubscription,
              label: "My Subscription",
              onTap: () {
                _navigateToMySubscription(context);
              },
            ),
            BaseHeading(
              margin: EdgeInsets.only(left: Pad.pad16, top: Pad.pad20),
              title: "Resources",
              titleStyle: styleBaseBold(fontSize: 20),
            ),
            MoreItem(
              icon: Images.watchlist,
              label: "News",
              onTap: () {
                _navigateToNews(context);
              },
            ),
            MoreItem(
              icon: Images.watchlist,
              label: "Blogs",
              onTap: () {
                _navigateToBlogs(context);
              },
            ),
            BaseHeading(
              margin: EdgeInsets.only(left: Pad.pad16, top: Pad.pad20),
              title: "Settings",
              titleStyle: styleBaseBold(fontSize: 20),
            ),
            MoreItem(
              icon: Images.alerts,
              label: "Notifications",
              onTap: () {
                _navigateToNotificationSettings(context);
              },
            ),
            BaseHeading(
              margin: EdgeInsets.only(left: Pad.pad16, top: Pad.pad20),
              title: "Help",
              titleStyle: styleBaseBold(fontSize: 20),
            ),
            MoreItem(
              icon: Images.moreFaqs,
              label: "FAQ’s",
              onTap: () {},
            ),
            MoreItem(
              icon: Images.moreContactUs,
              label: "Contact Us",
              onTap: () {},
            ),
            MoreItem(
              icon: Images.moreFeedback,
              label: "Feedback",
              onTap: () {},
            ),
            MoreItem(
              icon: Images.moreLegal,
              label: "Legal",
              onTap: () {},
            ),
            Visibility(
              visible: user != null,
              child: GestureDetector(
                onTap: () {
                  UserManager manager = context.read<UserManager>();
                  manager.logoutUser();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  margin: EdgeInsets.only(top: Pad.pad24, bottom: Pad.pad24),
                  padding: EdgeInsets.all(Pad.pad16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.moreLogout,
                        width: 32,
                        height: 32,
                        color: ThemeColors.neutral60,
                      ),
                      SpacerHorizontal(width: Pad.pad8),
                      Text(
                        "Logout",
                        style: styleBaseRegular(
                          fontSize: 16,
                          height: 1.2,
                          color: ThemeColors.neutral60,
                        ),
                      ),
                    ],
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
