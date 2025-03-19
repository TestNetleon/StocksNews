import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/account/extra/pinput.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../widgets/custom/alert_popup.dart';
import '../../../managers/user.dart';
import '../auth/sent_code_text.dart';

class AccountEmailVerificationIndex extends StatefulWidget {
  static const path = 'AccountEmailVerificationIndex';
  final String email;

  const AccountEmailVerificationIndex({
    required this.email,
    super.key,
  });

  @override
  State<AccountEmailVerificationIndex> createState() =>
      _AccountEmailVerificationIndexState();
}

class _AccountEmailVerificationIndexState
    extends State<AccountEmailVerificationIndex> {
  final TextEditingController _controller = TextEditingController();
  int startTiming = 60;
  Timer? _timer;

  void _startTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        startTiming = startTiming - 1;
        Utils().showLog("Start Timer ? $startTiming");
        if (startTiming == 0) {
          startTiming = 30;
          _timer?.cancel();
          Utils().showLog("Timer Stopped ? $startTiming");
        }
      });
    });
  }

  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openKeyboard(myFocusNode);

      _startTime();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onVeryClick() async {
    if (_controller.text.isEmpty || _controller.text.length < 4) {
      popUpAlert(
        message: "Please enter a valid OTP.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    UserManager manager = context.read<UserManager>();
    ApiResponse response = await manager.updatePersonalDetails(
      email: widget.email,
      OTP: _controller.text,
    );

    if (response.status) {
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  void _onResendOtpClick() async {
    _startTime();
    _controller.text = '';
    setState(() {});
    UserManager manager = context.read<UserManager>();

    await manager.checkEmailExist(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(showBack: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Pad.pad24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Enter Validation Code",
                  style: styleBaseBold(fontSize: 32),
                ),
              ),
              const SpacerVertical(height: 8),
              AccountSentCodeText(
                digit: 4,
                text: widget.email,
              ),
              const SpacerVertical(),
              AccountPinput(
                length: 4,
                focusNode: myFocusNode,
                controller: _controller,
                onCompleted: (p0) {
                  _controller.text = p0;
                  setState(() {});
                  _onVeryClick();
                },
              ),
              startTiming == 30
                  ? Container(
                      margin: EdgeInsets.only(
                        right: 8.sp,
                        top: 20.sp,
                      ),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: _onResendOtpClick,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Re-send Code",
                            style: styleBaseBold(
                              fontSize: 18,
                              color: ThemeColors.secondary120,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                        right: 8.sp,
                        top: 20.sp,
                      ),
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${startTiming}Sec",
                              style: styleBaseBold(
                                fontSize: 18,
                                color: ThemeColors.secondary120,
                              ),
                            ),
                          ],
                          text: "Resend OTP in ",
                          style: styleBaseRegular(fontSize: 18),
                        ),
                      ),
                    ),
              const SpacerVertical(),
            ],
          ),
        ),
      ),
    );
  }
}
