import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/drawerScreens/fiftyTwoWeeks/fifty_two_high.dart';
import 'package:stocks_news_new/screens/drawerScreens/fiftyTwoWeeks/fifty_two_lows.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_tab_container.dart';

class FiftyTwoWeeksIndex extends StatelessWidget {
  static const path = "FiftyTwoWeeksIndex";
  const FiftyTwoWeeksIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: CustomTabContainerNEW(
          scrollable: false,
          tabsPadding: EdgeInsets.only(bottom: 10.sp),
          tabs: const ["52 Week Highs", "52 Week Lows"],
          widgets: const [
            FiftyTwoWeeksHighsStocks(),
            FiftyTwoWeeksLowsStocks(),
          ],
        ),
      ),
    );
  }
}
