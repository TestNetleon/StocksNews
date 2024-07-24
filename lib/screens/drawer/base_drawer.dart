// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
import 'package:stocks_news_new/screens/drawer/about/about_stocks_news.dart';
import 'package:stocks_news_new/screens/drawer/widgets/drawer_new_widget.dart';
import 'package:stocks_news_new/screens/drawer/widgets/user_card.dart';
import 'package:stocks_news_new/screens/membership/store/store.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_gridview.dart';
import '../../widgets/theme_button_small.dart';
import '../alerts/alerts.dart';
import '../watchlist/watchlist.dart';
import 'widgets/drawer_lists.dart';
// import '../t&cAndPolicy/tc_policy.dart';

class BaseDrawer extends StatefulWidget {
  final bool resetIndex;
  const BaseDrawer({super.key, this.resetIndex = false});

  @override
  State<BaseDrawer> createState() => _BaseDrawerState();
}

class _BaseDrawerState extends State<BaseDrawer> {
  String? version;
  bool showMore = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void _getData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    return SafeArea(
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Drawer(
            backgroundColor: ThemeColors.background,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // const DrawerTopNew(),
                  const SpacerVertical(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SpacerVertical(height: 30),
                          Visibility(
                            visible: userProvider.user == null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome to Stocks.News",
                                  style: stylePTSansBold(fontSize: 20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5.sp),
                                  child: Text(
                                    provider.homeSliderRes?.text
                                            ?.drawerHeader ??
                                        "",
                                    style: stylePTSansRegular(
                                      fontSize: 13,
                                      color: ThemeColors.greyText,
                                    ),
                                  ),
                                ),
                                const SpacerVertical(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ThemeButtonSmall(
                                        showArrow: false,
                                        text: "Log in",
                                        onPressed: () {
                                          Scaffold.of(context).closeDrawer();
                                          isPhone
                                              ? loginSheet()
                                              : loginSheetTablet();
                                        },
                                      ),
                                    ),
                                    const SpacerHorizontal(width: 10),
                                    Expanded(
                                      child: ThemeButtonSmall(
                                        showArrow: false,
                                        text: "Sign up",
                                        onPressed: () {
                                          Scaffold.of(context).closeDrawer();
                                          isPhone
                                              ? signupSheet()
                                              : signupSheetTablet(
                                                  dontPop: "true");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: userProvider.user != null,
                            child: UserCard(
                              onTap: () {
                                easeOutBuilder(
                                  context,
                                  child:
                                      AboutStocksNews(version: version ?? ""),
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: !(userProvider.user != null &&
                                userProvider.user?.membership?.purchased == 1),
                            child: Divider(
                              color: ThemeColors.greyBorder,
                              height: 40.sp,
                            ),
                          ),
                          Visibility(
                            visible: userProvider.user != null &&
                                userProvider.user?.membership?.purchased == 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Store(),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: 15,
                                  top: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: ThemeColors.tabBack,
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 65, 171, 83),
                                      Color.fromARGB(255, 1, 122, 44),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      top: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          Images.pointWithStar,
                                          height: 60,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.store, size: 40),
                                          const SpacerHorizontal(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  provider.extra?.storeTitle ??
                                                      "",
                                                  style: stylePTSansBold(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SpacerVertical(height: 3),
                                                Text(
                                                  provider.extra
                                                          ?.storeSubTitle ??
                                                      "",
                                                  style: stylePTSansRegular(
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Scaffold.of(context).closeDrawer();
                                  Navigator.push(
                                    navigatorKey.currentContext!,
                                    MaterialPageRoute(
                                      builder: (_) => const Alerts(),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.add_alert_outlined,
                                      size: 22,
                                    ),
                                    const SpacerVertical(height: 5),
                                    Text(
                                      "${provider.totalAlerts}",
                                      style: stylePTSansBold(),
                                    ),
                                    const SpacerVertical(height: 5),
                                    Text(
                                      provider.totalAlerts == 1
                                          ? "Stock Alert"
                                          : "Stock Alerts",
                                      style: stylePTSansRegular(
                                          fontSize: 13,
                                          color: const Color.fromARGB(
                                              255, 184, 187, 193)),
                                    ),
                                  ],
                                ),
                              ),
                              const SpacerHorizontal(width: 40),
                              InkWell(
                                onTap: () {
                                  Scaffold.of(context).closeDrawer();
                                  Navigator.push(
                                    navigatorKey.currentContext!,
                                    MaterialPageRoute(
                                        builder: (_) => const WatchList()),
                                  );
                                },
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.star_border,
                                      size: 22,
                                    ),
                                    const SpacerVertical(height: 5),
                                    Text(
                                      "${provider.totalWatchList}",
                                      style: stylePTSansBold(),
                                    ),
                                    const SpacerVertical(height: 5),
                                    Text(
                                      "Stock Watchlist",
                                      style: stylePTSansRegular(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 184, 187, 193),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SpacerVertical(height: 15),
                          // Text(
                          //   "Market Data",
                          //   style: stylePTSansBold(),
                          // ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ThemeColors.greyBorder.withOpacity(0.2),
                            ),
                            child: Text(
                              "Market Data",
                              textAlign: TextAlign.center,
                              style: stylePTSansBold(),
                            ),
                          ),
                          CustomGridViewPerChild(
                            paddingHorizontal: 5,
                            paddingVertical: 25,
                            childrenPerRow: 3,
                            length: marketData.length,
                            getChild: (index) {
                              return InkWell(
                                onTap: marketData[index].onTap,
                                child: DrawerNewWidget(
                                  image: marketData[index].icon,
                                  icon: marketData[index].iconData,
                                  text: marketData[index].text,
                                ),
                              );
                            },
                          ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: InkWell(
                          //     borderRadius: BorderRadius.circular(20.sp),
                          //     onTap: () {
                          //       easeOutBuilder(context,
                          //           child: const DrawerMoreService());
                          //     },
                          //     child: Ink(
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal: 10.sp, vertical: 5.sp),
                          //       decoration: BoxDecoration(
                          //           color:
                          //               ThemeColors.greyBorder.withOpacity(0.2),
                          //           borderRadius: BorderRadius.circular(20.sp),
                          //           border: Border.all(
                          //               color: ThemeColors.greyBorder)),
                          //       child: Text(
                          //         "More services",
                          //         style: stylePTSansRegular(
                          //             fontSize: 12, color: ThemeColors.white),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const SpacerVertical(height: 20),
                          InkWell(
                            onTap: () {
                              easeOutBuilder(
                                context,
                                child: AboutStocksNews(version: version ?? ""),
                              );
                            },
                            borderRadius: BorderRadius.circular(4.sp),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: ThemeColors.greyBorder.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4.sp),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    Images.info,
                                    height: 20,
                                    width: 20,
                                    color: ThemeColors.white,
                                  ),
                                  const SpacerHorizontal(width: 8),
                                  Text(
                                    "About Stocks.News",
                                    style: stylePTSansRegular(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SpacerVertical(height: 20),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //       navigatorKey.currentContext!,
                          //       MaterialPageRoute(
                          //         builder: (_) => const BarChartSample(),
                          //       ),
                          //     );
                          //   },
                          //   borderRadius: BorderRadius.circular(4.sp),
                          //   child: Ink(
                          //     decoration: BoxDecoration(
                          //       color: ThemeColors.greyBorder.withOpacity(0.2),
                          //       borderRadius: BorderRadius.circular(4.sp),
                          //     ),
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 10,
                          //       vertical: 10,
                          //     ),
                          //     child: Row(
                          //       children: [
                          //         Image.asset(
                          //           Images.info,
                          //           height: 20,
                          //           width: 20,
                          //           color: ThemeColors.white,
                          //         ),
                          //         const SpacerHorizontal(width: 8),
                          //         Text(
                          //           "Pie Chart",
                          //           style: stylePTSansRegular(fontSize: 13),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Scaffold.of(context).closeDrawer();
            },
            child: Container(
              width: 11,
              height: 70,
              decoration: const BoxDecoration(
                color: ThemeColors.accent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
