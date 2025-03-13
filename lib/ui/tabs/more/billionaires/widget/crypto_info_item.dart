import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/crypto_detail_res.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CryptoInfoItem extends StatelessWidget {
  final DataRes? dataRes;
  const CryptoInfoItem({super.key, this.dataRes});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Pad.pad14, horizontal: Pad.pad16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(28, 150, 171, 209),
            blurRadius: 12,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.colour8d,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.symmetric(
                vertical: Pad.pad14, horizontal: Pad.pad16),
            alignment: Alignment.centerLeft,
            child: Text(
              dataRes?.title ?? "",
              style: styleBaseRegular(
                fontSize: 16,
                color: ThemeColors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CustomGridView(
            length: dataRes?.data?.length ?? 0,
            divider: true,
            getChild: (index) {
              BaseKeyValueRes? data = dataRes?.data?[index];
              return Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: Pad.pad10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.title ?? "",
                        style: styleBaseRegular(
                            fontSize: 12, color: ThemeColors.colour66),
                      ),
                      /* Text(
                            "15 Jul, 2010",
                            style: styleBaseRegular(fontSize: 8,color: ThemeColors.colour66),
                          ),*/
                      const SpacerVertical(height: Pad.pad8),
                      Text(
                        "${data?.value ?? ""}",
                        style: styleBaseRegular(
                          fontSize: 14,
                          color: ThemeColors.black,
                        ),
                      ),
                    ],
                  ));
            },
          ),
          /* ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              BaseKeyValueRes? data = dataRes?.data?[index];
              if (data == null) {
                return SizedBox();
              }
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: Pad.pad10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title??"",
                            style: styleBaseRegular(fontSize: 12,color: ThemeColors.colour66),
                          ),
                         */ /* Text(
                            "15 Jul, 2010",
                            style: styleBaseRegular(fontSize: 8,color: ThemeColors.colour66),
                          ),*/ /*
                          const SpacerVertical(height: Pad.pad8),
                          Text(
                            "${data.value??""}",
                            style: styleBaseRegular(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: ThemeColors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "High",
                            style: styleBaseRegular(fontSize: 12,color: ThemeColors.colour66),
                          ),
                          */ /*Text(
                            "15 Jul, 2010",
                            style: styleBaseRegular(fontSize: 8,color: ThemeColors.colour66),
                          ),*/ /*
                          const SpacerVertical(height: Pad.pad8),
                          Text(
                            "\$108,786.00",
                            style: styleBaseRegular(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: ThemeColors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return BaseListDivider();
            },
            itemCount: dataRes?.data?.length ?? 0,
          ),*/
        ],
      ),
    );
  }
}
