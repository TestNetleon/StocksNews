import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';

import '../../../widgets/theme_button.dart';
import '../route/my_app.dart';

class SubscriptionPurchased extends StatefulWidget {
  final bool isMembership;
  const SubscriptionPurchased({
    super.key,
    this.isMembership = false,
  });

  @override
  State<SubscriptionPurchased> createState() => _SubscriptionPurchasedState();
}

class _SubscriptionPurchasedState extends State<SubscriptionPurchased> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      popHome = true;
      context.read<HomeProvider>().getHomeSlider();
    });
  }

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        onTap: () {
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => const Tabs()),
          //     (route) => false);
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const Tabs()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Image.asset(
                  Images.referSuccess,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  provider.success?.title ?? "SUCCESS",
                  textAlign: TextAlign.center,
                  style: stylePTSansBold(fontSize: 35),
                ),
                const SpacerVertical(),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ThemeColors.tabBack,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(125, 35, 63, 45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        // margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.home,
                              size: 20,
                              color: ThemeColors.themeGreen,
                            ),
                            const SpacerHorizontal(width: 10),
                            Text(
                              "You have also received 10 coins!",
                              style: styleGeorgiaBold(
                                color: ThemeColors.themeGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpacerVertical(height: 12),
                      InvoiceItem(),
                      const SpacerVertical(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            style: stylePTSansRegular(),
                          ),
                          Text(
                            "Name",
                            style: stylePTSansBold(),
                          )
                        ],
                      )

                      // const SpacerVertical(height: 20),
                      // Visibility(
                      //   visible: widget.isMembership,
                      //   child: Text(
                      //     provider.success?.description ??
                      //         "Your membership purchase is successful. It may take 3-5 minutes to reflect.",
                      //     textAlign: TextAlign.center,
                      //     style: stylePTSansRegular(
                      //       fontSize: 20,
                      //       color: ThemeColors.greyText,
                      //     ),
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: !widget.isMembership,
                      //   child: Text(
                      //     provider.success?.description ??
                      //         "Your points purchase is successful. It may take 3-5 minutes to reflect.",
                      //     textAlign: TextAlign.center,
                      //     style: stylePTSansRegular(
                      //       fontSize: 20,
                      //       color: ThemeColors.greyText,
                      //     ),
                      //   ),
                      // ),
                      // const SpacerVertical(height: 20),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   child: Text(
                      //     provider.success?.subTitle ??
                      //         "Explore Stocks.News without limits.",
                      //     textAlign: TextAlign.center,
                      //     style: stylePTSansRegular(
                      //       fontSize: 20,
                      //       color: ThemeColors.greyText,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const SpacerVertical(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ThemeButton(
                text: "GO TO HOME",
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Tabs()),
                    (routes) => false,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InvoiceItem extends StatelessWidget {
  const InvoiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Name",
          style: stylePTSansRegular(),
        ),
        Text(
          "Name",
          style: stylePTSansBold(),
        )
      ],
    );
  }
}
