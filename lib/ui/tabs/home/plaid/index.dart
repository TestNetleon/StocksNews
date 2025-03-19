import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/models/tools.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PlaidHomeGetStarted extends StatefulWidget {
  const PlaidHomeGetStarted({super.key});

  @override
  State<PlaidHomeGetStarted> createState() => _PlaidHomeGetStartedState();
}

class _PlaidHomeGetStartedState extends State<PlaidHomeGetStarted> {
  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();
    ToolsRes? data = manager.homePremiumData?.plaid;
    bool isDark = context.watch<ThemeManager>().isDarkMode;
    if (data?.status == true) {
      return SizedBox();
    }
    return Container(
      margin:
          EdgeInsets.only(left: Pad.pad16, right: Pad.pad16, top: Pad.pad20),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: isDark
                    ? Image.asset(
                        Images.portfolioCard,
                        color: ThemeColors.greyBorder.withValues(alpha: 0.33),
                        fit: BoxFit.cover,
                      )
                    : ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          color: Color(0xFF47C189),
                        ),
                      ),
              ),
              InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                onTap: () {
                  ToolsManager toolsManager = context.read<ToolsManager>();
                  toolsManager.startNavigation(ToolsEnum.portfolio);
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 23, 23, 23),
                        Color.fromARGB(255, 48, 48, 48),
                      ],
                    ),
                    // color: Colors.black,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(Images.appLogoIcon)),
                      ),
                      const SpacerHorizontal(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data?.top?.title?.capitalizeWords() ?? "",
                              style: styleBaseBold(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SpacerVertical(height: 3),
                            HtmlWidget(
                              data?.top?.subTitle ?? "",
                              textStyle: styleBaseRegular(
                                fontSize: 12,
                                color: isDark
                                    ? ThemeColors.greyText
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpacerHorizontal(width: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(14, 4, 14, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDark ? ThemeColors.accent : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Sync",
                              style: styleBaseBold(
                                fontSize: 15,
                                color: ThemeColors.black,
                              ),
                            ),
                            const SpacerHorizontal(width: 5),
                            Icon(
                              Icons.sync,
                              size: 18,
                              color: ThemeColors.black,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: data?.top?.portfolioEarnPoint != null,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? null : ThemeColors.secondary120,
                gradient: isDark
                    ? LinearGradient(
                        colors: [
                          ThemeColors.bottomsheetGradient,
                          ThemeColors.accent,
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.pointIcon2,
                    height: 20,
                    width: 20,
                  ),
                  const SpacerHorizontal(width: 5),
                  Flexible(
                    child: Text(
                      data?.top?.portfolioEarnPoint ?? "",
                      style: styleBaseBold(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
