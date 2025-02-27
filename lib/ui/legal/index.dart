import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/legal.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class LegalInfoIndex extends StatefulWidget {
  final String? slug;
  static const path = 'LegalInfoIndex';
  const LegalInfoIndex({
    super.key,
    this.slug,
  });

  @override
  State<LegalInfoIndex> createState() => _LegalInfoIndexState();
}

class _LegalInfoIndexState extends State<LegalInfoIndex> {
  final List<MarketResData> _tabs = [
    MarketResData(title: 'Privacy Policy', slug: 'privacy-policy'),
    MarketResData(title: 'Terms of Service', slug: 'terms-of-service'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<LegalInfoManager>()
          .getLegalInfo(widget.slug ?? 'privacy-policy');
    });
  }

  int _selected = 1;

  _onChange(index) {
    _selected = index;
    setState(() {});
    LegalInfoManager manager = context.read<LegalInfoManager>();
    manager.getLegalInfo(_tabs[index].slug!);
  }

  @override
  Widget build(BuildContext context) {
    LegalInfoManager manager = context.watch<LegalInfoManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.data?.title,
      ),
      body: Column(
        children: [
          BaseTabs(
            isScrollable: false,
            data: _tabs,
            onTap: _onChange,
          ),
          Expanded(
            child: BaseLoaderContainer(
              hasData: manager.data != null,
              isLoading: manager.isLoading,
              error: manager.error,
              showPreparingText: true,
              onRefresh: () async {
                manager.getLegalInfo(_tabs[_selected].slug ?? '');
              },
              child: BaseScroll(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: HtmlWidget(
                      manager.data?.description ?? '',
                      textStyle: TextStyle(
                        fontFamily: Fonts.ptSans,
                        color: ThemeColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
