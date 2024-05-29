import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class CompareNewSearch extends StatelessWidget {
  const CompareNewSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 100),
        color: Colors.transparent,
        child: BaseContainer(body: Container()));
  }
}
