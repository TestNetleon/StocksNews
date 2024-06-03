import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/added/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

class HomePlaidAdded extends StatefulWidget {
  const HomePlaidAdded({super.key});

  @override
  State<HomePlaidAdded> createState() => _HomePlaidAddedState();
}

class _HomePlaidAddedState extends State<HomePlaidAdded> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PlaidProvider>().getPlaidPortfolioData(showProgress: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    PlaidProvider provider = context.watch<PlaidProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
        showTrailing: true,
      ),
      body: BaseUiContainer(
        hasData: provider.data != null && provider.data?.isNotEmpty == true,
        isLoading: provider.isLoadingG,
        showPreparingText: true,
        error: provider.errorG,
        onRefresh: () async =>
            provider.getPlaidPortfolioData(showProgress: false),
        child: CommonRefreshIndicator(
            onRefresh: () async =>
                provider.getPlaidPortfolioData(showProgress: false),
            child: const HomePlaidAddedContainer()),
      ),
    );
  }
}

class HomePlaidAddedContainer extends StatelessWidget {
  const HomePlaidAddedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    PlaidProvider provider = context.watch<PlaidProvider>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            Dimen.padding, Dimen.padding, Dimen.padding, 0),
        child: Column(
          children: [
            const ScreenTitle(title: "Investment Overview"),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: Dimen.padding),
                itemBuilder: (context, index) {
                  PlaidDataRes? data = provider.data?[index];
                  if (data == null) {
                    return const SizedBox();
                  }
                  return HomePlaidItem(
                    data: data,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: ThemeColors.greyBorder,
                    height: 16,
                  );
                },
                itemCount: provider.data?.length ?? 0),
          ],
        ),
      ),
    );
  }
}
