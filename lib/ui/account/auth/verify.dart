import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/account/extra/pinput.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../widgets/custom/alert_popup.dart';
import 'sent_code_text.dart';

class AccountVerificationIndex extends StatefulWidget {
  static const path = 'AccountVerificationIndex';
  final String phone, countryCode, verificationId;
  final bool? update, fromAppleVerify;
  final Map? extraRequest;

  final void Function()? callBack;
  final String? name;

  const AccountVerificationIndex({
    required this.phone,
    required this.countryCode,
    required this.verificationId,
    super.key,
    this.update,
    this.name,
    this.callBack,
    this.fromAppleVerify,
    this.extraRequest,
  });

  @override
  State<AccountVerificationIndex> createState() =>
      _AccountVerificationIndexState();
}

class _AccountVerificationIndexState extends State<AccountVerificationIndex>
    with CodeAutoFill {
  final TextEditingController _controller = TextEditingController();

  int startTiming = 30;
  Timer? _timer;
  String? _verificationId;

  @override
  void codeUpdated() {
    setState(() {
      _controller.text = code!;
    });
  }

  Future _verifyPhoneNumber() async {
    if (_controller.text.isEmpty || _controller.text.length < 6) {
      popUpAlert(
        message: "Please enter a valid OTP.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
    if (kDebugMode) {
      _callVerifyAccount();
      return;
    }

    String smsCode = _controller.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId ?? widget.verificationId,
      smsCode: smsCode,
    );

    showGlobalProgressDialog();

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      closeGlobalProgressDialog();
      _callVerifyAccount();
    } on FirebaseAuthException catch (e) {
      closeGlobalProgressDialog();
      popUpAlert(
        message: e.message ?? Const.errSomethingWrong,
        title: "Alert",
        icon: Images.alertPopGIF,
      );
    } catch (e) {
      closeGlobalProgressDialog();

      log("Here Error $e");
    }
  }

  _callVerifyAccount() async {
    UserManager manager = context.read<UserManager>();

    Map request = {
      'phone': widget.phone,
      'phone_code': widget.countryCode,
    };

    if (widget.fromAppleVerify == true) {
      Map<String, dynamic> mergedRequest = {
        ...request,
        ...?widget.extraRequest,
      };

      await manager.appleVerification(
        extraRequest: mergedRequest,
      );
    } else if (widget.update == true) {
      ApiResponse response = await manager.updatePersonalDetails(
        phone: widget.phone,
        name: widget.name,
        phoneCode: widget.countryCode,
      );
      if (response.status) {
        Navigator.pop(navigatorKey.currentContext!);
        if (widget.callBack != null) {
          widget.callBack!();
        }
      }
    } else {
      manager.verifyAccount(extraRequest: request);
    }
  }

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
      Utils().showLog('PHONE => ${widget.phone}');
      openKeyboard(myFocusNode);

      listenForCode();
      _startTime();
      _verificationId = widget.verificationId;
      setState(() {});
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
    if (_controller.text.isEmpty || _controller.text.length < 6) {
      popUpAlert(
        message: "Please enter a valid OTP.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }

    _verifyPhoneNumber();
  }

  void _onResendOtpClick() async {
    _startTime();
    _controller.text = '';
    setState(() {});
    if (kDebugMode) {
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.countryCode} ${widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        popUpAlert(
          message: e.code == "invalid-phone-number"
              ? "The format of the phone number provided is incorrect."
              : e.code == "too-many-requests"
                  ? "We have blocked all requests from this device due to unusual activity. Try again after 24 hours."
                  : e.code == "internal-error"
                      ? "The phone number you entered is either incorrect or not currently in use."
                      : e.message ?? Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
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
                text: "${widget.countryCode} ${widget.phone}",
              ),
              const SpacerVertical(),
              AccountPinput(
                focusNode: myFocusNode,
                controller: _controller,
                onCompleted: (p0) {
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
