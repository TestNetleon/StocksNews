import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class HeaderItem extends StatelessWidget {
  final CompareStockRes? company;
  final void Function()? onTap;
  const HeaderItem({super.key, this.company, this.onTap});
//
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          color: ThemeColors.primaryLight,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: ThemeColors.dividerDark)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            StockDetails.path,
            // arguments: company?.symbol,
            arguments: {"slug": company?.symbol},
          );
        },
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5.sp),
                    width: 43.sp,
                    height: 43.sp,
                    child: ThemeImageView(url: company?.image ?? ""),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "${company?.symbol}",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: stylePTSansBold(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SpacerHorizontal(width: 10),
            Positioned(
              top: 2,
              right: 2,
              child: InkWell(
                onTap: onTap,
                child: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
