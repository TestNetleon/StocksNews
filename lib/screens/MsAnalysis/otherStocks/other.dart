import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../modals/stock_details_res.dart';
import '../../../providers/stock_detail_new.dart';
import '../../../utils/colors.dart';
import '../widget/title_tag.dart';

class MsOtherStocks extends StatefulWidget {
  const MsOtherStocks({super.key});

  @override
  State<MsOtherStocks> createState() => _MsOtherStocksState();
}

class _MsOtherStocksState extends State<MsOtherStocks> {
  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    CompanyInfo? companyInfo = provider.tabRes?.companyInfo;
    KeyStats? keyStats = provider.tabRes?.keyStats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(top: Dimen.padding),
        //   child: ScreenTitle(
        //     title: "Your other stocks",
        //     style: styleSansBold(color: ThemeColors.white, fontSize: 18),
        //     dividerPadding: EdgeInsets.only(bottom: 10),
        //   ),
        // ),
        MsTitle(title: "Your Other Stocks"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              10,
              (index) {
                return Container(
                  width: 150,
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 15,
                        right: 15,
                        top: 0,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 17, 253, 49),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ThemeColors.greyBorder),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.1, 0.5],
                            colors: [
                              ThemeColors.greyBorder.withOpacity(0.5),
                              Colors.black,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedNetworkImagesWidget(
                                    height: 30, width: 30, companyInfo?.image),
                                SpacerHorizontal(width: 5),
                                Flexible(
                                  child: Text(
                                    keyStats?.symbol ?? "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        styleSansBold(color: ThemeColors.white),
                                  ),
                                ),
                              ],
                            ),
                            SpacerVertical(height: 6),
                            Text(
                              keyStats?.name ?? "N/A",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: stylePTSansRegular(
                                  color: ThemeColors.greyText),
                            ),
                            SpacerVertical(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 17,
                                  color: ThemeColors.accent,
                                ),
                                Flexible(
                                  child: Text(
                                    " 0.38%",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: stylePTSansRegular(
                                        color: ThemeColors.accent),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
