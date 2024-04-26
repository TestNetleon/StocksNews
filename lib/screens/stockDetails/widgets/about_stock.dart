import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

class AboutStock extends StatelessWidget {
  const AboutStock({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyInfo? companyInfo =
        context.watch<StockDetailProvider>().data?.companyInfo;
    return Column(
      children: [
        const ScreenTitle(
          title: "About",
          // style: stylePTSansRegular(fontSize: 20),
        ),
        Text(
          companyInfo?.description ?? "",
          style: stylePTSansRegular(),
        ),
      ],
    );
  }
}
