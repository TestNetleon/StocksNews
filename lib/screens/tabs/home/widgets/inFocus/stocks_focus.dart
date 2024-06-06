import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/inFocus/item.dart';

class StocksInFocus extends StatelessWidget {
  const StocksInFocus({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visibility(
            //   child: Padding(
            //     padding: EdgeInsets.only(top: 15.sp),
            //     child: Text(
            //       "Stock in Focus",
            //       style: stylePTSansBold(),
            //     ),
            //   ),
            // ),
            // const SpacerVertical(height: 10),
            SizedBox(
              // height: constraints.maxWidth * 0.32,
              child: StocksInFocusItem(),

              // ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     physics: const BouncingScrollPhysics(),
              //     itemBuilder: (context, index) {
              //       return const StocksInFocusItem();
              //     },
              //     separatorBuilder: (context, index) {
              //       return const SpacerHorizontal(width: 10);
              //     },
              //     itemCount: 5),
            ),
          ],
        );
      },
    );
  }
}
