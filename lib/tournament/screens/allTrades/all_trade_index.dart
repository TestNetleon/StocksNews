import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class TournamentAllTradeIndex extends StatefulWidget {
  const TournamentAllTradeIndex({super.key});

  @override
  State<TournamentAllTradeIndex> createState() =>
      _TournamentAllTradeIndexState();
}

class _TournamentAllTradeIndexState extends State<TournamentAllTradeIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TournamentTradesProvider>().getTradesOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    TournamentTradesProvider provider =
        context.watch<TournamentTradesProvider>();
    return BaseUiContainer(
      hasData: provider.tradesOverview != null &&
          provider.tradesOverview?.isNotEmpty == true &&
          !provider.isLoadingOverview,
      isLoading: provider.isLoadingOverview,
      error: provider.errorOverview,
      showPreparingText: true,
      child: Column(
        children: [
          Wrap(
            direction: Axis.horizontal,
            spacing: 10.0,
            runSpacing: 10.0,
            children: List.generate(
              provider.tradesOverview?.length ?? 0,
              (index) {
                return GestureDetector(
                  onTap: () => provider
                      .setSelectedOverview(provider.tradesOverview?[index]),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ThemeColors.greyBorder.withOpacity(0.5),
                        border: provider.selectedOverview ==
                                provider.tradesOverview?[index]
                            ? Border.all(color: ThemeColors.white)
                            : null),
                    child: Text(
                      '${provider.tradesOverview?[index].key} ${provider.tradesOverview?[index].value}',
                      style: styleGeorgiaBold(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
