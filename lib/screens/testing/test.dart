import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: const [
            ListSectionOne(),
            ListSectionTwo(),
          ],
        ),
      ),
    );
  }
}

class ListSectionOne extends StatelessWidget {
  const ListSectionOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "TESTING List 1",
              textAlign: TextAlign.center,
              style: styleGeorgiaBold(),
            ),
          ),
          ...List.generate(
            2,
            (index) => Container(
              height: 200,
              width: double.infinity,
              color: ThemeColors.border,
              margin: EdgeInsets.only(bottom: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class ListSectionTwo extends StatelessWidget {
  const ListSectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "TESTING List 2",
              textAlign: TextAlign.center,
              style: styleGeorgiaBold(),
            ),
          ),
          ...List.generate(
            2,
            (index) => Container(
              height: 200,
              width: double.infinity,
              color: ThemeColors.greyBorder,
              margin: EdgeInsets.only(bottom: 20),
            ),
          ),
        ],
      ),
    );
  }
}
