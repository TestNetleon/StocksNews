import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/stockDetail/extra/container.dart';
import 'package:stocks_news_new/ui/tabs/market/industries/industries_view.dart';
import 'package:stocks_news_new/ui/tabs/market/sectors/sector_view.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/stockDetail/overview.dart';
import '../../base/read_more.dart';

class SDCompanyBrief extends StatelessWidget {
  final SDCompanyRes? companyInfo;
  const SDCompanyBrief({
    super.key,
    this.companyInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerVertical(height: Pad.pad24),
          BaseHeading(title: companyInfo?.title),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: BaseReadMore(
              text: companyInfo?.description ?? '',
              trimLines: 2,
            ),
          ),
          SDColumnContainer(
            label: companyInfo?.ceo?.title ?? '',
            value: companyInfo?.ceo?.value,
            padding: EdgeInsets.only(bottom: Pad.pad8),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: SDColumnContainer(
                    label: companyInfo?.country?.title ?? '',
                    value: companyInfo?.country?.value,
                    padding: EdgeInsets.only(bottom: Pad.pad8, right: Pad.pad8),
                  ),
                ),
                Expanded(
                  child: SDColumnContainer(
                    label: companyInfo?.fullTimeEmployees?.title ?? '',
                    value: companyInfo?.fullTimeEmployees?.value,
                    padding: EdgeInsets.only(bottom: Pad.pad8),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: SDColumnContainer(
                    label: companyInfo?.ipoDate?.title ?? '',
                    value: companyInfo?.ipoDate?.value,
                    padding: EdgeInsets.only(bottom: Pad.pad8, right: Pad.pad8),
                  ),
                ),
                Expanded(
                  child: SDColumnContainer(
                    label: companyInfo?.isIn?.title ?? '',
                    value: companyInfo?.isIn?.value,
                    padding: EdgeInsets.only(bottom: Pad.pad8),
                  ),
                ),
              ],
            ),
          ),
          SDRowContainer(
            label: companyInfo?.sector?.title ?? '',
            value: companyInfo?.sector?.value,
            padding: EdgeInsets.only(bottom: Pad.pad8),
            onTap: () {
              Navigator.pushNamed(context, SectorViewIndex.path,
                  arguments: {'slug': companyInfo?.sector?.slug ?? ""});
            },
          ),
          SDRowContainer(
            label: companyInfo?.industry?.title ?? '',
            value: companyInfo?.industry?.value,
            padding: EdgeInsets.only(bottom: Pad.pad8),
            onTap: () {
              Navigator.pushNamed(context, IndustriesViewIndex.path,
                  arguments: {'slug': companyInfo?.industry?.slug ?? ""});
            },
          ),
          SDRowContainer(
            label: companyInfo?.website?.title ?? '',
            value: companyInfo?.website?.value,
            padding: EdgeInsets.only(bottom: Pad.pad8),
            onTap: () {
              openUrl(companyInfo?.website?.value);
            },
          ),
        ],
      ),
    );
  }

  // Widget _columnWidget({
  //   required String label,
  //   String? value,
  //   EdgeInsetsGeometry? padding,
  // }) {
  //   if (value == null || value == '') return SizedBox();
  //   return BaseBorderContainer(
  //     padding: padding,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Text(
  //           label,
  //           style: styleBaseRegular(color: ThemeColors.neutral80),
  //         ),
  //         SpacerVertical(height: 6),
  //         Text(
  //           value,
  //           style: styleBaseSemiBold(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _rowWidget({
  //   required String label,
  //   String? value,
  //   EdgeInsetsGeometry? padding,
  //   void Function()? onTap,
  // }) {
  //   if (value == null || value == '') return SizedBox();
  //   return BaseBorderContainer(
  //     onTap: onTap,
  //     padding: padding,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: styleBaseRegular(color: ThemeColors.neutral80),
  //         ),
  //         SpacerHorizontal(width: 8),
  //         Flexible(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               Flexible(
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(right: 8),
  //                   child: Text(
  //                     value,
  //                     textAlign: TextAlign.end,
  //                     style: styleBaseSemiBold(),
  //                   ),
  //                 ),
  //               ),
  //               Image.asset(
  //                 Images.moreItem,
  //                 height: 24,
  //                 width: 24,
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );

  // }
}
