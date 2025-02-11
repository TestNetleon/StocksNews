import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/onboarding.dart';
import 'package:stocks_news_new/ui/onboarding/slides.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import '../base/scaffold.dart';

//MARK: DefaultHome
class DefaultHome extends StatefulWidget {
  static const path = 'DefaultHome';
  const DefaultHome({super.key});

  @override
  State<DefaultHome> createState() => _DefaultHomeState();
}

class _DefaultHomeState extends State<DefaultHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  void _navigate() {
    OnboardingManager provider = context.read<OnboardingManager>();
    if (provider.data == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Tabs.path,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        OnboardingSlides.path,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Container(),
    );
  }
}
