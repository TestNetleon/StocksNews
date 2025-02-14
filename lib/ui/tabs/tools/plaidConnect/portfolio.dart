import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../base/scaffold.dart';

class ToolsPortfolioIndex extends StatefulWidget {
  static const path = 'ToolsPortfolioIndex';
  const ToolsPortfolioIndex({super.key});

  @override
  State<ToolsPortfolioIndex> createState() => _ToolsPortfolioIndexState();
}

class _ToolsPortfolioIndexState extends State<ToolsPortfolioIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToolsManager>().getPortfolioData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ToolsManager manager = context.watch<ToolsManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        showSearch: true,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoadingPortfolio,
        hasData: manager.portfolioData != null,
        showPreparingText: true,
        error: manager.errorPortfolio,
        onRefresh: manager.getPortfolioData,
        child: BaseScroll(
          onRefresh: manager.getPortfolioData,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Pad.pad8),
                border: Border.all(color: ThemeColors.neutral5),
              ),
              padding: EdgeInsets.all(Pad.pad16),
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      manager.portfolioData?.balanceBox?.text ?? '',
                      style: styleBaseRegular(
                        fontSize: 14,
                        color: ThemeColors.neutral40,
                      ),
                    ),
                  ),
                  Text(
                    manager.portfolioData?.balanceBox?.balance ?? '',
                    style: styleBaseBold(
                      fontSize: 25,
                      color: ThemeColors.black,
                    ),
                  ),
                  IntrinsicWidth(
                    child: BaseButton(
                      fullWidth: false,
                      onPressed: () {},
                      text: manager.portfolioData?.balanceBox?.btnText ??
                          'Disconnect',
                      color: ThemeColors.white,
                      side: BorderSide(color: ThemeColors.neutral20),
                      textColor: ThemeColors.neutral40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
