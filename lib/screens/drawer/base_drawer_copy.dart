// import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet_tablet.dart';
import 'package:stocks_news_new/screens/drawer/widgets/drawer_new_widget.dart';
import 'package:stocks_news_new/screens/drawer/widgets/drawer_top_new.dart';
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
import '../myAccount/my_account.dart';
import '../t&cAndPolicy/tc_policy.dart';
import '../watchlist/watchlist.dart';
import 'widgets/drawer_lists.dart';
import 'widgets/drawer_more_service.dart';
import 'widgets/profile_image.dart';
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
                  const DrawerTopNew(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SpacerVertical(height: 30),
                          Text(
                            "Welcome to stocks.news",
                            style: stylePTSansBold(fontSize: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 5.sp,
                            ),
                            child: Text(
                              "${provider.homeSliderRes?.text.drawerHeader}",
                              style: stylePTSansRegular(
                                  fontSize: 13, color: ThemeColors.greyText),
                            ),
                          ),
                          const SpacerVertical(height: 20),

                          Visibility(
                            visible: userProvider.user != null,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, MyAccount.path);
                              },
                              child: Row(
                                children: [
                                  ProfileImage(
                                    url: userProvider.user?.image,
                                    cameraSize: 12,
                                  ),
                                  const SpacerHorizontal(width: 10),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userProvider.user?.name?.isNotEmpty ==
                                                true
                                            ? "${userProvider.user?.name}"
                                            : "Update your account",
                                        style: stylePTSansBold(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        userProvider.user?.email?.isNotEmpty ==
                                                true
                                            ? "${userProvider.user?.email}"
                                            : "Update your account",
                                        style: stylePTSansRegular(
                                            color: ThemeColors.greyText,
                                            fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: userProvider.user == null,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ThemeButtonSmall(
                                    showArrow: false,
                                    text: "Log in",
                                    onPressed: () {
                                      Scaffold.of(context).closeDrawer();
                                      isPhone
                                          ? loginSheet(dontPop: "true")
                                          : loginSheetTablet(dontPop: "true");
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
                                          ? signupSheet(dontPop: "true")
                                          : signupSheetTablet(dontPop: "true");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: ThemeColors.greyBorder, height: 40.sp),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Scaffold.of(context).closeDrawer();
                                  Navigator.pushNamed(context, Alerts.path);
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
                                    )
                                  ],
                                ),
                              ),
                              const SpacerHorizontal(width: 40),
                              InkWell(
                                onTap: () {
                                  Scaffold.of(context).closeDrawer();
                                  Navigator.pushNamed(context, WatchList.path);
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

                          Text(
                            "Market Data",
                            style: stylePTSansBold(),
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
                                  icon: marketData[index].iconData,
                                  text: marketData[index].text,
                                ),
                              );
                            },
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20.sp),
                              onTap: () {
                                easeOutBuilder(context,
                                    child: const DrawerMoreService());
                              },
                              child: Ink(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.sp, vertical: 5.sp),
                                decoration: BoxDecoration(
                                    color:
                                        ThemeColors.greyBorder.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20.sp),
                                    border: Border.all(
                                        color: ThemeColors.greyBorder)),
                                child: Text(
                                  "More services",
                                  style: stylePTSansRegular(
                                      fontSize: 12, color: ThemeColors.white),
                                ),
                              ),
                            ),
                          ),
                          const SpacerVertical(height: 20),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(4.sp),
                            child: Ink(
                              decoration: BoxDecoration(
                                  color:
                                      ThemeColors.greyBorder.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4.sp)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
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
                                    "About stocks.news",
                                    style: stylePTSansRegular(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SpacerVertical(height: 20),
                          // Divider(
                          //   color: ThemeColors.greyBorder,
                          //   height: 20.sp,
                          // ),
                          Align(
                            alignment: Alignment.center,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Disclaimer,',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Scaffold.of(context).closeDrawer();
                                          Navigator.push(
                                            context,
                                            createRoute(
                                              const TCandPolicy(
                                                policyType:
                                                    PolicyType.disclaimer,
                                              ),
                                            ),
                                          );
                                        },
                                      style: stylePTSansRegular(fontSize: 13)),
                                  TextSpan(
                                      text: ' Privacy Policy ',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Scaffold.of(context).closeDrawer();
                                          Navigator.push(
                                            context,
                                            createRoute(
                                              const TCandPolicy(
                                                policyType: PolicyType.privacy,
                                              ),
                                            ),
                                          );
                                        },
                                      style: stylePTSansRegular(fontSize: 13)),
                                  TextSpan(
                                      text: 'and',
                                      style: stylePTSansRegular(
                                          fontSize: 13,
                                          color: ThemeColors.greyText)),
                                  TextSpan(
                                      text: ' Terms of Service',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Scaffold.of(context).closeDrawer();
                                          Navigator.push(
                                            context,
                                            createRoute(
                                              const TCandPolicy(
                                                policyType: PolicyType.tC,
                                              ),
                                            ),
                                          );
                                        },
                                      style: stylePTSansRegular(fontSize: 13)),
                                ],
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Scaffold.of(context).closeDrawer();
                                    Navigator.push(
                                      context,
                                      createRoute(
                                        const TCandPolicy(
                                          policyType: PolicyType.privacy,
                                        ),
                                      ),
                                    );
                                  },
                                text: "Read our ",
                                style: stylePTSansRegular(
                                    fontSize: 13, color: ThemeColors.greyText),
                              ),
                            ),
                          ),
                          const SpacerVertical(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "App Version: $version",
                              style: stylePTSansRegular(
                                fontSize: 13,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          ),
                          const SpacerVertical(height: 20),
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
              height: 50,
              decoration: const BoxDecoration(
                color: ThemeColors.accent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 11,
              ),
            ),
          )
        ],
      ),
    );
  }
}
