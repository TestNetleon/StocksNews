import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SubscriptionSuccessIndex extends StatefulWidget {
  const SubscriptionSuccessIndex({super.key});

  @override
  State<SubscriptionSuccessIndex> createState() =>
      _SubscriptionSuccessIndexState();
}

class _SubscriptionSuccessIndexState extends State<SubscriptionSuccessIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 1), () {
        context.read<MyHomeManager>().getHomeData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Consumer<SubscriptionManager>(
        builder: (context, value, child) {
          BaseLockInfoRes? data = value.layoutData?.success;
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: Pad.pad16, vertical: Pad.pad16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            Images.referSuccess,
                            height: 250,
                            width: 300,
                          ),
                        ),
                        SpacerVertical(height: 10),
                        Text(
                          data?.title ?? '',
                          style: styleBaseBold(fontSize: 30),
                        ),
                        SpacerVertical(height: 20),
                        Text(
                          data?.subTitle ?? '',
                          style: styleBaseSemiBold(
                            color: ThemeColors.neutral80,
                            fontSize: 20,
                          ),
                        ),
                        SpacerVertical(height: 20),
                        Text(
                          textAlign: TextAlign.center,
                          data?.other ?? '',
                          style: styleBaseRegular(color: ThemeColors.neutral80),
                        ),
                      ],
                    ),
                  ),
                ),
                BaseButton(
                  text: data?.btn ?? '',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Tabs.path,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
