import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/affiliate/referFriend/howit_work.dart';
import 'package:stocks_news_new/screens/affiliate/referFriend/suspend.dart';
import 'package:stocks_news_new/screens/affiliate/referFriend/widget/points_summary.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../modals/affiliate/refer_friend_res.dart';
import '../../../providers/home_provider.dart';
import '../../../route/my_app.dart';
import '../../../utils/constants.dart';
import '../../../widgets/spacer_vertical.dart';
import 'item.dart';

class AffiliateReferFriend extends StatefulWidget {
  const AffiliateReferFriend({super.key});

  @override
  State<AffiliateReferFriend> createState() => _AffiliateReferFriendState();
}

class _AffiliateReferFriendState extends State<AffiliateReferFriend> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  _callAPI() {
    LeaderBoardProvider provider = context.read<LeaderBoardProvider>();
    provider.getReferData();
    // if (provider.data == null || provider.data?.isEmpty == true) {
    // }
  }

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    return BaseUiContainer(
      hasData: true,
      isLoading: provider.isLoading,
      error: provider.error,
      showPreparingText: true,
      isFull: true,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          provider.getReferData();
        },
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ReferFriendSuspend(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Refer your friends, You Win",
                            style: stylePTSansBold(
                              // color: ThemeColors.greyText,
                              fontSize: 25,
                            ),
                          ),
                          const SpacerVertical(height: 5),
                          Text(
                            provider.extra?.affiliateReferText ?? "",
                            style: stylePTSansRegular(
                                color: ThemeColors.greyText,
                                fontSize: 16,
                                height: 1.3),
                          ),
                        ],
                      ),
                      const SpacerVertical(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: const Color.fromARGB(255, 29, 29, 29),
                          ),
                          color: const Color.fromARGB(255, 17, 17, 17),
                        ),
                        child: Column(
                          children: [
                            // Text(
                            //   provider.extra?.affiliateReferText ?? "",
                            //   textAlign: TextAlign.center,
                            //   style: stylePTSansRegular(color: ThemeColors.greyText),
                            // ),
                            // const SpacerVertical(height: 15),
                            GestureDetector(
                              onTap: () {
                                // Share.share(
                                //   "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                                // );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 25, 25, 25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Referral Code",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: stylePTSansBold(),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${userProvider.user?.referralCode}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: stylePTSansBold(),
                                        ),
                                        const SpacerHorizontal(width: 8),
                                        // const Icon(
                                        //   Icons.copy_outlined,
                                        //   size: 18,
                                        // )
                                      ],
                                    ),
                                    // const SpacerHorizontal(width: 15),
                                    // Text(
                                    //   "${userProvider.user?.referralCode}",
                                    //   maxLines: 1,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: stylePTSansRegular(),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            const SpacerVertical(height: 12),
                            GestureDetector(
                              onTap: () {
                                // Share.share(
                                //   "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                                // );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 25, 25, 25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${shareUri ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: stylePTSansBold(),
                                    ),
                                    // const Icon(
                                    //   Icons.copy_outlined,
                                    //   size: 18,
                                    // )
                                  ],
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 15, vertical: 8.9),
                            //   decoration: const BoxDecoration(
                            //     color: Color.fromARGB(255, 69, 69, 69),
                            //     borderRadius: BorderRadius.only(
                            //         bottomRight: Radius.circular(4),
                            //         topRight: Radius.circular(4)),
                            //   ),
                            //   child: const Icon(
                            //     Icons.copy,
                            //     size: 20,
                            //   ),
                            // ),
                            const SpacerVertical(height: 12),
                            ThemeButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.share),
                                  const SpacerHorizontal(width: 6),
                                  Flexible(
                                    child: Text(
                                      "Share with Friends",
                                      style: stylePTSansBold(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Share.share(
                                  "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SpacerVertical(height: 15),
                      Visibility(
                        visible: (provider.data?.isEmpty == true ||
                                provider.data == null) &&
                            (provider.extra?.totalActivityPoints ?? 0) == 0,
                        child: Column(
                          children: [
                            ScreenTitle(
                              title: homeProvider.extra?.howItWork?.title ?? "",
                              dividerPadding: EdgeInsets.zero,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 29, 29, 29),
                                ),
                                color: const Color.fromARGB(255, 17, 17, 17),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                // padding: const EdgeInsets.only(bottom: 10),
                                itemBuilder: (context, index) {
                                  StepRes? data = homeProvider
                                      .extra?.howItWork?.steps?[index];
                                  return HowItWorkItem(
                                    colorKey:
                                        const Color.fromARGB(255, 77, 77, 77),
                                    index: index,
                                    data: data,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    color: Color.fromARGB(255, 56, 56, 56),
                                    height: 25,
                                  );
                                },
                                itemCount: homeProvider
                                        .extra?.howItWork?.steps?.length ??
                                    0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PointsSummary(),
                      const SpacerVertical(height: 15),
                      Visibility(
                        visible: provider.data?.isNotEmpty == true &&
                            provider.data != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SpacerVertical(height: 20),
                            ScreenTitle(
                              title: "Friends Joined",
                              subTitle: provider.extra?.earnCondition ?? "",
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 10),
                              itemBuilder: (context, index) {
                                AffiliateReferRes? data = provider.data?[index];
                                return AffiliateReferItem(
                                  index: index,
                                  data: data,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SpacerVertical(height: 16);
                              },
                              itemCount: provider.data?.length ?? 0,
                            ),
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
    );
  }
}
