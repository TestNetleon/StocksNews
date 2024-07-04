import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';

class MarketDataTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final String? subTitle;
  final bool divider;
  final bool htmlTitle;
  final EdgeInsets? dividerPadding;
  final bool subTitleHtml;
  final dynamic provider;
  // final Function(String)? onDeleteExchange;
  final Function()? onFilterClick;

  const MarketDataTitle({
    this.title,
    this.style,
    super.key,
    this.dividerPadding,
    this.subTitle,
    this.divider = true,
    this.subTitleHtml = false,
    this.htmlTitle = false,
    this.provider,
    // this.onDeleteExchange,
    this.onFilterClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null)
                      htmlTitle
                          ? HtmlWidget(
                              title ?? "",
                              textStyle:
                                  style ?? styleGeorgiaBold(fontSize: 25),
                            )
                          : Text(
                              title ?? "",
                              style: style ?? styleGeorgiaBold(fontSize: 25),
                            ),
                    Visibility(
                      visible: subTitle != null && subTitle != "",
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: HtmlWidget(subTitle ?? "",
                            customWidgetBuilder: (element) =>
                                CustomReadMoreText(
                                  text: element.text,
                                )
                            // ReadMoreText(
                            //   textAlign: TextAlign.start,
                            //   element.text,
                            //   trimLines: 2,
                            //   colorClickableText: ThemeColors.accent,
                            //   trimMode: TrimMode.Line,
                            //   trimCollapsedText: ' Read more',
                            //   trimExpandedText: ' Read less',
                            //   moreStyle: stylePTSansRegular(
                            //     color: ThemeColors.accent,
                            //     fontSize: 12,
                            //     height: 1.3,
                            //   ),
                            //   style: stylePTSansRegular(
                            //     height: 1.3,
                            //     fontSize: 13,
                            //     color: ThemeColors.greyText,
                            //   ),
                            // ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: onFilterClick != null,
                child: GestureDetector(
                  onTap: onFilterClick,
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child:
                            Icon(Icons.filter_alt, color: ThemeColors.accent),
                      ),
                      if (provider.filterParams != null)
                        const Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 10,
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
          // Visibility( //   dividerVisible
          //   visible: divider,
          //   child: Padding(
          //     padding: dividerPadding ??
          //         const EdgeInsets.symmetric(vertical: Dimen.itemSpacing),
          //     // (provider.filterParams != null
          //     //     ? const EdgeInsets.only(
          //     //         top: Dimen.itemSpacing, bottom: Dimen.itemSpacing / 3)
          //     //     : const EdgeInsets.only(top: Dimen.itemSpacing)),
          //     child: const Divider(
          //       color: ThemeColors.accent,
          //       height: 2,
          //       thickness: 2,
          //     ),
          //   ),
          // ),
          // if (provider.filterParams != null)
          //   FilterUiValues(
          //     params: provider.filterParams,
          //     // onDeleteExchange: onDeleteExchange!,
          //     onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
          //     onDeleteSector: (exchange) => provider.sectorFilter(exchange),
          //     onDeleteIndustry: (exchange) => provider.industryFilter(exchange),
          //   ),
        ],
      ),
    );
  }
}
