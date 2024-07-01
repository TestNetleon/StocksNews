import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/screens/affiliate/referFriend/howit_work.dart';
import 'package:stocks_news_new/screens/affiliate/referFriend/suspend.dart';
import 'package:stocks_news_new/screens/affiliate/referFriend/trasnsaction.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom/toast.dart';
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
              children: [
                const ReferFriendSuspend(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: const EdgeInsets.symmetric(horizontal: Dimen.padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: ThemeColors.greyBorder.withOpacity(0.5),
                    ),
                    // color: ThemeColors.greyBorder.withOpacity(0.4),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 23, 23, 23),
                        // ThemeColors.greyBorder,
                        Color.fromARGB(255, 48, 48, 48),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        provider.extra?.affiliateReferText ?? "",
                        textAlign: TextAlign.center,
                        style: stylePTSansRegular(color: ThemeColors.greyText),
                      ),
                      const SpacerVertical(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: const BoxDecoration(
                                color: ThemeColors.greyBorder,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  topLeft: Radius.circular(4),
                                ),
                              ),
                              child: Text(
                                "${shareUri ?? ""}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: stylePTSansRegular(),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            onTap: () {
                              try {
                                Clipboard.setData(
                                    ClipboardData(text: shareUri.toString()));
                                CommonToast.show(message: "Copied");
                              } catch (e) {
                                CommonToast.show(message: "$e");
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8.9),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 69, 69, 69),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(4),
                                    topRight: Radius.circular(4)),
                              ),
                              child: const Icon(
                                Icons.copy,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SpacerVertical(height: 15),
                      ThemeButton(
                        // text: "Share with friends",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.share),
                            const SpacerHorizontal(width: 6),
                            Flexible(
                              child: Text(
                                "Share with friends",
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
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                      margin: const EdgeInsets.fromLTRB(
                          Dimen.padding, 20, Dimen.padding, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: ThemeColors.greyBorder.withOpacity(0.5),
                        ),
                        // color: ThemeColors.greyBorder.withOpacity(0.4),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(255, 23, 23, 23),
                            // ThemeColors.greyBorder,
                            Color.fromARGB(255, 48, 48, 48),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recent Points Activity",
                            style: stylePTSansBold(fontSize: 18),
                          ),
                          const SpacerVertical(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Friends Joined",
                                style: stylePTSansBold(fontSize: 17),
                              ),
                              const SpacerVertical(height: 10),
                              Text(
                                "${provider.data?.length ?? 0}",
                                style: stylePTSansBold(fontSize: 17),
                              ),
                            ],
                          ),
                          // const Divider(
                          //   color: ThemeColors.greyBorder,
                          //   height: 10,
                          // ),
                          const SpacerVertical(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: provider.verified != 0,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Text(
                                      "Verified: ${provider.verified}${provider.unVerified != 0 ? "," : ""}",
                                      style: stylePTSansRegular(
                                          color: ThemeColors.accent),
                                    ),
                                  ),
                                ),
                                // const SpacerHorizontal(width: 5),
                                Visibility(
                                  visible: provider.unVerified != 0,
                                  child: Text(
                                    "Unverified: ${provider.unVerified}",
                                    style: stylePTSansRegular(
                                        color: ThemeColors.sos),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: ThemeColors.greyBorder,
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Earned",
                                style: stylePTSansBold(fontSize: 17),
                              ),
                              const SpacerVertical(height: 10),
                              Text(
                                "${provider.extra?.received ?? 0}",
                                style: stylePTSansBold(fontSize: 17),
                              ),
                            ],
                          ),
                          const Divider(
                            color: ThemeColors.greyBorder,
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Spent",
                                style: stylePTSansBold(fontSize: 17),
                              ),
                              const SpacerVertical(height: 10),
                              Text(
                                "${provider.extra?.spent ?? 0}",
                                style: stylePTSansBold(fontSize: 17),
                              ),
                            ],
                          ),

                          const Divider(
                            color: ThemeColors.greyBorder,
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Balance",
                                style: stylePTSansBold(fontSize: 17),
                              ),
                              const SpacerVertical(height: 10),
                              Text(
                                "${provider.extra?.balance ?? 0}",
                                style: stylePTSansBold(fontSize: 17),
                              ),
                            ],
                          ),
                          // const Divider(
                          //   color: ThemeColors.greyBorder,
                          //   height: 20,
                          // ),

                          const SpacerVertical(height: 30),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AffiliateTransaction(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: Dimen.padding),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ThemeColors.greyBorder.withOpacity(0.5),
                            ),
                            left: BorderSide(
                              color: ThemeColors.greyBorder.withOpacity(0.5),
                            ),
                            right: BorderSide(
                              color: ThemeColors.greyBorder.withOpacity(0.5),
                            ),
                          ),
                          color: const Color.fromARGB(255, 62, 62, 62),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Images.transaction,
                              height: 20,
                              width: 20,
                              color: ThemeColors.accent,
                            ),
                            const SpacerHorizontal(width: 5),
                            Flexible(
                              child: Text(
                                "View Points Transactions",
                                style: stylePTSansBold(
                                  fontSize: 14,
                                  color: ThemeColors.accent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: provider.data?.isNotEmpty == true &&
                      provider.data != null,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimen.padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpacerVertical(height: 20),
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
                            // return const Divider(
                            //   color: ThemeColors.greyBorder,
                            //   height: 16,
                            // );
                            return const SpacerVertical(height: 16);
                          },
                          itemCount: provider.data?.length ?? 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      provider.data?.isEmpty == true || provider.data == null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimen.padding, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: ThemeColors.greyBorder.withOpacity(0.5),
                      ),
                      // color: ThemeColors.greyBorder.withOpacity(0.4),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(255, 23, 23, 23),
                          // ThemeColors.greyBorder,
                          Color.fromARGB(255, 48, 48, 48),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScreenTitle(
                          title: homeProvider.extra?.howItWork?.title ?? "",
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 10),
                          itemBuilder: (context, index) {
                            StepRes? data =
                                homeProvider.extra?.howItWork?.steps?[index];
                            return HowItWorkItem(
                              colorKey: const Color.fromARGB(255, 77, 77, 77),
                              index: index,
                              data: data,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: ThemeColors.greyBorder,
                              height: 25,
                            );
                          },
                          itemCount:
                              homeProvider.extra?.howItWork?.steps?.length ?? 0,
                        ),
                      ],
                    ),
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
