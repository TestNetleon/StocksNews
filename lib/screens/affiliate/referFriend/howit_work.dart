import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class HowItWorkItem extends StatelessWidget {
  final int index;
  final StepRes? data;
  final Color subtitle;
  final Color colorKey;
  const HowItWorkItem(
      {super.key,
      required this.index,
      this.data,
      this.subtitle = ThemeColors.greyText,
      this.colorKey = const Color.fromARGB(255, 6, 115, 23)});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        index == 0
            ? const Icon(
                Icons.link,
                size: 20,
              )
            : index == 1
                ? const Icon(
                    Icons.person_add_alt_outlined,
                    size: 20,
                  )
                : index == 2
                    ? const Icon(
                        Icons.card_giftcard_sharp,
                        size: 20,
                      )
                    : const Icon(
                        Icons.view_column_outlined,
                        size: 20,
                      ),
        const SpacerHorizontal(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: colorKey,
                    ),
                    child: Text(
                      data?.key ?? "",
                      style: stylePTSansBold(fontSize: 12),
                    ),
                  ),
                  const SpacerHorizontal(width: 10),
                  Flexible(
                    child: Text(
                      data?.title ?? "",
                      style: stylePTSansBold(),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: data?.subTitle != null && data?.subTitle != '',
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    data?.subTitle ?? "",
                    style: stylePTSansRegular(color: subtitle),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
