import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class BuyOrderItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? icon;
  final void Function()? onTap;
  final void Function()? onInfoTap;
  final bool infoVisible;
  const BuyOrderItem(
      {super.key,
      this.title,
      this.subtitle,
      this.icon,
      this.onTap,
      this.infoVisible = false,
      this.onInfoTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: Pad.pad5,
      //visualDensity: VisualDensity(vertical: 0, horizontal: 0),
      leading:
      ClipRRect(
        borderRadius: BorderRadius.circular(Pad.pad5),
        child: Container(
          padding: EdgeInsets.all(5.sp),
          color: ThemeColors.neutral5,
          child: CachedNetworkImagesWidget(
            icon ?? "",
            height: 28,
            width: 28,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            title ?? "",
            style: styleBaseBold(color: ThemeColors.splashBG, fontSize: 14),
          ),
          Visibility(visible: infoVisible, child: SpacerHorizontal(width: 5)),
          Visibility(
              visible: infoVisible,
              child: InkWell(
                  onTap: onInfoTap,
                  child: Icon(Icons.info_sharp,
                      color: ThemeColors.greyBorder, size: 16)))
        ],
      ),
      subtitle: subtitle != null && subtitle != ""
          ? Text(
              subtitle ?? "",
              style:
                  styleBaseRegular(fontSize: 13, color: ThemeColors.neutral40),
            )
          : null,
      trailing: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Pad.pad3),
            border: Border.all(color: ThemeColors.neutral5, width: 1)),
        child: Icon(
          Icons.arrow_forward_ios_sharp,
          color: ThemeColors.greyText,
          size: 18,
        ),
      ),
      onTap: onTap,
    );
  }
}
