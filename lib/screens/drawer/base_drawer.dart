import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/drawer_res.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/screens/auth/login/login.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us.dart';
import 'package:stocks_news_new/screens/drawer/widgets/back_press.dart';
import 'package:stocks_news_new/screens/drawer/widgets/profile_image.dart';
import 'package:stocks_news_new/screens/drawer/widgets/tile_widget.dart';
import 'package:stocks_news_new/screens/faq/index.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/screens/stocks/index.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
import 'package:stocks_news_new/screens/trendingIndustries/index.dart';
// import 'package:stocks_news_new/screens/whatWeDo/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/logout.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
//
import '../watchlist/watchlist.dart';

class BaseDrawer extends StatefulWidget {
  final bool resetIndex;
  const BaseDrawer({super.key, this.resetIndex = true});

  @override
  State<BaseDrawer> createState() => _BaseDrawerState();
}

class _BaseDrawerState extends State<BaseDrawer> {
  String? version;
  bool userPresent = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
      widget.resetIndex ? _resetIndex() : null;
    });
  }

  void _getData() async {
    UserProvider provider = context.read<UserProvider>();
    if (await provider.checkForUser()) {
      userPresent = true;
      setState(() {});
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }

  void _resetIndex() {
    for (var i = 0; i < drawerItems.length; i++) {
      drawerItems[i].isSelected = false;
    }
    setState(() {});
  }

  Widget _itemsWidget() {
    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return DrawerTileWidget(
            index: index,
            onTap: () => _onitemTap(index: index),
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerVertical(height: 0);
        },
        itemCount: drawerItems.length);
  }

  // _onitemTap({required int index}) {
  //   Navigator.pop(context);
  //   if (!drawerItems[index].isSelected) {
  //     setState(() {
  //       for (int i = 0; i < drawerItems.length; i++) {
  //         drawerItems[i].isSelected = (i == index);
  //       }
  //     });
  //     // List<String> paths = [
  //     //   Notifications.path,
  //     // ];
  //     // String path = paths[index];

  //     // Navigator.pushNamed(context, path);
  //     switch (index) {
  //       case 0:
  //         break;
  //       case 1:
  //         Navigator.pushNamed(context, StocksIndex.path);

  //         break;
  //       case 2:
  //         Navigator.pushNamed(context, MyAccount.path);

  //         break;
  //       case 3:
  //         Navigator.pushNamed(context, TrendingIndustries.path);
  //         break;

  //       case 4:
  //         Navigator.pushNamed(context, Alerts.path);
  //         break;
  //       case 5:
  //         Navigator.pushNamed(context, WatchList.path);
  //         break;
  //       case 6:
  //         Navigator.pushNamed(context, Notifications.path);
  //         break;
  //       case 7:
  //         Navigator.pushNamed(context, FAQ.path);
  //         break;
  //       case 8:
  //         Navigator.pushNamed(context, ContactUs.path);
  //         break;
  //       case 9:
  //         Navigator.pushNamed(context, TCandPolicy.path,
  //             arguments: PolicyType.tC);
  //         break;
  //       case 10:
  //         Navigator.pushNamed(context, TCandPolicy.path,
  //             arguments: PolicyType.privacy);
  //         break;
  //       case 11:
  //         Navigator.pushNamed(context, IndexBlog.path);
  //         break;
  //       default:
  //     }
  //   }
  // }

  _onitemTap({required int index}) {
    Navigator.pop(context);

    if (drawerItems[index].isSelected) {
      return; // Do nothing if the item is already selected
    }

    setState(() {
      for (var item in drawerItems) {
        item.isSelected = false;
      }
      drawerItems[index].isSelected = true;
    });

    // Define a map to store the routes based on the index
    Map<int, String> routes = {
      1: StocksIndex.path,
      2: Alerts.path,
      3: WatchList.path,
      4: TrendingIndustries.path,
      5: Notifications.path,
      6: MyAccount.path,
      7: FAQ.path,
      8: TCandPolicy.path,
      9: ContactUs.path,
      10: TCandPolicy.path,
      11: TCandPolicy.path,
      12: TCandPolicy.path,
      13: IndexBlog.path,
      // 14: WhatWeDoIndex.path,
    };

    // Check if the index is within the valid range
    if (index >= 1 && index <= 13) {
      String path = routes[index]!;
      if (index == 8 || index == 10 || index == 11 || index == 12) {
        Navigator.pushNamed(
          context,
          path,
          arguments: index == 8
              ? PolicyType.aboutUs
              : index == 10
                  ? PolicyType.tC
                  : index == 11
                      ? PolicyType.privacy
                      : PolicyType.disclaimer,
        );
      } else {
        Navigator.pushNamed(context, path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserRes? user = context.watch<UserProvider>().user;
    return SafeArea(
      child: Drawer(
        width: ScreenUtil().screenWidth / 1.2,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SpacerVertical(height: 40),
              !userPresent
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Please log in to continue",
                          style: stylePTSansRegular(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SpacerVertical(height: 10),
                        ThemeButtonSmall(
                          onPressed: () {
                            // Navigator.pushNamed(context, Login.path);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                createRoute(const Login(
                                  dontPop: "true",
                                )));
                          },
                          text: "Log in",
                          showArrow: false,
                          // fullWidth: false,
                        )
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 20.sp),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, MyAccount.path);
                        },
                        child: Row(
                          children: [
                            ProfileImage(
                              url: user?.image,
                              cameraSize: 12,
                            ),
                            const SpacerHorizontal(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name?.isNotEmpty == true
                                      ? "${user?.name}"
                                      : "Update your account",
                                  style: stylePTSansBold(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  user?.email?.isNotEmpty == true
                                      ? "${user?.email}"
                                      : "Update your account",
                                  style: stylePTSansRegular(
                                      color: ThemeColors.greyText,
                                      fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )),
                            const SpacerHorizontal(width: 10),
                            const DrawerBackpress(),
                          ],
                        ),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.sp,
                  vertical: 20.sp,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                        color: ThemeColors.greyText,
                        height: 20.sp,
                        thickness: 1),
                    // TextInputFieldSearchCommon(
                    //   openConstraints: false,
                    //   contentPadding: EdgeInsets.symmetric(
                    //     horizontal: 20.sp,
                    //     vertical: 18.sp,
                    //   ),
                    //   radius: 30,
                    //   hintText: "Search Symbols",
                    //   searching: context.watch<SearchProvider>().isLoading,
                    //   onChanged: (text) {},
                    // ),
                    _itemsWidget(),
                    const SpacerVertical(height: 10),
                    Visibility(
                      visible: userPresent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.sp),
                          border: Border.all(
                              color: ThemeColors.greyBorder.withOpacity(0.5),
                              width: 2.sp),
                        ),
                        padding: EdgeInsets.all(4.sp),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.sp),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const LogoutDialog();
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.sp, vertical: 6.sp),
                            decoration: BoxDecoration(
                              color: ThemeColors.greyBorder.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30.sp),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.power_settings_new_rounded,
                                    size: 20.sp),
                                const SpacerHorizontal(width: 5),
                                Text(
                                  "Logout",
                                  style: stylePTSansBold(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SpacerVertical(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Version: $version",
                        style: stylePTSansRegular(
                            fontSize: 10, color: ThemeColors.greyText),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     context.read<UserProvider>().logout();
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: ThemeColors.primaryLight),
                    //       borderRadius: BorderRadius.circular(30.sp),
                    //     ),
                    //     padding: EdgeInsets.all(3.sp),
                    //     margin: EdgeInsets.only(
                    //       left: 10.sp,
                    //       top: 20.sp,
                    //     ),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         color: ThemeColors.primaryLight,
                    //         borderRadius: BorderRadius.circular(30.sp),
                    //       ),
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 8,
                    //         vertical: 4,
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           const Icon(Icons.power_settings_new_rounded),
                    //           const SpacerHorizontal(width: 8),
                    //           Text(
                    //             "Log Out",
                    //             style: stylePTSansBold(fontSize: 14),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
