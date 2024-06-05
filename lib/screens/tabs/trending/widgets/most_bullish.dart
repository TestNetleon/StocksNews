import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bullish_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';

class MostBullish extends StatelessWidget {
  const MostBullish({super.key});

  @override
  Widget build(BuildContext context) {
    TrendingProvider provider = context.watch<TrendingProvider>();
    TrendingRes? data = provider.mostBullish;

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Trending - Most Bullish"},
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: data?.text?.mostBullish != '',
          child: Padding(
            padding: EdgeInsets.only(bottom: isPhone ? 20.sp : 5.sp),
            child: Text(
              data?.text?.mostBullish ?? "",
              style: stylePTSansRegular(
                fontSize: 13,
                color: ThemeColors.greyText,
              ),
            ),
          ),
        ),
        ListView.separated(
          itemCount: data?.mostBullish?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MostBullishData? bullishData = data?.mostBullish![index];
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: ThemeColors.greyBorder,
                    height: 15.sp,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      const SpacerHorizontal(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          maxLines: 1,
                          "COMPANY",
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ),
                      // const SpacerHorizontal(width: 24),
                      const SpacerHorizontal(width: 10),

                      Expanded(
                        // flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              maxLines: 1,
                              "PRICE",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                            AutoSizeText(
                              maxLines: 1,
                              "(% Change)",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            "MENTIONS",
                            textAlign: TextAlign.end,
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            "(% Change)",
                            textAlign: TextAlign.end,
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ],
                      ),
                      const SpacerHorizontal(width: 10),
                    ],
                  ),
                  Divider(
                    color: ThemeColors.greyBorder,
                    height: 15.sp,
                    thickness: 1,
                  ),
                  MostBullishItem(
                    alertForBullish: bullishData?.isAlertAdded ?? 0,
                    watlistForBullish: bullishData?.isWatchlistAdded ?? 0,
                    data: bullishData!,
                    up: true,
                    index: index,
                  ),
                ],
              );
            }

            return MostBullishItem(
              alertForBullish: bullishData?.isAlertAdded ?? 0,
              watlistForBullish: bullishData?.isWatchlistAdded ?? 0,
              data: bullishData!,
              up: true,
              index: index,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            // return const SpacerVertical(height: 12);
            return const Divider(
              color: ThemeColors.greyBorder,
              height: 12,
            );
          },
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          // color: ThemeColors.background,
          child: HtmlWidget(
            customStylesBuilder: (element) {
              if (element.localName == 'a') {
                return {'color': '#1bb449', 'text-decoration': 'none'};
              }
              return null;
            },
            onTapUrl: (url) async {
              bool a = await launchUrl(Uri.parse(url));
              Utils().showLog("clicked ur---$url, return value $a");
              return a;
            },
            "<p style=\"background: #28312c; display: inline-block; padding: 10px; border-left: solid 3px #1bb449; margin: 0;\"><span style=\"color: #ffff00;\">Disclaimer:<\/span> Information provided is for informational purposes only, not investment advice. We do not recommend buying or selling stocks. Stock price discussions are based on publicly available data. Readers should conduct their own research or consult a financial advisor before investing. Owners of this site have current positions in stocks mentioned thru out the site, Please Read Full Disclaimer for details here <a href=\"https:\/\/app.stocks.news\/page\/disclaimer\">https:\/\/app.stocks.news\/page\/disclaimer<\/a><\/p>",
            textStyle: styleGeorgiaRegular(
              fontSize: 11,
              height: 1.5,
              color: ThemeColors.greyText,
            ),
          ),
        )
      ],
    );
  }
}
