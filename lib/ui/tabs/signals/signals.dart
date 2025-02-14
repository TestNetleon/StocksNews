import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';

import '../../base/common_tab.dart';

class SignalsIndex extends StatefulWidget {
  const SignalsIndex({super.key});

  @override
  State<SignalsIndex> createState() => _SignalsIndexState();
}

class _SignalsIndexState extends State<SignalsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        showSearch: true,
      ),
      body: Container(
        child: Column(
          children: [
            // CommonTabs(
            //       data: provider.data!.data!,
            //       textStyle: styleBaseBold(fontSize: 16),
            //       onTap: (index) {
            //         setState(() {
            //           _screenIndex = index;
            //         });
            //       },
            //       rightChild: Padding(
            //         padding: const EdgeInsets.only(right: 16),
            //         child: Icon(Icons.search, color: Colors.black),
            //       ),
            //     ),
          ],
        ),
      ),
    );
  }
}
