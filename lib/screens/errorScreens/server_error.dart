import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class ServerError extends StatefulWidget {
  static const path = "ServerErrorWidget";

  const ServerError({
    required this.errorCode,
    required this.onClick,
    super.key,
  });

  final int errorCode;
  final dynamic onClick;

  @override
  State<ServerError> createState() => _ServerErrorState();
}

class _ServerErrorState extends State<ServerError> {
  @override
  void dispose() {
    isShowingError = false;
    super.dispose();
  }

  String _getErrorTitle() {
    switch (widget.errorCode) {
      case 200:
        return "";
      default:
        return "";
    }
  }

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
                    "Internal Server Error",
                    textAlign: TextAlign.center,
                    style: styleGeorgiaBold(fontSize: 30),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Apologies for the inconvenience.\nPlease bear with us while we are fixing it.",
                textAlign: TextAlign.center,
                style: styleGeorgiaBold(fontSize: 14),
              ),
            ),
            const SpacerVertical(),
            ThemeButtonSmall(
              onPressed: () {
                isShowingError = false;
                Navigator.pop(context);
                if (widget.onClick != null) widget.onClick();
              },
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
