import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

msShowBottomSheet({String? html}) {
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: navigatorKey.currentContext!,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return MsBottomSheetItem(html: html);
    },
  );
}

class MsBottomSheetItem extends StatefulWidget {
  final String? html;
  const MsBottomSheetItem({super.key, this.html});

  @override
  State<MsBottomSheetItem> createState() => _MsBottomSheetItemState();
}

class _MsBottomSheetItemState extends State<MsBottomSheetItem> {
  // int _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          itemCount: 1,
          onPageChanged: (value) {
            // _activeIndex = value;
            // setState(() {});
          },
          itemBuilder: (context, index) {
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: const Color.fromARGB(255, 28, 28, 28),
                ),
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                padding: EdgeInsets.only(top: 50, left: 15, right: 15),
                child: SingleChildScrollView(
                  child: HtmlWidget(
                    widget.html ?? "",
                    textStyle: TextStyle(
                      color: ThemeColors.white,
                      fontFamily: Fonts.roboto,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
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
        // Positioned(
        //   bottom: 30,
        //   child: AnimatedSmoothIndicator(
        //     activeIndex: _activeIndex,
        //     count: 3,
        //     effect: ExpandingDotsEffect(
        //       activeDotColor: ThemeColors.accent,
        //       dotColor: ThemeColors.white,
        //       dotWidth: 8,
        //       expansionFactor: 3,
        //       dotHeight: 8,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
