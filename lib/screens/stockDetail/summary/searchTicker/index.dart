import 'package:flutter/material.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/stockDetail/summary/searchTicker/container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../utils/theme.dart';

tradeSheet() {
  showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return const SdSearchTicker();
      });
}

class SdSearchTicker extends StatelessWidget {
  const SdSearchTicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: double.infinity,
            curve: Curves.easeIn,
            child: _card(
              color: ThemeColors.accent,
              "Buy Stock",
              onTap: () {
                Navigator.push(
                  context,
                  createRoute(
                    const SdSearchContainer(),
                  ),
                );
              },
            ),
          ),
          const SpacerVertical(
            height: 10,
          ),
          AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            child: _card(
              color: ThemeColors.sos,
              "Sell Stock",
              onTap: () {
                Navigator.push(
                    context,
                    createRoute(
                      const SdSearchContainer(
                        buy: false,
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(
    text, {
    IconData? icon,
    Color? color = const Color.fromARGB(255, 194, 216, 51),
    Color? textColor = ThemeColors.background,
    EdgeInsetsGeometry? padding,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(navigatorKey.currentContext!);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Icon(
                icon ?? Icons.travel_explore_rounded,
                size: 20,
                color: textColor,
              ),
            ),
            Flexible(
              child: Text(
                "$text",
                style: stylePTSansBold(color: textColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
