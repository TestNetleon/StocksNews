import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../modals/stock_details_res.dart';
import '../../../providers/stock_detail_new.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_horizontal.dart';
import '../../../widgets/theme_image_view.dart';
import '../../tabs/home/widgets/app_bar_home.dart';
import 'container.dart';

class BuyAndSellIndex extends StatelessWidget {
  const BuyAndSellIndex({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;
    CompanyInfo? companyInfo = provider.tabRes?.companyInfo;
    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        title: keyStats?.symbol ?? "",
        subTitle: keyStats?.name ?? "",
        widget: keyStats?.symbol == null
            ? null
            : Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8),
                    width: 48,
                    height: 48,
                    child: ThemeImageView(
                      url: companyInfo?.image ?? "",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SpacerHorizontal(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              keyStats?.symbol ?? "",
                              style: stylePTSansBold(fontSize: 18),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: ThemeColors.greyBorder,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                keyStats?.exchange ?? "",
                                style: stylePTSansRegular(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          keyStats?.name ?? "",
                          style: stylePTSansRegular(
                            fontSize: 14,
                            color: ThemeColors.greyText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimen.padding, vertical: Dimen.padding),
        child: BuyAndSellContainer(),
      ),
    );
  }
}
