import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/drawerScreens/highLowPE/high_pe.dart';
import 'package:stocks_news_new/screens/drawerScreens/highLowPE/high_pe_growth.dart';
import 'package:stocks_news_new/screens/drawerScreens/highLowPE/low_pe.dart';
import 'package:stocks_news_new/screens/drawerScreens/highLowPE/low_pe_growth.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_tab_container.dart';

class HighLowPEIndex extends StatelessWidget {
  static const path = "HighLowPEIndex";
  const HighLowPEIndex({super.key});

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
          scrollable: true,
          tabsPadding: EdgeInsets.only(bottom: 10.sp),
          tabs: const [
            "High PE Ratio",
            "Low PE Ratio",
            "High PE Growth",
            "Low PE Growth"
          ],
          widgets: const [
            HighPeStocks(),
            LowPEStocks(),
            HighPeGrowthStocks(),
            LowPEGrowthStocks(),
          ],
        ),
      ),
    );
  }
}
