import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_recurring.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/RecurringOrder/widget/recurring_actions.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/recurring/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';


class SRecurringList extends StatefulWidget {
  const SRecurringList({super.key});

  @override
  State<SRecurringList> createState() => _SRecurringListState();
}

class _SRecurringListState extends State<SRecurringList> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData() async {
    SRecurringManager manager = context.read<SRecurringManager>();
    manager.getData();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SRecurringManager manager = context.watch<SRecurringManager>();
    return BaseLoaderContainer(
      hasData: manager.data != null && !manager.isLoading,
      isLoading: manager.isLoading || manager.status == Status.ideal,
      error: manager.error,
      onRefresh: _getData,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: _getData,
        child: ListView.separated(
          itemBuilder: (context, index) {
            TsRecurringListRes item = manager.data![index];
            return TsRecurringListItem(
              item: item,
              onTap:() {
                BaseBottomSheet().bottomSheet(
                  barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
                  child:  RecurringActions(
                    symbol:  item.symbol,
                    item: item,
                    index: index,
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(height: 24,thickness:1,color: ThemeColors.neutral5);
          },
          itemCount: manager.data?.length ?? 0,
        ),
      ),
    );
  }
}
