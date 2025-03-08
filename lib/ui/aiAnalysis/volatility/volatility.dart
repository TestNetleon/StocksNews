import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/ui/aiAnalysis/volatility/ai_volatility.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PriceVolatility extends StatelessWidget {
  const PriceVolatility({super.key});

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: manager.data?.priceVolatility?.title,
          margin: EdgeInsets.only(
            right: Pad.pad16,
            left: Pad.pad16,
            top: 48,
            bottom: Pad.pad8,
          ),
        ),
        BaseBorderContainer(
          innerPadding: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: Pad.pad16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerVertical(),
              AiVolatility(),
              SpacerVertical(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ThemeColors.neutral5,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  manager.data?.priceVolatility?.data?.text??"",
                  style: styleBaseRegular(fontSize: 13),
                ),
              ),
              SpacerVertical(),
            ],
          ),
        ),
      ],
    );
  }
}
