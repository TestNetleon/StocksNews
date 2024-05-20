import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/alerts_res.dart';
import 'package:stocks_news_new/providers/alert_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AlertsItem extends StatelessWidget {
  final int index;
  final AlertData data;
//
  const AlertsItem({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(index.toString()),
      closeOnScroll: true,
      groupTag: "A",
      endActionPane: ActionPane(
        extentRatio: .4,
        motion: const ScrollMotion(),
        children: [
          const SpacerHorizontal(),
          SlidableAction(
            onPressed: (_) {
              // showConfirmAlertDialog(
              //   context: context,
              //   title: "Removing Stock",
              //   message:
              //       "Do you want to remove receiving alerts for this stock?",
              //   okText: "Remove",
              //   onclick: () {
              //     context
              //         .read<AlertProvider>()
              //         .deleteItem(data.id, data.symbol);
              //   },
              // );

              popUpAlert(
                cancel: true,
                okText: "Remove",
                message:
                    "Do you want to remove receiving alerts for this stock?",
                title: "Removing Stock",
                icon: Images.alertPopGIF,
                onTap: () {
                  context
                      .read<AlertProvider>()
                      .deleteItem(data.id, data.symbol);
                  Navigator.pop(context);
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Remove',
          ),
          // Expanded(
          //   child: InkWell(
          //     splashColor: Colors.black12,
          //     onTap: (){
          //       log("****");
          //     },
          //     child: Container(
          //       color: Colors.red,
          //       child: Column(
          //         children: [
          //           Expanded(
          //             child: Center(
          //               child: Padding(
          //                 padding: EdgeInsets.symmetric(horizontal: 12.sp),
          //                 child: Text(
          //                   "Delete",
          //                   style: stylePTSansBold(),
          //                   textAlign: TextAlign.center,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            StockDetails.path,
            // arguments: data.symbol,
            arguments: {"slug": data.symbol},
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0.sp),
              // child: Container(
              //   padding: EdgeInsets.all(5.sp),
              //   width: 43.sp,
              //   height: 43.sp,
              //   child: ThemeImageView(url: data.image),
              // ),
              child: Container(
                width: 43.sp,
                height: 43.sp,
                padding: EdgeInsets.all(5.sp),
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
                    style: stylePTSansBold(fontSize: 14),
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
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  "${data.changes}%",
                  style: stylePTSansRegular(
                    fontSize: 12,
                    color: data.changes > 0 ? ThemeColors.accent : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
