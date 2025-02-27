import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/spacer_horizontal.dart';
import 'app_bar.dart';

class BaseTickerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? searchFieldWidget;
  final BaseTickerRes? data;
  final Function()? shareURL, addToAlert, addToWatchlist;
  final double toolbarHeight;

  const BaseTickerAppBar({
    super.key,
    this.toolbarHeight = 60,
    this.searchFieldWidget,
    this.data,
    this.shareURL,
    this.addToAlert,
    this.addToWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(Pad.pad8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Leading
            Expanded(
              child: Row(
                children: [
                  ActionButton(
                    icon: Images.back,
                    onTap: () {
                      Navigator.pop(navigatorKey.currentContext!);
                    },
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Pad.pad5),
                          child: Container(
                            padding: EdgeInsets.all(3.sp),
                            color: ThemeColors.neutral5,
                            child: data?.image == null || data?.image == ''
                                ? SizedBox(
                                    height: 32,
                                    width: 32,
                                  )
                                : CachedNetworkImagesWidget(
                                    data?.image,
                                    height: 32,
                                    width: 32,
                                  ),
                          ),
                        ),
                        const SpacerHorizontal(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                child: Row(
                                  children: [
                                    Text(
                                      data?.symbol ?? '',
                                      style: styleBaseBold(fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Visibility(
                                      visible: data?.exchange != null &&
                                          data?.exchange != '',
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: ThemeColors.neutral5,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Text(
                                          '${data?.exchange}',
                                          style: styleBaseSemiBold(
                                              color: ThemeColors.neutral80,
                                              fontSize: 11),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // const SpacerVertical(height: 2),
                              Visibility(
                                visible: data?.name != null && data?.name != '',
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  data?.name ?? '',
                                  style: styleBaseRegular(
                                    fontSize: 14,
                                    color: ThemeColors.neutral40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Actions
            Row(
              children: [
                if (addToAlert != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionButton(
                      size: 35,
                      icon: Images.moreStockAlerts,
                      onTap: addToAlert!,
                    ),
                  ),
                if (addToWatchlist != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionButton(
                      size: 35,
                      icon: Images.watchlist,
                      onTap: addToWatchlist!,
                    ),
                  ),
                if (shareURL != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionButton(
                      size: 35,
                      icon: Images.shareURL,
                      onTap: shareURL!,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
