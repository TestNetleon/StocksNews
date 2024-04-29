import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/faq_provider.dart';
import 'package:stocks_news_new/screens/faq/faq.dart';

class FAQ extends StatelessWidget {
  static const String path = "FAQ";

  const FAQ({super.key});
//
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: FaqProvide(),
      child: const FAQBase(),
    );
  }
}
