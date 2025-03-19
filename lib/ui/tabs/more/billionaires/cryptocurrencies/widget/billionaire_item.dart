import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/billionaires_index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BillionaireItem extends StatelessWidget {
  final CryptoTweetPost? item;
  final Function()? onTap;
  const BillionaireItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BaseBorderContainer(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: item?.name != null && item?.name != '',
            child: BaseHeading(
              title: "${item?.name}",
              titleStyle:
                  styleBaseBold(fontSize: 16, color: ThemeColors.splashBG),
              subtitleStyle:
                  styleBaseRegular(fontSize: 14, color: ThemeColors.splashBG),
              subtitle: item?.designation ?? "",
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          SpacerVertical(height: Pad.pad10),
          Visibility(
            visible: item?.symbols != null || item?.symbols?.isNotEmpty == true,
            child: SingleChildScrollView(
              child: Row(
                children: List.generate(
                  item!.symbols!.length,
                  (index) {
                    Symbols items = item!.symbols![index];
                    return Expanded(
                      child: BaseHeading(
                        title: "${items.count ?? ""}",
                        titleStyle: styleBaseBold(
                            fontSize: 20, color: ThemeColors.splashBG),
                        subtitleStyle: styleBaseRegular(
                            fontSize: 14, color: ThemeColors.splashBG),
                        subtitle: items.symbol ?? "",
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, BillionairesDetailIndex.path,
                  arguments: {'slug': item?.slug ?? ""});
            },
            label: Text(
              "SEE ALL MENTIONS",
              style: styleBaseRegular(
                  fontSize: 14, color: ThemeColors.secondary120),
            ),
            icon: Icon(Icons.arrow_right_alt_outlined,
                color: ThemeColors.secondary120),
            iconAlignment: IconAlignment.end,
          ),
          Visibility(
            visible: item?.image != null,
            child: Container(
              padding: EdgeInsets.all(Pad.pad8),
              decoration: BoxDecoration(
                  border: Border.all(color: ThemeColors.neutral10, width: 1),
                  shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(140),
                child: CachedNetworkImagesWidget(
                  item?.image ?? '',
                  height: 140,
                  width: 140,
                  placeHolder: Images.userPlaceholderNew,
                  showLoading: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
