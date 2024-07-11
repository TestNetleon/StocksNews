import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HowToSpend extends StatefulWidget {
  final String? images;
  final String? description;
  final Function() onTap;

  const HowToSpend({
    required this.onTap,
    super.key,
    this.images,
    this.description,
  });

  @override
  State<HowToSpend> createState() => _HowToSpendState();
}

class _HowToSpendState extends State<HowToSpend> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeProvider homeProvider = context.read<HomeProvider>();
      if (homeProvider.benefitRes == null) {
        homeProvider.getBenefitsDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    Earn? spend = provider.benefitRes?.spend;

    List<String> images = [
      Images.referAndEarn,
      Images.signup,
      Images.login,
      Images.profile,
      Images.bg,
    ];

    return BaseUiContainer(
      hasData: !provider.isLoadingBenefits && provider.benefitRes != null,
      isLoading: provider.isLoadingBenefits,
      error: provider.error,
      showPreparingText: true,
      isFull: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  spend?.title ?? "",
                  style: stylePTSansRegular(
                    color: ThemeColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SpacerVertical(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  spend?.subTitle ?? "",
                  style: stylePTSansRegular(
                    color: ThemeColors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SpacerVertical(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.2, 0.65],
                          colors: [
                            Color.fromARGB(255, 204, 56, 19),
                            Color.fromARGB(255, 39, 37, 37),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 14, 41, 0),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
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
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color.fromARGB(255, 204, 56, 19),
                                            Color.fromARGB(255, 169, 29, 4),
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        spend?.banner.title ?? "",
                                        style: stylePTSansRegular(
                                          color: ThemeColors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SpacerVertical(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        spend?.banner.subTitle ?? "",
                                        style: stylePTSansRegular(
                                          color: const Color.fromARGB(
                                            255,
                                            252,
                                            252,
                                            252,
                                          ),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SpacerVertical(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 25.0,
                                      ),
                                      child: Text(
                                        spend?.banner.text ?? "",
                                        style: stylePTSansRegular(
                                          color: ThemeColors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    // const SpacerVertical(height: 8),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SpacerVertical(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.white),
                          ),
                          child: ListView.separated(
                            itemCount:
                                provider.benefitRes?.spend.points.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 12.sp),
                            itemBuilder: (context, index) {
                              Point? data =
                                  provider.benefitRes?.spend.points[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0)
                                    const SpacerVertical(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
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
                                              style:
                                                  styleSansBold(fontSize: 14),
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
                                    ],
                                  ),
                                  const SpacerVertical(height: 3),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                color: Colors.black12,
                                height: 20,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
