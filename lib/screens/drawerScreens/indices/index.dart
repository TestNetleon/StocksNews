import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/low_price_stocks_res.dart';
import 'package:stocks_news_new/providers/indices_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/drawer_screen_title.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../modals/low_price_stocks_tab.dart';
import 'item.dart';

class IndicesIndex extends StatefulWidget {
  static const path = "IndicesIndex";
  const IndicesIndex({super.key});

  @override
  State<IndicesIndex> createState() => _IndicesIndexState();
}

class _IndicesIndexState extends State<IndicesIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IndicesProvider>().selectedIndex = 0;
      context.read<IndicesProvider>().getTabsData(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    IndicesProvider provider = context.watch<IndicesProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
        canSearch: true,
        isPopback: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: _getWidget(provider),
      ),
    );
  }
}

Widget _getWidget(IndicesProvider provider) {
  if (provider.tabLoading) {
    return const SizedBox();
  }
  if (!provider.tabLoading && provider.tabs == null) {
    return ErrorDisplayWidget(
      error: provider.error,
      onRefresh: () => provider.getTabsData(showProgress: true),
    );
  }
  return const IndicesData();
}

class IndicesData extends StatelessWidget {
  const IndicesData({super.key});

  @override
  Widget build(BuildContext context) {
    IndicesProvider provider = context.watch<IndicesProvider>();
    List<LowPriceStocksTabRes>? tabs = provider.tabs;

    return CustomTabContainerNEW(
      onChange: (index) {
        provider.tabChange(index);
      },
      scrollable: true,
      tabsPadding: EdgeInsets.only(bottom: 10.sp),
      tabs: List.generate(tabs?.length ?? 0, (index) => "${tabs?[index].name}"),
      widgets: List.generate(
        tabs?.length ?? 0,
        (index) => _getWidgets(provider),
      ),
    );
  }

  Widget _getWidgets(IndicesProvider provider) {
    return BaseUiContainer(
      error: provider.error,
      hasData: !provider.isLoading && provider.data != null,
      isLoading: provider.isLoading,
      showPreparingText: true,
      onRefresh: () {
        provider.getIndicesData(showProgress: false);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          provider.getIndicesData(showProgress: false);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   provider.title ?? "",
              //   style: stylePTSansBold(fontSize: 13),
              // ),
              // const SpacerVertical(height: 5),
              // Text(
              //   provider.subTitle ?? "",
              //   style: stylePTSansRegular(
              //       color: ThemeColors.greyText, fontSize: 12),
              // ),

              DrawerScreenTitle(
                title: provider.title,
                subTitle: provider.subTitle,
              ),
              const SpacerVertical(height: 5),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  LowPriceStocksRes? data = provider.data?[index];
                  if (data == null) {
                    return const SizedBox();
                  }
                  return IndicesItem(data: data, index: index);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: ThemeColors.greyBorder,
                    height: 16,
                  );
                },
                itemCount: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
