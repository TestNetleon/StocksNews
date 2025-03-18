import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class FAQItem extends StatelessWidget {
  final bool isOpen;
  final BaseFaqDataRes faq;
  final Function()? onChange;
  const FAQItem(
      {super.key, required this.isOpen, required this.faq, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimen.radius),
        border: Border.all(color: ThemeColors.neutral5),
      ),
      padding: EdgeInsets.all(Dimen.itemSpacing),
      child: Column(
        children: [
          GestureDetector(
            onTap: onChange,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    faq.question ?? "",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SpacerHorizontal(width: 5),
                Consumer<ThemeManager>(
                  builder: (context, value, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Pad.pad5),
                        border: Border.all(color: ThemeColors.neutral5),
                      ),
                      child: Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: ThemeColors.black,
                        // value.isDarkMode
                        //     ? ThemeColors.white
                        //     : ThemeColors.splashBG,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.topCenter,
            child: Container(
              height: isOpen ? null : 0,
              padding: EdgeInsets.only(top: Dimen.itemSpacing),
              child: Text(
                faq.answer ?? "",
                style: styleBaseRegular(
                  fontSize: 16,
                  color: ThemeColors.neutral20,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
