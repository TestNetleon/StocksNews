import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/benefits_items.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BenefitsMarketing extends StatelessWidget {
  const BenefitsMarketing({super.key});

  @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     HomeProvider provider = context.read<HomeProvider>();
  //     if (provider.benefitAnalysisRes == null) {
  //       context.read<HomeProvider>().getBenefitsDetails();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List images = [
      Images.share,
      Images.signin,
      Images.login,
      Images.profile,
      Images.signin,
      Images.profile,
      Images.share,
      Images.credit,
      Images.signin,
    ];
    List description = [
      'Earn points for every friend you refer who signs up using your referral link.',
      'Sign up today and receive bonus points as a welcome gift.',
      'Log in daily to earn points and keep your streak going.',
      'Complete your profile to earn points and unlock additional features.',
      'Purchase the Beginner Plan and earn points as a reward.',
      'Get rewarded with points when you purchase the Trader Plan.',
      'Earn bonus points with the purchase of the Ultimate Trader Plan.',
      'Achieve the Morning Star status and earn exclusive points.',
      'Sync your portfolio to our platform and get rewarded with points.',
    ];
    HomeProvider provider = context.watch<HomeProvider>();
    // Utils().showLog('helllllllllllll${provider.benefitAnalysisRes?.length}');
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(
        isPopback: true,
        showTrailing: true,
        canSearch: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenTitle(title: 'Referral Settings Data'),
              const SpacerVertical(height: 10.0),
              // ListView.separated(
              //   itemCount: provider.benefitAnalysisRes?.length ?? 0,
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   padding: EdgeInsets.only(top: 12.sp, left: 12.sp, right: 12.sp),
              //   itemBuilder: (context, index) {
              //     // Utils().showLog('Data lenght${provider?.length.toString()}');
              //     return Column(
              //       children: [
              //         if (index == 0)
              //           Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   AutoSizeText(
              //                     maxLines: 1,
              //                     "Nema",
              //                     style: stylePTSansRegular(
              //                       fontSize: 12,
              //                       color: ThemeColors.greyText,
              //                     ),
              //                   ),
              //                   const SpacerHorizontal(width: 10),
              //                   AutoSizeText(
              //                     maxLines: 1,
              //                     "Points",
              //                     style: stylePTSansRegular(
              //                       fontSize: 12,
              //                       color: ThemeColors.greyText,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               Divider(
              //                 color: ThemeColors.greyBorder,
              //                 height: 20.sp,
              //                 thickness: 1,
              //               )
              //             ],
              //           ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Expanded(
              //               child: Text(
              //                 "${provider.benefitAnalysisRes?[index].key}",
              //                 style: stylePTSansRegular(
              //                     color: ThemeColors.white, fontSize: 13),
              //               ),
              //             ),
              //             Text(
              //               "${provider.benefitAnalysisRes?[index].point}",
              //               style: stylePTSansRegular(
              //                   color: ThemeColors.white, fontSize: 13),
              //             ),
              //           ],
              //         ),
              //       ],
              //     );
              //   },
              //   separatorBuilder: (BuildContext context, int index) {
              //     return const Divider(
              //       color: ThemeColors.greyBorder,
              //       height: 15,
              //     );
              //   },
              // ),
              //-------copy data
              ListView.separated(
                itemCount: provider.benefitAnalysisRes?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // padding: EdgeInsets.only(left: 12.sp, right: 12.sp),
                itemBuilder: (context, index) {
                  SdBenefitAnalyst? data = provider.benefitAnalysisRes?[index];
                  return Column(
                    children: [
                      AnalysisBenefitItem(
                        description: description[index],
                        images: images[index],
                        data: data,
                        //isOpen: provider.openIndexbenefit == index,
                        onTap: () {},
                      ),
                      const SpacerVertical(height: 8),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: ThemeColors.greyBorder,
                    height: 15,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
