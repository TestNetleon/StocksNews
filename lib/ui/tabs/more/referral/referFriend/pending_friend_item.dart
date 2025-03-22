import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/managers/referral/referral_manager.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingFriendItem extends StatelessWidget {
  final PendingFriendData data;
  const PendingFriendItem({super.key, required this.data});

  _showBottomSheet() {
    BaseBottomSheet().bottomSheet(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Nudge your friend",
                  style: styleBaseBold(fontSize: 24),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: BaseButton(
                  text: "Send Notification and Email",
                  onPressed: () {
                    ReferralManager manager =
                        navigatorKey.currentContext!.read<ReferralManager>();
                    Navigator.pop(navigatorKey.currentContext!);
                    manager.nudgeAPI(
                      email: data.email,
                      dbId: data.dbId ?? 0,
                    );
                  },
                  // icon: Icons.email_outlined,
                ),
              ),
              const SpacerVertical(height: 10),
              SizedBox(
                width: double.infinity,
                child: BaseButton(
                  text: "Send Instant Message",
                  onPressed: () {
                    // _launchWhatsApp();
                    Share.share(
                      navigatorKey.currentContext!
                              .read<ReferralManager>()
                              .data
                              ?.nudgeText ??
                          "",
                    );
                  },
                  // icon: Icons.send,
                ),
              ),
              const SpacerVertical(height: 40)
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
      if (kDebugMode) {
        print('Could not launch $params');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.status == 0 ? _showBottomSheet : null,
      child: BaseBorderContainer(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(Pad.pad8),
        //   color: ThemeColors.itemBack,
        // ),
        innerPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        color: ThemeColors.itemBack,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Pad.pad14),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: data.imageType == "svg"
                          ? SvgPicture.network(
                              fit: BoxFit.cover,
                              height: 24,
                              width: 24,
                              data.image ?? "",
                              placeholderBuilder: (BuildContext context) =>
                                  Container(
                                padding: const EdgeInsets.all(30.0),
                                child: const CircularProgressIndicator(
                                  color: ThemeColors.accent,
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: data.image ?? "",
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SpacerHorizontal(width: Pad.pad10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: data.displayName != null &&
                              data.displayName != '',
                          child: Text(
                            data.displayName ?? "N/A",
                            style: styleBaseBold(fontSize: 18),
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Visibility(
                          visible: data.email != null &&
                              data.email != '' &&
                              data.status == 0,
                          child: Text(
                            // data?.email ?? "N/A",
                            encryptString(data.email ?? ""),
                            style: styleBaseRegular(),
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        SpacerVertical(height: Pad.pad5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Pad.pad32),
                            color: data.status == 1
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Pad.pad8,
                            vertical: Pad.pad3,
                          ),
                          child: Text(
                            (data.status == 1 ? " Verified" : "Unverified")
                                .toUpperCase(),
                            style: styleBaseBold(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${data.points ?? 0}",
                    style: styleBaseSemiBold(fontSize: 18),
                  ),
                ],
              ),
            ),
            BaseListDivider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.nudge,
                    height: 18,
                    color: ThemeColors.primary120,
                  ),
                  SpacerHorizontal(width: Pad.pad5),
                  Text(
                    "Click here to nudge your friend",
                    style: styleBaseSemiBold(
                      fontSize: 14,
                      color: ThemeColors.primary120,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
