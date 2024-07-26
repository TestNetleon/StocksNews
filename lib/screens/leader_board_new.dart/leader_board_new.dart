import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class LeaderBoardNew extends StatelessWidget {
  const LeaderBoardNew({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true),
      body: Padding(
        padding: EdgeInsets.all(Dimen.padding.sp),
        child: const Column(
          children: [],
        ),
      ),
    );
  }
}
