import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_horizontal.dart';
import '../../../../widgets/spacer_vertical.dart';

class CommonHeadingStockDetail extends StatelessWidget {
  const CommonHeadingStockDetail({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    CompanyInfo? companyInfo = provider.data?.companyInfo;
    KeyStats? keyStats = provider.data?.keyStats;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Visibility(
            visible: companyInfo?.image != null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Container(
                padding: const EdgeInsets.all(5),
                width: 43,
                height: 43,
                child: CachedNetworkImagesWidget(companyInfo?.image ?? ""),

                //  Image.asset(
                //   Images.userPlaceholder,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Visibility(
            visible: keyStats?.symbol != null || keyStats?.name != null,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    keyStats?.symbol ?? "",
                    style: styleGeorgiaBold(fontSize: 18),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    keyStats?.name ?? "",
                    style: styleGeorgiaRegular(
                      color: ThemeColors.greyText,
                      fontSize: 14,
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
