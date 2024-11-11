import 'package:flutter/material.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../myTrades/all_index.dart';

class TournamentOpenIndex extends StatelessWidget {
  const TournamentOpenIndex({super.key});

  _navigateToAllTrades() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => AllTradesOrdersIndex(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: 'My Position',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _navigateToAllTrades,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeColors.greyText,
                        ),
                        child: Icon(
                          Icons.keyboard_double_arrow_down_rounded,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ThemeButton(
                    radius: 10,
                    text: 'Sell',
                    onPressed: () {},
                    color: ThemeColors.sos,
                  ),
                ),
                SpacerHorizontal(width: 10),
                Expanded(
                  child: ThemeButton(
                    radius: 10,
                    text: 'Buy',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SpacerVertical(height: 10),
          ],
        ),
      ),
    );
  }
}
