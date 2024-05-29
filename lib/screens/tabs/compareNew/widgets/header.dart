import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../modals/compare_stock_res.dart';
import '../../../../providers/compare_stocks_provider.dart';

class CompareNewHeader extends StatelessWidget {
  const CompareNewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();

    return Row(
      children: List.generate(provider.company.length, (index) {
        CompareStockRes company = provider.company[index];
        return Expanded(
          child: InkWell(
            // borderRadius: BorderRadius.circular(8),
            onTap: () {},
            child: Ink(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8),
                  // color: ThemeColors.greyBorder.withOpacity(0.4),
                  border: Border(
                right: provider.company.length == 1
                    ? BorderSide.none
                    : provider.company.length == 2 && index == 0
                        ? BorderSide(
                            color: ThemeColors.greyBorder.withOpacity(0.4),
                          )
                        : provider.company.length == 3 &&
                                index == 0 &&
                                index == 2
                            ? BorderSide(
                                color: ThemeColors.greyBorder.withOpacity(0.4),
                              )
                            : BorderSide.none,
              )),
              width: ScreenUtil().screenWidth * 0.3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpacerVertical(height: 10),
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: CachedNetworkImagesWidget(company.image),
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        company.symbol,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: stylePTSansRegular(),
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        company.name,
                        style: stylePTSansRegular(
                            fontSize: 11, color: ThemeColors.greyText),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => provider.removeStockItem(index: index),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.close,
                          color: ThemeColors.greyBorder,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );

    // return ListView.separated(
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     scrollDirection: Axis.horizontal,
    //     itemBuilder: (context, index) {
    //       CompareStockRes company = provider.company[index];
    //       return InkWell(
    //         borderRadius: BorderRadius.circular(8),
    //         onTap: () {},
    //         child: Ink(
    //           padding: const EdgeInsets.all(5),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(8),
    //             color: ThemeColors.greyBorder.withOpacity(0.4),
    //           ),
    //           width: ScreenUtil().screenWidth * 0.3,
    //           child: Stack(
    //             alignment: Alignment.center,
    //             children: [
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   const SpacerVertical(height: 10),
    //                   SizedBox(
    //                     height: 35,
    //                     width: 35,
    //                     child: CachedNetworkImagesWidget(company.image),
    //                   ),
    //                   const SpacerVertical(height: 5),
    //                   Text(
    //                     company.symbol,
    //                     maxLines: 1,
    //                     textAlign: TextAlign.center,
    //                     style: stylePTSansRegular(),
    //                   ),
    //                   const SpacerVertical(height: 5),
    //                   Text(
    //                     maxLines: 2,
    //                     overflow: TextOverflow.ellipsis,
    //                     textAlign: TextAlign.center,
    //                     company.name,
    //                     style: stylePTSansRegular(
    //                         fontSize: 11, color: ThemeColors.greyText),
    //                   ),
    //                 ],
    //               ),
    //               Positioned(
    //                 top: 0,
    //                 right: 0,
    //                 child: GestureDetector(
    //                   onTap: () => provider.removeStockItem(index: index),
    //                   child: const Align(
    //                     alignment: Alignment.topRight,
    //                     child: Icon(
    //                       Icons.close,
    //                       color: ThemeColors.greyBorder,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //     separatorBuilder: (context, index) {
    //       return const SpacerHorizontal(width: 5);
    //     },
    //     itemCount: provider.company.length);
  }
}
