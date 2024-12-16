import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

import '../../../../modals/refer.dart';
import '../../../../providers/home_provider.dart';
import '../../../routes/my_app.dart';

class ReferSuccess extends StatefulWidget {
  const ReferSuccess({super.key});

  @override
  State<ReferSuccess> createState() => _ReferSuccessState();
}

class _ReferSuccessState extends State<ReferSuccess> {
  @override
  Widget build(BuildContext context) {
    ReferSuccessRes? referData = context.watch<UserProvider>().refer;
    return BaseContainer(
      appBar: const AppBarHome(isPopBack: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  Images.referSuccess,
                  height: 230,
                  width: 300,
                ),
              ),
              HtmlWidget(
                referData?.successTitle ??
                    "Your account has been\nverified successfully",
                // textAlign: TextAlign.center,

                textStyle: stylePTSansBold(fontSize: 30),
              ),
              const SpacerVertical(height: 10),
              HtmlWidget(
                referData?.successSubTitle ??
                    "Thank you for your trust now \nyou can refer and earn reward points.",
                // textAlign: TextAlign.center,
                textStyle:
                    stylePTSansBold(fontSize: 17, color: ThemeColors.greyText),
              ),
              const SpacerVertical(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ThemeColors.greyBorder.withOpacity(0.4)),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Invite your friends",
                          style: stylePTSansBold(fontSize: 24),
                        ),
                        const SpacerVertical(height: 3),
                        Text(
                          "Share your link with your friends and earn reward points",
                          style: stylePTSansRegular(
                              fontSize: 14, color: ThemeColors.greyText),
                        ),
                        const SpacerVertical(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SpacerVertical(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Ink(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    decoration: const BoxDecoration(
                                      color: ThemeColors.greyBorder,
                                      // borderRadius: BorderRadius.all(
                                      //     Radius.circular(4)),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(4),
                                        topLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      "${shareUri ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: stylePTSansRegular(),
                                    ),
                                  ),
                                ),
                                // InkWell(
                                //   borderRadius: const BorderRadius.all(
                                //     Radius.circular(4),
                                //   ),
                                //   onTap: () {
                                //     Share.share(
                                //       "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                                //     );
                                //     // try {
                                //     //   Clipboard.setData(ClipboardData(
                                //     //       text: shareUri.toString()));
                                //     //   CommonToast.show(message: "Copied");
                                //     // } catch (e) {
                                //     //   CommonToast.show(message: "$e");
                                //     // }
                                //   },
                                //   child: Ink(
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 15, vertical: 8.9),
                                //     decoration: const BoxDecoration(
                                //       color: Color.fromARGB(255, 69, 69, 69),
                                //       // borderRadius: BorderRadius.all(
                                //       //     Radius.circular(4)),
                                //       borderRadius: BorderRadius.only(
                                //           bottomRight: Radius.circular(4),
                                //           topRight: Radius.circular(4)),
                                //     ),
                                //     // child: Text(
                                //     //   "Copy",
                                //     //   maxLines: 1,
                                //     //   overflow: TextOverflow.ellipsis,
                                //     //   style: stylePTSansBold(),
                                //     // ),
                                //     child: const Icon(
                                //       Icons.copy,
                                //       size: 20,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SpacerVertical(height: 20),
                    if (shareUri != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: ThemeButtonSmall(
                              iconFront: true,
                              color: const Color.fromARGB(255, 3, 94, 15),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  navigatorKey.currentContext!,
                                  MaterialPageRoute(
                                    builder: (_) => const ReferAFriend(),
                                  ),
                                );
                              },
                              text: "Affiliate Panel",
                              icon: Icons.dashboard,
                            ),
                          ),
                          const SpacerHorizontal(width: 6),
                          ThemeButtonSmall(
                            iconFront: true,
                            onPressed: () {
                              Share.share(
                                "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                              );
                            },
                            text: "Share Link",
                            icon: Icons.share,
                          ),
                        ],
                      ),
                    Align(
                      // alignment: Alignment.centerLeft,
                      child: ThemeButtonSmall(
                        iconFront: true,
                        color: const Color.fromARGB(255, 3, 94, 15),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Tabs()),
                              (route) => false);
                        },
                        text: "Go to Home",
                        icon: Icons.home,
                      ),
                    ),

                    // Row(
                    //   children: [
                    //     _widgetIcon(
                    //       image: Images.referW,
                    //       onTap: () {
                    //         String baseUrl =
                    //             "https://api.whatsapp.com/send?text=Text www.google.com";
                    //         String url = Platform.isAndroid
                    //             ? baseUrl
                    //             : 'whatsapp://send?text=Text www.google.com';

                    //         openUrl(url, extraUrl: baseUrl);
                    //       },
                    //     ),
                    //     _widgetIcon(
                    //       image: Images.referT,
                    //     ),
                    //     _widgetIcon(
                    //       image: Images.referF,
                    //       onTap: () async {
                    //         String encodedUrl =
                    //             Uri.encodeFull("www.google.com");

                    //         String baseUrl =
                    //             "https://www.facebook.com/sharer/sharer.php?u=www.google.com&quote=Text";

                    //         String url = Platform.isAndroid
                    //             ? baseUrl
                    //             : "fb://share/?url=$encodedUrl";

                    //         await openUrl(url, extraUrl: baseUrl);
                    //       },
                    //     ),
                    //     _widgetIcon(image: Images.referE),
                    //     _widgetIcon(image: Images.referS),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetIcon({
    Function()? onTap,
    required String image,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 26, 26, 26), shape: BoxShape.circle),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              image,
              height: 17,
              width: 17,
              color: ThemeColors.white,
            ),
          ),
        ),
        const SpacerHorizontal(width: 10),
      ],
    );
  }
}
