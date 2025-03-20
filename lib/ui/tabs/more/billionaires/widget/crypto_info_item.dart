import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/crypto_models/crypto_detail_res.dart';
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
        color: ThemeColors.white,
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
              color: ThemeColors.primary100,
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
              style: styleBaseBold(),
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
                            fontSize: 12,
                            fontFamily: "Roboto"
                        ),
                      ),
                      const SpacerVertical(height: Pad.pad8),
                      Text(
                        "${data?.value ?? ""}",
                        style: styleBaseRegular(
                          fontSize: 14,
                            fontFamily: "Roboto"
                        ),
                      ),
                    ],
                  ));
            },
          ),

        ],
      ),
    );
  }
}
