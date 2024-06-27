import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../modals/affiliate/transaction.dart';
import '../../../utils/colors.dart';

class AffiliateTransaction extends StatefulWidget {
  const AffiliateTransaction({super.key});

  @override
  State<AffiliateTransaction> createState() => _AffiliateTransactionState();
}

class _AffiliateTransactionState extends State<AffiliateTransaction> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderBoardProvider>().getTransactionData();
    });
  }

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
        canSearch: true,
        showTrailing: true,
        isPopback: true,
      ),
      body: BaseUiContainer(
        hasData: !provider.isLoadingT &&
            (provider.tnxData?.isNotEmpty == true && provider.tnxData != null),
        isLoading: provider.isLoadingT,
        error: provider.errorT,
        onRefresh: () async {
          provider.getTransactionData();
        },
        showPreparingText: true,
        child: CommonRefreshIndicator(
          onRefresh: () async {
            provider.getTransactionData();
          },
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      const ScreenTitle(
                        title: "Points Transactions",
                      ),
                      AffiliateTranItem(
                        data: provider.tnxData?[index],
                      ),
                    ],
                  );
                }

                return AffiliateTranItem(
                  data: provider.tnxData?[index],
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerVertical(height: 10);
              },
              itemCount: provider.tnxData?.length ?? 0),
        ),
      ),
    );
  }
}

class AffiliateTranItem extends StatelessWidget {
  final AffiliateTransactionRes? data;
  const AffiliateTranItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 23, 23, 23),
            // ThemeColors.greyBorder,
            Color.fromARGB(255, 39, 39, 39),
          ],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: data?.spent != null && data?.spent != 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ((data?.spent ?? 0) > 1) ? "Points spent" : "Point spent",
                    style:
                        styleGeorgiaBold(fontSize: 20, color: ThemeColors.sos),
                  ),
                  Text(
                    "-${data?.spent}",
                    style:
                        styleGeorgiaBold(fontSize: 20, color: ThemeColors.sos),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: data?.earn != null && data?.earn != 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // "Point earned",
                    ((data?.earn ?? 0) > 1) ? "Points earned" : "Point earned",
                    style: styleGeorgiaBold(
                        fontSize: 20, color: ThemeColors.accent),
                  ),
                  Text(
                    "+${data?.earn}",
                    style: styleGeorgiaBold(
                        fontSize: 20, color: ThemeColors.accent),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: ThemeColors.greyBorder,
            height: 20,
          ),
          Text(
            data?.txnDetail ?? "",
            style: stylePTSansRegular(height: 1.5),
          ),
          const SpacerVertical(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${data?.createdAt}",
              style: stylePTSansRegular(color: ThemeColors.greyText),
            ),
          ),
        ],
      ),
    );
  }
}
