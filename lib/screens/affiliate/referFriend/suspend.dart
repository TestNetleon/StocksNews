import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

import '../../../route/my_app.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../contactUs/contact_us.dart';

class ReferFriendSuspend extends StatelessWidget {
  const ReferFriendSuspend({super.key});

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();
    if (provider.extra?.suspendMsg == null ||
        provider.extra?.suspendMsg == '') {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => const ContactUs(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                ThemeColors.sos,
                Color.fromARGB(255, 113, 15, 5),
              ],
            ),
          ),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  context.watch<LeaderBoardProvider>().extra?.suspendMsg ?? "",
                  style: stylePTSansBold(fontSize: 15),
                ),
              ),
              const SpacerHorizontal(width: 5),
              ThemeButtonSmall(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                text: "Contact Support",
                onPressed: () {
                  Navigator.push(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                      builder: (_) => const ContactUs(),
                    ),
                  );
                },
                icon: Icons.support_agent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
