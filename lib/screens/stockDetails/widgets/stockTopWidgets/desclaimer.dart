import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockDetailTopDisclaimer extends StatelessWidget {
  const StockDetailTopDisclaimer({super.key});
//
  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    KeyStats? keyStats = provider.data?.keyStats;
    if (keyStats?.exchange == null || keyStats?.marketStatus == null) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(left: 5.sp),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: keyStats?.exchange != null,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${keyStats?.exchange} ",
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.white,
                          ),
                        ),
                        TextSpan(
                          text: "Currency in ",
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                        TextSpan(
                          text: "USD ",
                          style: stylePTSansBold(fontSize: 12),
                        ),
                        TextSpan(
                          text: "Disclaimer",
                          style: stylePTSansRegular(
                              fontSize: 12,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                createRoute(
                                  const TCandPolicy(
                                    policyType: PolicyType.disclaimer,
                                  ),
                                ),
                              );
                              // Navigator.pushNamed(context, TCandPolicy.path,
                              //     arguments: PolicyType.disclaimer);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SpacerVertical(height: 3),
                Visibility(
                  visible: keyStats?.marketStatus != null,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.watch_later,
                        size: 15,
                        color: ThemeColors.greyText,
                      ),
                      const SpacerHorizontal(width: 5),
                      Text(
                        keyStats?.marketStatus ?? "",
                        style: stylePTSansRegular(
                          color: ThemeColors.greyText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              commonShare(
                title:
                    "${provider.data?.keyStats?.name} (${provider.data?.keyStats?.symbol})",
                url: provider.data?.shareUrl ?? "",
              );
            },
            child: const Icon(Icons.ios_share),
          )
          // Icon(Icons.ios_share)
        ],
      ),
    );
  }
}
