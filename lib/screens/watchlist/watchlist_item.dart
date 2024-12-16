import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/watchlist_res.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../widgets/cache_network_image.dart';
import '../../widgets/custom/alert_popup.dart';
import '../stockDetail/index.dart';

class WatchlistItem extends StatelessWidget {
  final int index;
  final WatchlistData data;

  const WatchlistItem({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(index.toString()),
      groupTag: "A",
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: .4,
        motion: const ScrollMotion(),
        children: [
          const SpacerHorizontal(),
          SlidableAction(
            onPressed: (_) {
              popUpAlert(
                cancel: true,
                okText: "Remove",
                message:
                    "Do you want to remove this stock from your watchlist?",
                title: "Removing Stock",
                icon: Images.alertPopGIF,
                onTap: () {
                  context
                      .read<WatchlistProvider>()
                      .deleteItem(data.id, data.symbol, data.name);
                  Navigator.pop(context);
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Remove',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => StockDetail(symbol: data.symbol),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: ThemeColors.background,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.sp),
                child: Container(
                  padding: EdgeInsets.all(5.sp),
                  width: 48,
                  height: 48,
                  // child: ThemeImageView(url: data.image),
                  child: CachedNetworkImagesWidget(
                    data.image,
                    // width: 30,
                    // height: 30,
                  ),
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.symbol,
                      style: stylePTSansBold(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: 5),
                    Text(
                      data.name,
                      style: stylePTSansRegular(
                        color: ThemeColors.greyText,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.price,
                    style: stylePTSansBold(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "${data.displayChange} (${data.changesPercentage.toCurrency()}%)",
                    style: stylePTSansRegular(
                      fontSize: 12,
                      color: data.changesPercentage > 0
                          ? ThemeColors.accent
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
