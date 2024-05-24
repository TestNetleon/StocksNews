import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class InternetErrorWidget extends StatelessWidget {
  static const path = "InternetErrorWidget";
  const InternetErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Lottie.asset(Images.serverErrorGIF),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Text(
                    "Connection Error",
                    textAlign: TextAlign.center,
                    style: styleGeorgiaBold(fontSize: 30),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Oops! It seems like your internet is down.\nPlease check your connection and try again.",
                textAlign: TextAlign.center,
                style: styleGeorgiaRegular(fontSize: 14, height: 1.4),
              ),
            ),
            const SpacerVertical(),
            ThemeButtonSmall(
              onPressed: () {},
              showArrow: false,
              text: "Refresh",
              fontBold: true,
            ),
          ],
        ),
      ),
    );
  }
}
