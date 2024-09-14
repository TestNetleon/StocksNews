import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';

msShowBottomSheet() {
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: navigatorKey.currentContext!,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return MsBottomSheetItem();
    },
  );
}

class MsBottomSheetItem extends StatefulWidget {
  const MsBottomSheetItem({super.key});

  @override
  State<MsBottomSheetItem> createState() => _MsBottomSheetItemState();
}

class _MsBottomSheetItemState extends State<MsBottomSheetItem> {
  int _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          itemCount: 3,
          onPageChanged: (value) {
            _activeIndex = value;
            setState(() {});
          },
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 28, 28, 28),
              ),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            );
          },
        ),
        Positioned(
          top: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              size: 30,
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          child: AnimatedSmoothIndicator(
            activeIndex: _activeIndex,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: ThemeColors.accent,
              dotColor: ThemeColors.white,
              dotWidth: 8,
              expansionFactor: 3,
              dotHeight: 8,
            ),
          ),
        ),
      ],
    );
  }
}
