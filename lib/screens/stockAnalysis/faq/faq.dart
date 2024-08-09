import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PredictionFaqs extends StatefulWidget {
  const PredictionFaqs({super.key});

  @override
  State<PredictionFaqs> createState() => _PredictionFaqsState();
}

class _PredictionFaqsState extends State<PredictionFaqs> {
  List<Map<String, dynamic>> faqs = [
    {
      "question": "What factors should I consider before buying a stock?",
      "answer":
          "Before buying a stock, consider factors such as the company's financial health, industry trends, market conditions, the company's competitive position, and your investment goals and risk tolerance.",
    },
    {
      "question": 'How do I know when to sell a stock?',
      "answer":
          "Consider selling a stock if it no longer aligns with your investment goals, the company's fundamentals have deteriorated, you need to rebalance your portfolio, or you need to liquidate for cash. ",
    },
    {
      "question": 'What does it mean to hold a stock?',
      "answer":
          'Holding a stock means keeping it in your portfolio without buying more or selling it. Investors often hold stocks they believe will grow over the long term or to avoid realizing capital gains taxes.',
    },
    {
      "question": 'What is a market order?',
      "answer":
          ' A market order is a request to buy or sell a stock at the current market price. Market orders are executed immediately but do not guarantee the price.',
    },
    {
      "question": 'How can I manage risk when buying or selling stocks?',
      "answer":
          'A stop-loss order is an order to sell a stock when it reaches a specific price. It helps limit losses by automatically selling the stock if its price falls to the predetermined level.',
    },
  ];

  List<bool> isSelectedList = List.generate(5, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequently asked question',
            style: stylePTSansBold(fontSize: 18, color: Colors.white)),
        ListView.separated(
          itemCount: faqs.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 16.sp),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimen.radius.r),
                border:
                    Border.all(color: const Color.fromARGB(255, 252, 251, 251)),
                // color: ThemeColors.background,
              ),
              padding: EdgeInsets.all(Dimen.itemSpacing.sp),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelectedList[index] = !isSelectedList[index];
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            faqs[index]["question"].toString(),
                            style: stylePTSansBold(fontSize: 16),
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Icon(
                          isSelectedList[index]
                              ? Icons.remove_rounded
                              : Icons.add_rounded,
                          color: ThemeColors.lightGreen,
                        ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 100),
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: isSelectedList[index] ? null : 0,
                      padding: EdgeInsets.only(top: Dimen.itemSpacing.sp),
                      child: Text(
                        faqs[index]["answer"].toString(),
                        style: stylePTSansRegular(
                            fontSize: 14, color: ThemeColors.greyText),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SpacerVertical(height: 12);
          },
        ),
      ],
    );
  }
}
