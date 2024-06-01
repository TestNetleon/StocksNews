import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/drawer/about/tile.dart';
import 'package:stocks_news_new/screens/drawer/widgets/drawer_lists.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/logout.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../widgets/drawer_top_new.dart';

class AboutStocksNews extends StatefulWidget {
  final String version;
  const AboutStocksNews({super.key, required this.version});

  @override
  State<AboutStocksNews> createState() => _AboutStocksNewsState();
}

class _AboutStocksNewsState extends State<AboutStocksNews> {
  bool userPresent = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void _getData() async {
    UserProvider provider = context.read<UserProvider>();
    if (await provider.checkForUser()) {
      userPresent = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const DrawerTopNew(
                text: "About stocks.news",
              ),
              const SpacerVertical(height: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.sp),
                  child: Image.asset(
                    Images.stockIcon,
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
              const SpacerVertical(height: 10),
              Text(
                "Stocks News",
                style: stylePTSansRegular(color: ThemeColors.white),
              ),
              const SpacerVertical(height: 5),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "App Version: ${widget.version}",
                  style: stylePTSansRegular(
                    fontSize: 13,
                    color: ThemeColors.greyText,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
                child: const Column(
                  children: [],
                ),
              ),
              ListView.separated(
                padding: EdgeInsets.only(
                  left: 10.sp,
                  right: 10.sp,
                  top: 30.sp,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AboutTile(
                      index: index, onTap: aboutTiles[index].onTap);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox();
                },
                itemCount: aboutTiles.length,
              ),
              Visibility(
                  visible: !userPresent, child: SpacerVertical(height: 30.sp)),
              Visibility(
                visible: userPresent,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.sp,
                    right: 10.sp,
                    bottom: 30.sp,
                  ),
                  child: Column(
                    children: [
                      Ink(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50.sp),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.sp),
                          onTap: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return const LogoutDialog();
                            //   },
                            // );
                            logoutPopUp();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 6.sp),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 2.sp),
                                  child: const Icon(
                                    Icons.logout_outlined,
                                    size: 20,
                                    color: ThemeColors.sos,
                                  ),
                                ),
                                const SpacerHorizontal(width: 20),
                                Expanded(
                                  child: Text('Logout',
                                      style: stylePTSansBold(
                                          fontSize: 14,
                                          color: ThemeColors.sos)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(color: ThemeColors.greyBorder, height: 5.sp),
                    ],
                  ),
                ),
              ),
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
                              Navigator.push(
                                context,
                                createRoute(
                                  const TCandPolicy(
                                    policyType: PolicyType.disclaimer,
                                  ),
                                ),
                              );
                            },
                          style: stylePTSansRegular(fontSize: 13)),
                      TextSpan(
                          text: ' Privacy Policy ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
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
                              fontSize: 13, color: ThemeColors.greyText)),
                      TextSpan(
                          text: ' Terms of Service',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
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
              const SpacerVertical(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
