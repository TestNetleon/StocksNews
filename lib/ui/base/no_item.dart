import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/no_data.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class BaseNoItem extends StatelessWidget {
  final NoDataRes? noDataRes;
  final Function()? onTap;
  const BaseNoItem({super.key, this.noDataRes,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Pad.pad16),
                  child: Container(
                    padding: EdgeInsets.all(Pad.pad32),
                    decoration: BoxDecoration(
                      color: ThemeColors.neutral5,
                      borderRadius: BorderRadius.circular(Pad.pad16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: noDataRes?.icon ?? '',
                      height: 33,
                      width: 33,
                      color: ThemeColors.neutral60,
                    ),
                  ),
                ),
                BaseHeading(
                  title: noDataRes?.title,
                  margin: EdgeInsets.only(top: Pad.pad20),
                  subtitle: noDataRes?.subTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                  titleStyle: styleBaseBold(fontSize: 28,color: ThemeColors.splashBG),
                  subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral60),
                ),
                Visibility(
                  visible: noDataRes?.other!=null,
                  child: BaseHeading(
                    margin: EdgeInsets.zero,
                    textAlign: TextAlign.center,
                    subtitle: noDataRes?.other,
                    subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral60),
                  ),
                ),

              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: Pad.pad10),
            child: BaseButton(
              onPressed: onTap,
              text: noDataRes?.btnText??"",
              textColor: ThemeColors.splashBG,
              textSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
