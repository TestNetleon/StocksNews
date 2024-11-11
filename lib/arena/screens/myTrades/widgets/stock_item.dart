import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../provider/trades.dart';

class ArenaStockItem extends StatelessWidget {
  final ArenaStockRes? data;
  const ArenaStockItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: CachedNetworkImage(
              width: 43,
              height: 43,
              imageUrl:
                  'https:\/\/financialmodelingprep.com\/image-stock\/TSLA.png',
            ),
          ),
          SpacerHorizontal(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TSLA',
                  style: styleGeorgiaBold(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Visibility(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Tesla. Inc.',
                      style: styleGeorgiaRegular(
                        color: ThemeColors.greyText,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: ThemeColors.greyBorder,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '1.14%',
              style: styleGeorgiaRegular(),
            ),
          ),
          SpacerHorizontal(width: 10),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeColors.accent,
            ),
            padding: EdgeInsets.all(10),
          )
        ],
      ),
    );
  }
}
