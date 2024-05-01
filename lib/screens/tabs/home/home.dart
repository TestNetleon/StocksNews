import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/home_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';

class Home extends StatelessWidget {
  static const String path = "Home";
  const Home({super.key});
//
  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    // UserProvider userProvider = context.watch<UserProvider>();
    return BaseContainer(
      drawer: const BaseDrawer(),
      // appBar: AppBarHome(showQR: userProvider.user != null, isHome: true),
      appBar: const AppBarHome(
        isHome: true,
        canSearch: true,
      ),
      body: provider.isLoadingSlider
          ? Center(
              child: Text(
                "We are preparing …",
                style: styleGeorgiaRegular(
                  color: Colors.white,
                ),
              ),
            )
          :
          // provider.data != null
          //     ?
          const HomeContainer()
      // :
      // ErrorDisplayWidget(
      //     error: provider.error,
      //     onRefresh: provider.getHomeData,
      //   )
      ,
    );
  }
}
