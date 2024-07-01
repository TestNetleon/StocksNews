import 'package:flutter/material.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../theme_button.dart';

requiredLogin() {
  showModalBottomSheet(
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
    ),
    backgroundColor: ThemeColors.transparent,
    isScrollControlled: false,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return DraggableScrollableSheet(
        maxChildSize: 1,
        initialChildSize: 1,
        builder: (context, scrollController) => RequiredLoginSheet(
          scrollController: scrollController,
        ),
      );
    },
  );
}

class RequiredLoginSheet extends StatefulWidget {
  final ScrollController scrollController;

  const RequiredLoginSheet({super.key, required this.scrollController});

  @override
  State<RequiredLoginSheet> createState() => _RequiredLoginSheetState();
}

class _RequiredLoginSheetState extends State<RequiredLoginSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        gradient: RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0.6,
          stops: [0.0, 0.9],
          colors: [Color.fromARGB(255, 0, 93, 12), Colors.black],
        ),
        color: ThemeColors.background,
        border: Border(top: BorderSide(color: ThemeColors.greyBorder)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 6,
              width: 50,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ThemeColors.greyBorder,
              ),
            ),
            const SpacerVertical(height: 20),
            Image.asset(
              Images.starAffiliate,
              height: 60,
              width: 60,
            ),
            const SpacerVertical(height: 10),
            Padding(
              padding: const EdgeInsets.all(Dimen.authScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Your Phone Number and Earn 5 Reward Points!",
                    textAlign: TextAlign.center,
                    style: stylePTSansBold(fontSize: 24),
                  ),
                  const SpacerVertical(height: 4),
                  Text(
                    'Add your phone number to receive a verification code and help us verify your account.',
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(color: Colors.grey),
                  ),
                  const SpacerVertical(height: 30),
                  const SpacerVertical(height: Dimen.itemSpacing),
                  ThemeButton(
                    text: "Go to Profile",
                    onPressed: () {
                      updateProfile = false;
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAccount(),
                        ),
                      );
                    },
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
