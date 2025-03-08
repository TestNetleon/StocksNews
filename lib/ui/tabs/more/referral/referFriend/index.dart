import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/referral_manager.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/referFriend/points_list.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/referFriend/referral_header.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class ReferAFriend extends StatefulWidget {
  const ReferAFriend({super.key});

  @override
  State<ReferAFriend> createState() => _ReferAFriendState();
}

class _ReferAFriendState extends State<ReferAFriend> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    ReferralManager manager = context.read<ReferralManager>();
    manager.getData();
  }

  @override
  Widget build(BuildContext context) {
    ReferralManager manager = context.watch<ReferralManager>();
    return BaseLoaderContainer(
      hasData: manager.data != null,
      isLoading: manager.isLoading,
      error: manager.error,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: _callAPI,
        children: [
          // Padding(
          //   padding: EdgeInsets.all(Dimen.padding),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         manager.data?.title ?? "",
          //         style: styleBaseBold(fontSize: 26, height: 1.25),
          //       ),
          //       SpacerVertical(height: 4),
          //       HtmlWidget(
          //         manager.data?.subTitle ?? "",
          //         textStyle: styleBaseRegular(
          //           fontSize: 16,
          //           color: ThemeColors.neutral80,
          //           height: 1.4,
          //         ),
          //       ),
          //       SpacerVertical(height: 24),
          //       BaseBorderContainer(
          //         padding: EdgeInsets.zero,
          //         color: ThemeColors.secondary100,
          //         child: Column(
          //           children: [
          //             Text(
          //               "Your Referral Code",
          //               style: styleBaseRegular(
          //                 fontSize: 14,
          //                 color: ThemeColors.gray2,
          //               ),
          //             ),
          //             SpacerVertical(height: 8),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   "WARBST",
          //                   style: styleBaseBold(
          //                     fontSize: 20,
          //                     color: ThemeColors.white,
          //                   ),
          //                 ),
          //                 Image.asset(
          //                   Images.copy,
          //                   width: 17,
          //                 )
          //               ],
          //             ),
          //             SpacerVertical(height: 8),
          //             Text(
          //               "https://stocksnews.page.link/tdqX",
          //               style: styleBaseRegular(
          //                 fontSize: 14,
          //                 color: ThemeColors.white,
          //               ),
          //             ),
          //             SpacerVertical(height: 14),
          //             BaseButton(
          //               onPressed: () {},
          //               text: "Share with Friends",
          //               color: ThemeColors.white,
          //               textStyle: styleBaseBold(
          //                 fontSize: 16,
          //                 color: ThemeColors.secondary100,
          //               ),
          //               padding: EdgeInsets.all(12),
          //             )
          //           ],
          //         ),
          //       ),
          //       SpacerVertical(height: Dimen.padding),
          //       Text(
          //         manager.data?.pointsSummary?.title ?? "",
          //         style: styleBaseBold(fontSize: 20, height: 1.25),
          //       ),
          //       SpacerVertical(height: Dimen.padding),
          //     ],
          //   ),
          // ),
          ReferralHeader(),
          PointsList(data: manager.data?.pointsSummary?.data),
        ],
      ),
    );
  }
}
