import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/fcm/dynamic_links.service.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

import '../../../../modals/refer.dart';
import '../../../../providers/home_provider.dart';
import '../../../../route/my_app.dart';

class ReferSuccess extends StatefulWidget {
  const ReferSuccess({super.key});

  @override
  State<ReferSuccess> createState() => _ReferSuccessState();
}

class _ReferSuccessState extends State<ReferSuccess> {
  Uri? shareUri;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ReferSuccessRes? referData = context.read<UserProvider>().refer;
      shareUri = await DynamicLinkService.instance
          .getDynamicLink(referData?.referralCode);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ReferSuccessRes? referData = context.watch<UserProvider>().refer;
    return BaseContainer(
      appBar: const AppBarHome(
        isHome: true,
        isPopback: true,
        showTrailing: false,
      ),
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
                          "Invite your friend",
                          style: stylePTSansBold(fontSize: 24),
                        ),
                        const SpacerVertical(height: 3),
                        Text(
                          "Share your link with your friend and earn reward points",
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
                                            topLeft: Radius.circular(4))),
                                    child: Text(
                                      "${shareUri ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: stylePTSansRegular(),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: shareUri.toString()));
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8.9),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 69, 69, 69),
                                      // borderRadius: BorderRadius.all(
                                      //     Radius.circular(4)),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(4),
                                          topRight: Radius.circular(4)),
                                    ),
                                    // child: Text(
                                    //   "Copy",
                                    //   maxLines: 1,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: stylePTSansBold(),
                                    // ),
                                    child: const Icon(
                                      Icons.copy,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SpacerVertical(height: 20),
                    if (shareUri != null)
                      ThemeButtonSmall(
                        onPressed: () {
                          Share.share(
                            "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
                          );
                        },
                        text: "Share with friends",
                        icon: Icons.share,
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
