import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/ui/aiAnalysis/index.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../models/ticker.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/scaffold.dart';
import '../../../base/stock/add.dart';

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
        title: manager.portfolioData?.title,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoadingPortfolio,
        hasData: manager.portfolioData != null,
        showPreparingText: true,
        error: manager.errorPortfolio,
        onRefresh: manager.getPortfolioData,
        child: BaseScroll(
          margin: EdgeInsets.zero,
          onRefresh: manager.getPortfolioData,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Pad.pad8),
                border: Border.all(color: ThemeColors.neutral5),
              ),
              padding: EdgeInsets.all(Pad.pad16),
              margin: EdgeInsets.all(Pad.pad16),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    manager.portfolioData?.balanceBox?.text ?? '',
                    style: styleBaseRegular(
                      fontSize: 14,
                      color: ThemeColors.neutral40,
                    ),
                  ),
                  Visibility(
                    visible:
                        manager.portfolioData?.balanceBox?.balance != null &&
                            manager.portfolioData?.balanceBox?.balance != '',
                    child: Padding(
                      padding: const EdgeInsets.only(top: Pad.pad8),
                      child: Text(
                        manager.portfolioData?.balanceBox?.balance ?? '',
                        style: styleBaseBold(
                          fontSize: 25,
                          color: ThemeColors.black,
                        ),
                      ),
                    ),
                  ),
                  SpacerVertical(height: 16),
                  IntrinsicWidth(
                    child: BaseButton(
                      fullWidth: false,
                      onPressed: manager.removePortfolio,
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
            BaseLoaderContainer(
              isLoading: manager.isLoadingPortfolio,
              hasData: manager.portfolioData?.data != null,
              showPreparingText: true,
              error: manager.errorPortfolio,
              onRefresh: () {},
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  BaseTickerRes? data = manager.portfolioData?.data?[index];
                  if (data == null) {
                    return SizedBox();
                  }
                  return BaseStockAddItem(
                    slidable: false,
                    data: data,
                    index: index,
                    onTap: (p0) {
                      if (p0.notAvailable != null && p0.notAvailable != '') {
                        TopSnackbar.show(
                          message: p0.notAvailable ?? '',
                        );
                      } else {
                        AIManager manager = context.read<AIManager>();
                        manager.setFromSD(false);
                        Navigator.pushNamed(context, AIindex.path, arguments: {
                          'symbol': p0.symbol,
                        });
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return BaseListDivider();
                },
                itemCount: manager.portfolioData?.data?.length ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
