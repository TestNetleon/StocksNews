import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../widgets/screen_title.dart';

class ContactUs extends StatelessWidget {
  static const String path = "ContactUs";
  const ContactUs({super.key});
//
  @override
  Widget build(BuildContext context) {
    return const ContactUsBase();
  }
}

class ContactUsBase extends StatefulWidget {
  const ContactUsBase({super.key});

  @override
  State<ContactUsBase> createState() => _ContactUsBaseState();
}

class _ContactUsBaseState extends State<ContactUsBase> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<TermsAndPolicyProvider>()
          .getTermsPolicy(type: PolicyType.contactUs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.all(Dimen.padding.sp),
        child: const Column(
          children: [
            ScreenTitle(title: "Contact Us"),
            Expanded(
              child: ContactUsContainer(),
            )
          ],
        ),
      ),
    );
  }
}
