import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../modals/membership.dart';
import '../../utils/colors.dart';

class MembershipItem extends StatelessWidget {
  final MembershipRes? data;
  const MembershipItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: ThemeColors.background,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data?.displayName == null || data?.displayName == ''
                        ? "N/A"
                        : data?.displayName ?? "N?A",
                    style: styleGeorgiaBold(fontSize: 17),
                  ),
                  Text(
                    data?.price ?? "N/A",
                    style: styleGeorgiaBold(fontSize: 17),
                  ),
                ],
              ),
              const SpacerVertical(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       data?.transactionId ?? "N/A",
              //       style: stylePTSansRegular(),
              //     ),
              //     Container(
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(30),
              //         color:
              //             data?.status == 0 ? ThemeColors.sos : ThemeColors.accent,
              //       ),
              //       child: Text(
              //         data?.status == 0 ? "EXPIRED" : "ACTIVE",
              //         style: styleGeorgiaBold(fontSize: 12),
              //       ),
              //     ),
              //   ],
              // ),

              const SpacerVertical(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Invoice ID",
                          style: stylePTSansRegular(
                            fontSize: 14,
                            color: ThemeColors.greyBorder,
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          "${data?.id}",
                          style: stylePTSansBold(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   data?.purchasedAt ?? "N/A",
                  //   style: stylePTSansRegular(color: ThemeColors.greyText),
                  // ),
                  const SpacerHorizontal(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Purchased on",
                          style: stylePTSansRegular(
                            fontSize: 14,
                            color: ThemeColors.greyBorder,
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          data?.purchasedAt ?? "N/A",
                          style: stylePTSansBold(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          bottom: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: data?.type == "NON_RENEWING_PURCHASE"
                  ? ThemeColors.accent
                  : const Color.fromARGB(255, 225, 218, 30),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
