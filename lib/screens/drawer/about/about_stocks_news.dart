import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/drawer/about/tile.dart';
import 'package:stocks_news_new/screens/drawer/widgets/drawer_lists.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../widgets/drawer_top_new.dart';

class AboutStocksNews extends StatelessWidget {
  final String version;
  const AboutStocksNews({super.key, required this.version});

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
                  "App Version: $version",
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
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 30.sp),
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
              const SpacerVertical(height: 30),
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
