import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class ReferHowDoesWork extends StatelessWidget {
  const ReferHowDoesWork({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      itemBuilder: (context, index) {
        // StepRes? data = homeProvider.extra?.howItWork?.steps?[index];
        return Padding(
          padding: const EdgeInsets.all(Dimen.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (index == 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimen.padding),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      textAlign: TextAlign.center,
                      "How does it work?",
                      style: stylePTSansRegular(fontSize: 24),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get Referral link",
                        style: stylePTSansBold(),
                      ),
                      Text(
                        "Get your unique referral link",
                        style: stylePTSansRegular(),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: ThemeColors.greyBorder,
          height: 25,
        );
      },
      itemCount: 3,

      // itemCount: homeProvider.extra?.howItWork?.steps?.length ?? 0,
    );
  }
}
