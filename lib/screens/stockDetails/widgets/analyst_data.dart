import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockDetailAnalystData extends StatelessWidget {
  const StockDetailAnalystData({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: ThemeColors.greyBorder.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: ThemeColors.accent.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "64% analysts say Buy",
                      style: stylePTSansBold(
                          color: ThemeColors.accent, fontSize: 18),
                    ),
                    const SpacerVertical(height: 5),
                    Text(
                      "Expected target price: 585.00 - \$800.00",
                      style: stylePTSansRegular(color: ThemeColors.greyText),
                    ),
                  ],
                ),
              ),
              const SpacerVertical(height: 15),
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: ThemeColors.accent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SpacerHorizontal(width: 2),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 191, 52),
                      ),
                    ),
                  ),
                  const SpacerHorizontal(width: 2),
                  Flexible(
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 5),
              Row(
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Buy 64%",
                        style: stylePTSansRegular(
                          color: ThemeColors.accent,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Hold 27%",
                        style: stylePTSansRegular(
                          color: const Color.fromARGB(255, 255, 191, 52),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Sell 9%",
                        style: stylePTSansRegular(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                          color: ThemeColors.greyBorder,
                        ),
                        const SpacerHorizontal(width: 5),
                        Flexible(
                          child: Text(
                            "11 analysts",
                            style: stylePTSansRegular(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: ThemeColors.greyBorder,
                        ),
                        const SpacerHorizontal(width: 5),
                        Flexible(
                          child: Text(
                            "Updated on 03 Jun 2024",
                            style: stylePTSansRegular(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 20),
              Text(
                "Source: EveningStar",
                style: stylePTSansRegular(
                    fontSize: 12, color: ThemeColors.greyText),
              )
            ],
          ),
        );
      },
    );
  }
}
