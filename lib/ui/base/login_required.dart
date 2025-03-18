import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../models/lock.dart';

class BaseLoginRequired extends StatelessWidget {
  final BaseLockInfoRes? data;
  final Future Function() onPressed;
  const BaseLoginRequired({super.key, this.data, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return SizedBox();
    }
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Pad.pad16,
            vertical: Pad.pad16,
          ),
          child: Column(
            children: [
              Text(
                data?.title ?? '',
                style: styleBaseBold(fontSize: 30),
              ),
              SpacerVertical(height: 12),
              Text(
                data?.subTitle ?? '',
                textAlign: TextAlign.center,
                style: styleBaseRegular(
                  fontSize: 17,
                  color: ThemeColors.neutral80,
                ),
              ),
              SpacerVertical(height: 20),
              IntrinsicWidth(
                child: BaseButton(
                  text: data?.btn ?? '-',
                  onPressed: () async {
                    UserManager manager = context.read<UserManager>();
                    await manager.askLoginScreen();
                    if (manager.user == null) return;
                    await onPressed();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
