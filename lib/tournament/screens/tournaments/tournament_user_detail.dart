import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class TournamentUserDetail extends StatefulWidget {
  final String? userName;
  const TournamentUserDetail({super.key, this.userName});

  @override
  State<TournamentUserDetail> createState() => _TournamentUserDetailState();
}

class _TournamentUserDetailState extends State<TournamentUserDetail> {
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
        appBar: AppBarHome(
          isPopBack: true,
          canSearch: false,
          showTrailing: false,

        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
          child: Column(
            children: [

            ],
          ),
        )
    );
  }
}
