import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/container.dart';
import 'package:stocks_news_new/utils/constants.dart';

class TCandPolicy extends StatelessWidget {
  static const String path = "TermsAndConditions";
  final PolicyType policyType;
  final String slug;

  const TCandPolicy({
    super.key,
    required this.policyType,
    required this.slug,
  });
//
  @override
  Widget build(BuildContext context) {
    return TermsPolicyContainer(
      policyType: policyType,
      slug: slug,
    );
  }
}
