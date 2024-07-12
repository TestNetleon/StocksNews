import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/cache_network_image.dart';
import '../../../modals/affiliate/refer_friend_res.dart';
import '../../../route/my_app.dart';
import '../../../utils/constants.dart';

class AffiliateReferItem extends StatelessWidget {
  final AffiliateReferRes? data;
  final int index;
  const AffiliateReferItem({super.key, required this.index, this.data});

  _showBottomSheet() {
    showModalBottomSheet(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      backgroundColor: ThemeColors.transparent,
      isScrollControlled: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return _sheet();
      },
    );
  }

  String encryptString(String input) {
    if (input.length <= 4) {
      return input;
    }
    String firstPart = input.substring(0, 2);
    String lastPart = input.substring(input.length - 4);
    String encryptedPart = '*' * (input.length - 4);
    return firstPart + encryptedPart + lastPart;
  }

  Widget _sheet() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThemeColors.bottomsheetGradient, Colors.black],
        ),
        // gradient: RadialGradient(
        //   center: Alignment.bottomCenter,
        //   radius: 0.6,
        //   // transform: GradientRotation(radians),
        //   // tileMode: TileMode.decal,
        //   stops: [
        //     0.0,
        //     0.9,
        //   ],
        //   colors: [
        //     Colors.black,
        //     Colors.black,
        //   ],
        // ),
        color: ThemeColors.background,
        border: Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ScreenTitle(
                  title: "Nudge your friend",
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ThemeButtonSmall(
                  text: "Send Notification and Email",
                  onPressed: () {
                    LeaderBoardProvider provider = navigatorKey.currentContext!
                        .read<LeaderBoardProvider>();
                    Navigator.pop(navigatorKey.currentContext!);
                    provider.nudgeAPI(
                      email: data?.email,
                      dbId: data?.dbId ?? 0,
                    );
                  },
                  icon: Icons.email_outlined,
                ),
              ),
              const SpacerVertical(height: 10),
              SizedBox(
                width: double.infinity,
                child: ThemeButtonSmall(
                  text: "Send Instant Message",
                  onPressed: () {
                    // _launchWhatsApp();
                    Share.share(
                      navigatorKey.currentContext!
                              .read<LeaderBoardProvider>()
                              .extra
                              ?.nudgeText ??
                          "",
                    );
                  },
                  icon: Icons.send,
                ),
              ),
              const SpacerVertical(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  void _launchWhatsApp({String? text}) async {
    final Uri params = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '+918560060463',
      queryParameters: {'text': text ?? 'Hello, I need support'},
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      print('Could not launch $params');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data?.status == 0 ? _showBottomSheet : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImagesWidget(
                      data?.image,
                      placeHolder: Images.userPlaceholder,
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: data?.displayName != null &&
                            data?.displayName != '',
                        child: Text(
                          data?.displayName ?? "N/A",
                          style: stylePTSansBold(fontSize: 18),
                        ),
                      ),
                      const SpacerVertical(height: 5),
                      Visibility(
                        visible: data?.email != null &&
                            data?.email != '' &&
                            data?.status == 0,
                        child: Text(
                          // data?.email ?? "N/A",
                          encryptString(data?.email ?? ""),
                          style: stylePTSansRegular(),
                        ),
                      ),
                      const SpacerVertical(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: data?.status == 1
                                ? ThemeColors.accent
                                : ThemeColors.sos),
                        child: Text(
                          (data?.status == 1 ? " Verified" : "Unverified")
                              .toUpperCase(),
                          style: stylePTSansBold(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${data?.points ?? 0}",
                  style: stylePTSansBold(fontSize: 17),
                ),
              ],
            ),
            Visibility(
              visible: data?.status == 0,
              // visible:
              //     context.watch<LeaderBoardProvider>().data?[index].timer != 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Divider(
                    color: ThemeColors.greyBorder,
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.nudge,
                        height: 20,
                        width: 20,
                        color: ThemeColors.accent,
                      ),
                      const SpacerHorizontal(width: 5),
                      Flexible(
                        child: Text(
                          "Click here to nudge your friend",
                          style: stylePTSansBold(
                            fontSize: 14,
                            color: ThemeColors.accent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
