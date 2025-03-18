import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/redeem_manager.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/redeem/redeem_points_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class RedeemPoints extends StatefulWidget {
  static const String path = "RedeemPoints";
  const RedeemPoints({super.key});

  @override
  State<RedeemPoints> createState() => _RedeemPointsState();
}

class _RedeemPointsState extends State<RedeemPoints> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    RedeemManager manager = context.read<RedeemManager>();
    manager.getData();
  }

  @override
  Widget build(BuildContext context) {
    RedeemManager manager = context.watch<RedeemManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.data?.title ?? "",
        showNotification: true,
        showSearch: true,
      ),
      body: BaseLoaderContainer(
        hasData: manager.data != null,
        isLoading: manager.isLoading,
        error: manager.error,
        showPreparingText: true,
        child: BaseScroll(
          margin: EdgeInsets.zero,
          onRefresh: _callAPI,
          children: (manager.data?.data != null)
              ? [
                  Padding(
                    padding: const EdgeInsets.all(Pad.pad16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeColors.secondary100,
                        borderRadius: BorderRadius.circular(Pad.pad8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .25),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Pad.pad20,
                        vertical: Pad.pad20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  manager.data?.box?.title ?? "",
                                  style: styleBaseBold(
                                    fontSize: 24,
                                    color: ThemeColors.white,
                                  ),
                                ),
                                SpacerVertical(height: Pad.pad3),
                                Text(
                                  manager.data?.box?.subTitle ?? "",
                                  style: styleBaseRegular(
                                    fontSize: 12,
                                    color: ThemeColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SpacerHorizontal(width: Pad.pad16),
                          Text(
                            "${manager.data?.box?.balance}",
                            style: styleBaseBold(
                              fontSize: 32,
                              color: ThemeColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SpacerVertical(height: Pad.pad20),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RedeemPointsItem(data: manager.data!.data![index]);
                    },
                    separatorBuilder: (context, index) {
                      return SpacerVertical(height: Pad.pad16);
                    },
                    itemCount: (manager.data!.data?.length ?? 0),
                  ),
                  SpacerVertical(height: Pad.pad24),
                ]
              : [SizedBox()],
        ),
      ),
    );
  }
}
