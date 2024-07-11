import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AnalysisBenefitItem extends StatelessWidget {
  final String? images;
  final String? description;
  final Function() onTap;

  const AnalysisBenefitItem({
    required this.onTap,
    super.key,
    this.images,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    List<String> images = [
      Images.referAndEarn,
      Images.signup,
      Images.login,
      Images.profile,
      Images.portfolio,
      Images.beginnerPlan,
      Images.traderPlan,
      // Images.ultimatePlan,
      Images.bg,
    ];
    // List description = [
    //   'Earn points for every friend you refer who signs up using your referral link.',
    //   'Sign up today and receive bonus points as a welcome gift.',
    //   'Log in daily to earn points and keep your streak going.',
    //   'Complete your profile to earn points and unlock additional features.',
    //   'Purchase the Beginner Plan and earn points as a reward.',
    //   'Get rewarded with points when you purchase the Trader Plan.',
    //   'Earn bonus points with the purchase of the Ultimate Trader Plan.',
    //   'Achieve the Morning Star status and earn exclusive points.',
    //   'Sync your portfolio to our platform and get rewarded with points.',
    // ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                'Earn More with Our Affiliate Program!',
                style: stylePTSansRegular(
                    color: ThemeColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SpacerVertical(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "Discover How Easy It Is to Earn Reward Points for Every Action You Take",
                style:
                    stylePTSansRegular(color: ThemeColors.white, fontSize: 14),
              ),
            ),
            const SpacerVertical(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1.14,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius:
                      BorderRadius.circular(10.0)), // Adjust as needed
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.2, 0.65],
                          colors: [
                            Color.fromARGB(255, 32, 128, 65),
                            Color.fromARGB(255, 39, 37, 37),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 14, 41, 0),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Image.asset(
                            Images.reward,
                            height: 80.0,
                            width: 100.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SpacerVertical(height: 8),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    stops: [0.3, 0.65],
                                    colors: [
                                      Color.fromARGB(255, 32, 128, 65),
                                      Color.fromARGB(255, 11, 85, 37),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  "Start earning points right from your first action.",
                                  style: stylePTSansRegular(
                                    color: ThemeColors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SpacerVertical(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "Climb the Stages and Unlock Exclusive Benefits!",
                                  style: stylePTSansRegular(
                                      color: ThemeColors.lightGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SpacerVertical(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 25.0),
                                child: Text(
                                  "The more you engage, the more you earn – it's that simple!",
                                  style: stylePTSansRegular(
                                      color: ThemeColors.white, fontSize: 14),
                                ),
                              ),
                              const SpacerVertical(height: 8),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 180.0),
                              //   child: Text(
                              //     "T&C Apply",
                              //     textAlign: TextAlign.right,
                              //     style: stylePTSansRegular(
                              //         color: ThemeColors.white, fontSize: 10),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 150, // Adjust as needed
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.white),
                      ),
                      padding: EdgeInsets.only(left: 10.0),
                      child: ListView.separated(
                        itemCount: provider.benefitAnalysisRes?.length ?? 0,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 12.sp),
                        itemBuilder: (context, index) {
                          SdBenefitAnalyst? data =
                              provider.benefitAnalysisRes?[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0) const SpacerVertical(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Image.asset(
                                      images[index],
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  const SpacerHorizontal(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data?.key}",
                                          style: styleSansBold(fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SpacerVertical(height: 5),
                                        Text(
                                          "${data?.text}",
                                          overflow: TextOverflow.fade,
                                          style: stylePTSansRegular(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SpacerHorizontal(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, top: 15),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ThemeColors.darkGreen,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(
                                          data?.point.toString() ?? "",
                                          style: styleSansBold(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SpacerVertical(height: 3),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            color: Colors.black12,
                            height: 20,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
