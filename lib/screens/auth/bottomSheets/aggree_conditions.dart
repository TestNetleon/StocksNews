import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../utils/utils.dart';
import '../../t&cAndPolicy/tc_policy.dart';

class AgreeConditions extends StatelessWidget {
  const AgreeConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'By signing up you agree to our ',
        style: stylePTSansRegular(fontSize: 13),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  createRoute(
                    const TCandPolicy(
                      policyType: PolicyType.tC,
                    ),
                  ),
                );
              },
            text: 'Terms & Conditions',
            style: stylePTSansRegular(
              fontSize: 13,
              color: ThemeColors.accent,
            ),
          ),
          TextSpan(
            text: ' and ',
            style: stylePTSansRegular(fontSize: 13),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  createRoute(
                    const TCandPolicy(
                      policyType: PolicyType.privacy,
                    ),
                  ),
                );
              },
            text: 'Privacy Policy',
            style: stylePTSansRegular(
              fontSize: 13,
              color: ThemeColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
