import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';

class SDKeyStats extends StatelessWidget {
  const SDKeyStats({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    return BaseLoaderContainer(
      hasData: !manager.isLoadingKeyStats,
      isLoading: manager.isLoadingKeyStats,
      error: manager.errorKeyStats,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: manager.onSelectedTabRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: Pad.pad16,
                vertical: Pad.pad10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Day High',
                    style: styleBaseRegular(color: ThemeColors.neutral40),
                  ),
                  Text(
                    '\$24.44',
                    style: styleBaseBold(),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
          itemCount: 60,
        ),
      ),
    );
  }
}
