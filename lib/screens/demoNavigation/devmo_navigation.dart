import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/demoNavigation/deeplink_data.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

class NavigationDemo extends StatefulWidget {
  const NavigationDemo({super.key});

  @override
  State<NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  List<DeeplinkData>? dataList;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //
      // dataList = await Preference.getDataList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
        appBar: const AppBarHome(isPopback: true),
        body: Column(
          children: [
            ScreenTitle(
              title: "Navigation Flow",
              optionalWidget: TextButton(
                onPressed: () {
                  // Preference.saveClearDataList();
                },
                child: Text(
                  "Clear",
                  style: styleGeorgiaBold(),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // dataList = await Preference.getDataList();
                  setState(() {});
                },
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Text(
                      dataList?[index].from ?? "",
                      style: stylePTSansRegular(),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Text("data", style: stylePTSansRegular());
                  },
                  itemCount: dataList?.length ?? 0,
                ),
              ),
            )
          ],
        ));
  }
}
