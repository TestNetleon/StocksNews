import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/container.dart';
import 'package:stocks_news_new/utils/constants.dart';

class TCandPolicy extends StatelessWidget {
  final PolicyType policyType;
  static const String path = "TermsAndConditions";

  const TCandPolicy({super.key, required this.policyType});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TermsAndPolicyProvider(),
      child: TermsPolicyContainer(
        policyType: policyType,
      ),
    );
  }
}
