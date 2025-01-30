import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class BuyOrderItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? icon;
  final void Function()? onTap;
  const BuyOrderItem(
      {super.key, this.title, this.subtitle, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minTileHeight: 60,
      leading: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: ThemeColors.gradientLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.auto_graph,
            color: ThemeColors.white,
          )),
      title: Text(
        title ?? "",
        style: styleGeorgiaBold(
          color: ThemeColors.blackShade,
        ),
      ),
      subtitle: subtitle != null && subtitle != ""
          ? Text(
              subtitle ?? "",
              style: styleGeorgiaRegular(
                  fontSize: 12, color: ThemeColors.greyText),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: ThemeColors.greyText,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
