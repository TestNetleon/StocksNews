import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/watchlist/widget/watchlist_sc_simmer.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/gradient_con_widget.dart';
import 'package:stocks_news_new/widgets/screen_title_simmer.dart';

class SectorScreenSimmer extends StatelessWidget {
  const SectorScreenSimmer({this.graphDataVisible = false, super.key});
  final bool graphDataVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenTitleSimmer(
            titleVisible: false,
          ),
          if (graphDataVisible)
            GradientContainerWidget(
              height: ScreenUtil().screenWidth / 2,
            ),
          const Expanded(child: WatchListScreenSimmer())
        ],
      ),
    );
  }
}
