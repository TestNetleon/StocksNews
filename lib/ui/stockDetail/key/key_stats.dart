import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
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
      hasData: manager.dataKeyStats != null,
      isLoading: manager.isLoadingKeyStats,
      error: manager.errorKeyStats,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: manager.onSelectedTabRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) {
            BaseKeyValueRes? data = manager.dataKeyStats?.data?[index];
            if (data == null) {
              return SizedBox();
            }

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: Pad.pad16,
                vertical: Pad.pad10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      data.title ?? '',
                      style: styleBaseRegular(color: ThemeColors.neutral40),
                    ),
                  ),
                  Consumer<ThemeManager>(
                    builder: (context, value, child) {
                      return Text(
                        '${data.value ?? ''}',
                        style: styleBaseBold(
                          color: (data.title == 'Day Low' ||
                                  data.title == 'Year Low')
                              ? ThemeColors.error120
                              : (data.title == 'Day High' ||
                                      data.title == 'Year High')
                                  ? ThemeColors.success120
                                  : value.isDarkMode
                                      ? ThemeColors.white
                                      : ThemeColors.black,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
          itemCount: manager.dataKeyStats?.data?.length ?? 0,
        ),
      ),
    );
  }
}
