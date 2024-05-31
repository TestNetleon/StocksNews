import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us_container.dart';
import 'package:stocks_news_new/screens/contactUs/widgets/contactUsSimmer/conatct_us_sc_simmer.dart';
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
    TermsAndPolicyProvider provider = context.watch<TermsAndPolicyProvider>();

    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.all(Dimen.padding.sp),
        child: Column(
          children: [
            const ScreenTitle(title: "Contact Us"),
            Expanded(
              child: provider.isLoading
                  ? const ContactUsScreenSimmer()
                  : const ContactUsContainer(),
            ),
          ],
        ),
      ),
    );
  }
}
