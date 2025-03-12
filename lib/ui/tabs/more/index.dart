import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/legal/index.dart';
import 'package:stocks_news_new/ui/tabs/more/more_item.dart';
import 'package:stocks_news_new/ui/tabs/more/morningstarReport/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../../widgets/cache_network_image.dart';
import '../../base/logout.dart';

class MoreIndex extends StatelessWidget {
  const MoreIndex({super.key});
  @override
  Widget build(BuildContext context) {
    UserManager manager = context.watch<UserManager>();
    MyHomeManager homeManager = context.watch<MyHomeManager>();
    UserRes? user = manager.user;
    MyHomeRes? homeRes = homeManager.data;
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
                  Container(
                    margin: EdgeInsets.only(right: 10, bottom: 0),
                    child: user?.image == null || user?.image == ''
                        ? Image.asset(
                            Images.userPlaceholderNew,
                            height: 64,
                            width: 64,
                          )
                        : user?.imageType == 'svg'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: SvgPicture.network(
                                  height: 64,
                                  width: 64,
                                  user?.image ?? '',
                                  fit: BoxFit.cover,
                                  placeholderBuilder: (BuildContext context) =>
                                      Image.asset(
                                    height: 64,
                                    width: 64,
                                    Images.userPlaceholderNew,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: CachedNetworkImagesWidget(
                                  user?.image ?? '',
                                  height: 64,
                                  width: 64,
                                  placeHolder: Images.userPlaceholderNew,
                                  showLoading: true,
                                ),
                              ),
                  ),

                  SpacerVertical(height: Pad.pad8),
                  Text(
                    user?.name ?? 'Welcome Guest',
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
              onTap: manager.navigateToPersonalDetail,
            ),
            MoreItem(
              icon: Images.moreStockAlerts,
              label: "Stock Alerts",
              onTap: manager.navigateToAlerts,
            ),
            MoreItem(
              icon: Images.watchlist,
              label: "Watchlist",
              onTap: manager.navigateToWatchList,
            ),
            MoreItem(
              icon: Images.moreMySubscription,
              label: "My Subscription",
              onTap: () {
                manager.navigateToMySubscription(viewPlans: false);
              },
            ),
            if (homeRes?.showCrypto == true)
              MoreItem(
                icon: Images.crypto,
                label: "Cryptocurrencies",
                onTap: () {
                  manager.navigateToBillionaires();
                },
              ),
            MoreItem(
              icon: Images.msReport,
              label: "MORNINGSTAR Reports",
              onTap: () {
                Navigator.pushNamed(context, MorningStarReportsIndex.path);
              },
            ),

            MoreItem(
              icon: Images.moreMySubscription,
              label: "Refer a Friend",
              onTap: () {
                manager.navigateToReferral();
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
                manager.navigateToNews();
              },
            ),
            MoreItem(
              icon: Images.watchlist,
              label: "Blogs",
              onTap: () {
                manager.navigateToBlogs();
              },
            ),
            BaseHeading(
              margin: EdgeInsets.only(left: Pad.pad16, top: Pad.pad8),
              title: "Theme",
              titleStyle: styleBaseBold(fontSize: 20),
            ),
            MoreItem(
              icon: Images.theme,
              label: "Change Theme",
              onTap: () {},
            ),
            // BaseHeading(
            //   margin: EdgeInsets.only(left: Pad.pad16, top: Pad.pad20),
            //   title: "Settings",
            //   titleStyle: styleBaseBold(fontSize: 20),
            // ),
            // MoreItem(
            //   icon: Images.alerts,
            //   label: "Notifications",
            //   onTap: () {
            //     manager.navigateToNotificationSettings();
            //   },
            // ),
            BaseHeading(
              margin: EdgeInsets.only(left: Pad.pad16, top: Pad.pad20),
              title: "Help",
              titleStyle: styleBaseBold(fontSize: 20),
            ),
            MoreItem(
              icon: Images.moreFaqs,
              label: "FAQ’s",
              onTap: manager.navigateToFaq,
            ),
            MoreItem(
              icon: Images.moreContactUs,
              label: "Helpdesk",
              onTap: manager.navigateToHelpDesk,
            ),
            MoreItem(
              icon: Images.moreFeedback,
              label: "Feedback",
              onTap: manager.navigateToFeedback,
            ),
            MoreItem(
              icon: Images.moreLegal,
              label: "Legal",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  LegalInfoIndex.path,
                );
              },
            ),
            Visibility(
              visible: user != null,
              child: GestureDetector(
                onTap: () {
                  // UserManager manager = context.read<UserManager>();
                  // manager.logoutUser();
                  baseLogout();
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
