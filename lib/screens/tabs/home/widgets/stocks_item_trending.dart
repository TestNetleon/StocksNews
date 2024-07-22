import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../../stockDetail/index.dart';

class StocksItemTrending extends StatelessWidget {
  final HomeTrendingData trending;

  const StocksItemTrending({
    required this.trending,
    super.key,
  });
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (_) => StockDetail(symbol: trending.symbol)),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeColors.background,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0.sp),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 48,
                    height: 48,
                    child: ThemeImageView(url: trending.image),
                  ),
                ),
                const SpacerHorizontal(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trending.symbol,
                        style: styleGeorgiaBold(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        trending.name,
                        style: styleGeorgiaRegular(
                          color: ThemeColors.greyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Mentions: ${trending.sentiment.toInt()}",
                              style: stylePTSansRegular(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(trending.price, style: stylePTSansBold(fontSize: 18)),
                    const SpacerVertical(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${trending.displayChange} (${trending.displayPercentage.toCurrency()}%)",
                            style: stylePTSansRegular(
                              fontSize: 14,
                              color: trending.displayPercentage > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
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
  }
}

class HalfCirclePainter extends CustomPainter {
  final Color color;

  HalfCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width / 2.5, size.height * 2),
      pi,
      pi,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
