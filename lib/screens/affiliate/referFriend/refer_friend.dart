import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
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
    if (provider.data == null || provider.data?.isEmpty == true) {
      context.read<LeaderBoardProvider>().getReferData();
    }
  }

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();
    return BaseUiContainer(
      hasData: !provider.isLoading &&
          (provider.data?.isNotEmpty == true && provider.data != null),
      isLoading: provider.isLoading,
      error: provider.error,
      showPreparingText: true,
      isFull: true,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          provider.getReferData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: const BoxDecoration(
                                color: ThemeColors.greyBorder,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(4),
                                    topLeft: Radius.circular(4))),
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
                      text: "Share with friends",
                      onPressed: () {
                        Share.share(
                          "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                margin: const EdgeInsets.symmetric(vertical: 15),
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Friends Invited",
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
                          Flexible(
                            child: Text(
                              "Verified: ${provider.verified},",
                              style:
                                  stylePTSansRegular(color: ThemeColors.accent),
                            ),
                          ),
                          const SpacerHorizontal(width: 5),
                          Flexible(
                            child: Text(
                              "Unverified: ${provider.unVerified}",
                              style: stylePTSansRegular(color: ThemeColors.sos),
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
                          "Coins Earned",
                          style: stylePTSansBold(fontSize: 17),
                        ),
                        const SpacerVertical(height: 10),
                        Text(
                          "${provider.extra?.received ?? 0}",
                          style: stylePTSansBold(fontSize: 17),
                        ),
                      ],
                    ),
                    const SpacerVertical(height: 10),
                  ],
                ),
              ),
              const ScreenTitle(
                title: "Referred to",
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
                  return const Divider(
                    color: ThemeColors.greyBorder,
                    height: 16,
                  );
                },
                itemCount: provider.data?.length ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
