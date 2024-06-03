import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/added/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PlaidHomeInvestmentOverview extends StatelessWidget {
  const PlaidHomeInvestmentOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePlaidAdded(),
            ),
          );
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
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Investment overview",
                style: stylePTSansBold(),
              ),
              const SpacerVertical(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NIFTY",
                          style:
                              stylePTSansRegular(color: ThemeColors.greyText),
                        ),
                        const SpacerVertical(height: 5),
                        RichText(
                          text: TextSpan(
                            text: "22,530.70 ",
                            style: stylePTSansRegular(
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: "0.18%",
                                style: stylePTSansRegular(
                                  fontSize: 13,
                                  color: ThemeColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Net Worth",
                          style:
                              stylePTSansRegular(color: ThemeColors.greyText),
                        ),
                        const SpacerVertical(height: 5),
                        RichText(
                          text: TextSpan(
                            text: "\$0.00",
                            style: stylePTSansRegular(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
