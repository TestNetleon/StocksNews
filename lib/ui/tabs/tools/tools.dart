import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/tools/compareStocks/compare.dart';
import 'package:stocks_news_new/ui/tabs/tools/item.dart';
import 'package:stocks_news_new/ui/tabs/tools/plaidConnect/plaid_service.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../base/scaffold.dart';
import 'plaidConnect/portfolio.dart';

class ToolsIndex extends StatelessWidget {
  const ToolsIndex({super.key});
  _onCompareStock() {
    Navigator.pushNamed(navigatorKey.currentContext!, ToolsCompareIndex.path);
  }

  _onSyncPortfolio(bool connected) async {
    if (connected) {
      Navigator.pushNamed(
          navigatorKey.currentContext!, ToolsPortfolioIndex.path);
    } else {
      UserManager manager = navigatorKey.currentContext!.read<UserManager>();
      ToolsManager toolsManager =
          navigatorKey.currentContext!.read<ToolsManager>();

      await manager.askLoginScreen();

      if (manager.user != null) {
        if (manager.user?.signupStatus != true) {
          await toolsManager.getToolsData();
          bool isConnected = toolsManager.data?.plaid?.connected ?? false;
          if (isConnected == true) {
            Navigator.pushNamed(
                navigatorKey.currentContext!, ToolsPortfolioIndex.path);
          } else {
            PlaidService.instance.init();
            PlaidService.instance.initiatePlaid();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToolsManager manager = context.watch<ToolsManager>();

    return BaseScaffold(
      body: BaseLoaderContainer(
        isLoading: manager.isLoading,
        hasData: manager.data != null && !manager.isLoading,
        showPreparingText: true,
        error: manager.error,
        onRefresh: manager.getToolsData,
        child: BaseScroll(
          onRefresh: manager.getToolsData,
          children: [
            SpacerVertical(height: 16),
            if (manager.data?.compare != null)
              ToolsItem(
                card: manager.data?.compare,
                onTap: _onCompareStock,
              ),
            SpacerVertical(height: 16),
            if (manager.data?.plaid != null)
              ToolsItem(
                card: manager.data?.plaid,
                onTap: () {
                  _onSyncPortfolio(manager.data?.plaid?.connected == true);
                },
              ),
          ],
        ),
      ),
    );
  }
}
