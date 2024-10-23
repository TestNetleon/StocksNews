import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../modals/missions/missions.dart';
import '../../providers/missions/provider.dart';
import '../../widgets/custom/refresh_indicator.dart';
import 'widgets/current_points.dart';
import 'widgets/individual_item.dart';

class ClaimPointsIndex extends StatefulWidget {
  const ClaimPointsIndex({super.key});

  @override
  State<ClaimPointsIndex> createState() => _ClaimPointsIndexState();
}

class _ClaimPointsIndexState extends State<ClaimPointsIndex> {
  bool claimed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MissionProvider>().getMissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    MissionProvider provider = context.watch<MissionProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        onTap: () {
          Navigator.pop(context, claimed);
        },
        canSearch: true,
        showTrailing: true,
        title: "Rewards",
        subTitle: provider.extra?.subTitle,
      ),
      body: BaseUiContainer(
        hasData: !provider.isLoading &&
            provider.data != null &&
            provider.data?.isNotEmpty == true,
        isLoading: provider.isLoading &&
            (provider.data == null || provider.data?.isEmpty == true),
        showPreparingText: true,
        error: provider.error,
        isFull: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Dimen.padding,
            Dimen.padding,
            Dimen.padding,
            0,
          ),
          // child: CommonRefreshIndicator(
          //   onRefresh: () async {
          //     provider.getMissions();
          //   },
          //   child: Column(
          //     children: [
          //       CurrentPointsItem(),
          //       ListView.separated(
          //         shrinkWrap: true,
          //         padding: EdgeInsets.symmetric(vertical: 10),
          //         physics: NeverScrollableScrollPhysics(),
          //         itemBuilder: (context, index) {
          //           ClaimPointsRes? data = provider.data?[index];
          //           return ClaimPointsIndividual(data: data);
          //         },
          //         itemCount: provider.data?.length ?? 0,
          //         separatorBuilder: (context, index) {
          //           return SpacerVertical(height: 10);
          //         },
          //       ),
          //     ],
          //   ),
          // ),

          child: CommonRefreshIndicator(
            onRefresh: () async {
              provider.getMissions();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CurrentPointsItem(),
                  ),
                ),
                // ListView.separated(
                //   shrinkWrap: true,
                //   padding: EdgeInsets.symmetric(vertical: 10),
                //   physics: NeverScrollableScrollPhysics(),
                //   itemBuilder: (context, index) {},
                //   separatorBuilder: (context, index) {},
                // ),
                SliverList.separated(
                  itemCount: provider.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    ClaimPointsRes? data = provider.data?[index];
                    return ClaimPointsIndividual(
                      data: data,
                      claimed: (p0) {
                        claimed = p0;
                        setState(() {});
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SpacerVertical(height: 10);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
