import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/managers/onboarding.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/my_home.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom/alert_popup.dart';
import '../../base/app_bar.dart';
import '../../base/button.dart';
import '../../base/country_code.dart';
import '../../base/text_field.dart';
import 'agree_text.dart';
import 'social_button.dart';
import 'verify.dart';

class AccountLoginIndex extends StatefulWidget {
  static const path = 'AccountLoginIndex';
  const AccountLoginIndex({super.key});

  @override
  State<AccountLoginIndex> createState() => _AccountLoginIndexState();
}

class _AccountLoginIndexState extends State<AccountLoginIndex> {
  final TextEditingController _phone = TextEditingController();
  String? countryCode;
  bool boxChecked = false;
  bool changingCountryCode = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthorizationCredentialAppleID? credential;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setCountryCode();
    });
  }

  _setCountryCode() {
    UserRes? user = context.read<UserManager>().user;
    if (user?.phone != null && user?.phone != '') {
      _phone.text = user?.phone ?? '';
    } else {
      _phone.text = '';
    }
    if (user?.phoneCode != null && user?.phoneCode != "") {
      countryCode = CountryCode.fromDialCode(user?.phoneCode ?? "").dialCode;
    } else if (geoCountryCode != null && geoCountryCode != "") {
      countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
    } else {
      countryCode = CountryCode.fromCountryCode("US").dialCode;
    }
  }

  bool isLoading = false;

  setLoading(status) {
    print('Status $status');
    isLoading = status;
    if (mounted) {
      setState(() {});
    }
  }

  _changeBox() {
    boxChecked = !boxChecked;
    if (mounted) {
      setState(() {});
    }
  }

  _verification() async {
    if (isEmpty(_phone.text)) {
      //
    } else {
      if (kDebugMode) {
        Navigator.pushNamed(context, AccountVerificationIndex.path, arguments: {
          'phone': _phone.text,
          'countryCode': countryCode,
          'verificationId': '1',
        });
        return;
      }
    }
    setLoading(true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${countryCode ?? '+1'} ${_phone.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);

          setLoading(false);
        },
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
          setLoading(false);
          Utils().showLog('$e');
        },
        codeSent: (String verificationId, int? resendToken) {
          setLoading(false);

          Navigator.pushNamed(context, AccountVerificationIndex.path,
              arguments: {
                'phone': _phone.text,
                'countryCode': countryCode,
                'verificationId': verificationId,
              });
          Utils().showLog('Verification code sent.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Utils().showLog('Time Out');
          setLoading(false);
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      Utils().showLog('Firebase error $e');
    }
  }

  void _googleVerification() async {
    closeKeyboard();

    UserManager manager = context.read<UserManager>();

    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        Map request = {
          "displayName": account.displayName ?? "",
          "email": account.email,
          "id": account.id,
          "photoUrl": account.photoUrl ?? "",
        };

        manager.googleVerification(extraRequest: request);
      }
    } catch (error) {
      //
    }
  }

  void _appleVerification() async {
    closeKeyboard();
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      UserManager manager = context.read<UserManager>();
      if (credential != null) {
        String? name =
            credential?.givenName != null && credential?.givenName != ''
                ? "${credential?.givenName} ${credential?.familyName}"
                : null;

        Map request = {
          "displayName": name ?? '',
          "email": credential?.email ?? '',
          "id": credential?.userIdentifier ?? '',
        };

        manager.appleVerification(extraRequest: request);
      }
    } catch (e) {
      Utils().showLog('error $e');
      if (e.toString().contains("SignInWithAppleNotSupportedException")) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();
    UserManager userManager = context.watch<UserManager>();

    HomeLoginBoxRes? loginBox = manager.data?.loginBox;
    Utils().showLog("data => ${loginBox == null} ...");
    if (loginBox == null) {
      OnboardingManager onBoardingManager = context.watch<OnboardingManager>();
      loginBox = onBoardingManager.data?.loginBox;
    }

    if (!changingCountryCode) {
      if (userManager.user?.phoneCode != null &&
          userManager.user?.phoneCode != "") {
        countryCode =
            CountryCode.fromDialCode(userManager.user?.phoneCode ?? "")
                .dialCode;
      } else if (geoCountryCode != null && geoCountryCode != "") {
        countryCode = CountryCode.fromCountryCode(geoCountryCode!).dialCode;
      } else {
        countryCode = CountryCode.fromCountryCode("US").dialCode;
      }
    }

    return BaseScaffold(
      appBar: BaseAppBar(showBack: true),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpacerVertical(height: 24),
              Text(
                'Welcome!',
                style: styleBaseBold(fontSize: 32),
              ),
              SpacerVertical(height: 8),
              Text(
                textAlign: TextAlign.center,
                'Please enter your phone number to continue.',
                style: styleBaseRegular(fontSize: 18),
              ),
              SpacerVertical(height: 40),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // border: Border(
                      //   bottom: BorderSide(color: ThemeColors.white),
                      // ),
                      // color: ThemeColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                    child: BaseCountryCode(
                      onChanged: (CountryCode value) {
                        changingCountryCode = true;
                        countryCode = value.dialCode;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: BaseTextField(
                      placeholder: 'Phone number',
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      onChanged: (text) {
                        _phone.text = text;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
              SpacerVertical(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Pad.pad5),
                    child: InkWell(
                      onTap: _changeBox,
                      child: Container(
                        height: 20.sp,
                        width: 20.sp,
                        decoration: BoxDecoration(
                          color: boxChecked
                              ? ThemeColors.primary120
                              : ThemeColors.white,
                          border: Border.all(
                            color: boxChecked
                                ? ThemeColors.white
                                : ThemeColors.primary120,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 14.sp,
                          color: boxChecked
                              ? ThemeColors.black
                              : ThemeColors.white,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: Pad.pad10),
                      child: AccountAgreeText(),
                    ),
                  ),
                ],
              ),
              SpacerVertical(height: 24),
              BaseButton(
                radius: 8,
                onPressed: _phone.text.isEmpty || !boxChecked || isLoading
                    ? null
                    : _verification,
                textColor: ThemeColors.black,
                text: isLoading
                    ? loginBox?.verifyButtonText ?? 'Verifying'
                    : loginBox?.buttonText ?? 'Continue',
              ),
              SpacerVertical(height: 24),
              Row(
                children: [
                  Expanded(child: BaseListDivider(color: ThemeColors.black)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Pad.pad10),
                    child: Text('OR'),
                  ),
                  Expanded(child: BaseListDivider(color: ThemeColors.black)),
                ],
              ),
              SpacerVertical(height: 24),
              AccountSocialButton(
                text: 'Continue with Google',
                onPressed: _googleVerification,
              ),
              SpacerVertical(height: 16),
              AccountSocialButton(
                text: 'Continue with Apple',
                onPressed: _appleVerification,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
