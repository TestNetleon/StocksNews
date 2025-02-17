import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/ipo_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class IpoItem extends StatelessWidget {
  final int index;
  final IpoRes? data;
  const IpoItem({super.key, required this.index, this.data});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.push(context, InsiderDetailsType.path,
                          //     arguments: {
                          //       "companySlug": data?.companySlug,
                          //       "companyName": data?.companyName,
                          //     });
                        },
                        child: Text(
                          "${data?.company}",
                          style: stylePTSansBold(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SpacerVertical(height: 3),
                      InkWell(
                        onTap: () {
                          // Navigator.push(context, InsiderDetailsType.path,
                          //     arguments: {
                          //       "companySlug": data?.companySlug,
                          //       "companyName": data?.companyName,
                          //     });
                        },
                        child: Text(
                          "${data?.exchange}: ${data?.symbol}",
                          style: stylePTSansBold(
                            fontSize: 13,
                            color: ThemeColors.accent,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SpacerVertical(height: 15),
                      // InkWell(
                      //   onTap: () {
                      //     // Navigator.push(context, InsiderDetailsType.path,
                      //     //     arguments: {
                      //     //       "companySlug": data?.companySlug,
                      //     //       "reportingSlug": data?.reportingSlug,
                      //     //       "companyName": data?.companyName,
                      //     //       "reportingName": data?.reportingName,
                      //     //     });
                      //   },
                      //   child: Text(
                      //     "${data?.reportingName}",
                      //     style: stylePTSansBold(
                      //         fontSize: 14, color: ThemeColors.greyText),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                      // const SpacerVertical(height: 3),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         "${data?.typeOfOwner.capitalizeWords()}",
                      //         style: stylePTSansRegular(
                      //           color: ThemeColors.greyText,
                      //           fontSize: 12,
                      //         ),
                      //         maxLines: 2,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //     Flexible(
                      //       child: Text(
                      //         "${data?.securitiesTransacted} Shares @ ${data?.price}",
                      //         style: stylePTSansRegular(
                      //           color: ThemeColors.greyText,
                      //           fontSize: 12,
                      //         ),
                      //         maxLines: 2,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                // Expanded(
                //   flex: 2,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       // InkWell(
                //       //   onTap: () {
                //       //     Navigator.push(context, InsiderDetailsType.path,
                //       //         arguments: {
                //       //           "companySlug": data?.companySlug,
                //       //           "reportingSlug": data?.reportingSlug,
                //       //           "companyName": data?.companyName,
                //       //           "reportingName": data?.reportingName,
                //       //         });
                //       //   },
                //       //   child: Text(
                //       //     "${data?.reportingName.capitalizeWords()}",
                //       //     style: stylePTSansBold(fontSize: 14),
                //       //     maxLines: 1,
                //       //     overflow: TextOverflow.ellipsis,
                //       //   ),
                //       // ),
                //       const SpacerVertical(height: 5),
                //       // Text(
                //       //   "${data?.typeOfOwner.capitalizeWords()}",
                //       //   style: stylePTSansRegular(
                //       //     color: ThemeColors.greyText,
                //       //     fontSize: 12,
                //       //   ),
                //       //   maxLines: 2,
                //       //   overflow: TextOverflow.ellipsis,
                //       // ),
                //     ],
                //   ),
                // ),

                // const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${data?.actions}",
                        // "Buy",
                        style: stylePTSansBold(
                          fontSize: 14,
                          // color: data?.transactionType == "Buy"
                          //     ? ThemeColors.accent
                          //     : data?.transactionType == "Sell"
                          //         ? ThemeColors.sos
                          //         : ThemeColors.white,
                          color: ThemeColors.white,
                        )),
                    const SpacerVertical(height: 5),
                    GestureDetector(
                      onTap: () {
                        provider.open(
                          provider.openIndex == index ? -1 : index,
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          // color: data?.transactionType == "Buy"
                          //     ? ThemeColors.accent
                          //     : data?.transactionType == "Sell"
                          //         ? ThemeColors.sos
                          //         : ThemeColors.white,

                          color: ThemeColors.white,
                        ),
                        margin: EdgeInsets.only(left: 8.sp),
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          // provider.openIndex == index
                          //     ? Icons.arrow_upward_rounded
                          //     : Icons.arrow_downward_rounded,
                          Icons.arrow_downward_rounded,
                          color: ThemeColors.background,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "typeOfOwner",
                    style: stylePTSansRegular(
                      color: ThemeColors.greyText,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  // "${data?.securitiesTransacted} Shares @ ${data?.price}",
                  "securitiesTransacted Shares @ price",
                  style: stylePTSansRegular(
                    color: ThemeColors.greyText,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: index == provider.openIndex ? null : 0,
            margin: EdgeInsets.only(
              top: provider.openIndex == index ? 10.sp : 0,
              bottom: provider.openIndex == index ? 10.sp : 0,
            ),
            child: const Column(
              children: [
                // InnerRowItem(
                //   lable: "Shares Bought/Sold",
                //   // value: "${data?.securitiesTransacted}",
                //   value: "securitiesTransacted",

                //   subLabel: "@ Price",
                //   // subValue: "@ ${data?.price}",
                //   subValue: "@ .price",
                // ),
                InnerRowItem(
                  lable: "Total Transaction",
                  // value: "${data?.totalTransaction}",
                  value: "totalTransaction",
                ),
                InnerRowItem(
                  lable: "Shares Held After Transaction",
                  // value: "${data?.securitiesOwned}",
                  value: "securitiesOwned",
                ),
                InnerRowItem(
                  lable: "Transaction Date",
                  // value: "${data?.transactionDateNew}",
                  value: "data?.transactionDateNew",
                ),
                InnerRowItem(
                  lable: "Details",
                  link: true,
                  // value: "${data?.link}",
                  value: "data?.link",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
