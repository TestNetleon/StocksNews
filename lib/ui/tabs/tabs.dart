import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/socket/socket.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/market/index.dart';
import 'package:stocks_news_new/ui/tabs/more/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:vibration/vibration.dart';
import '../../api/api_response.dart';
import '../../screens/offerMembership/blackFriday/index.dart';
import '../../screens/offerMembership/christmas/index.dart';
import '../../utils/utils.dart';
import 'home/home.dart';
import 'signals/signals.dart';
import 'tools/tools.dart';

class Tabs extends StatefulWidget {
  static const String path = "Tabs";
  final int? index;
  final String? inAppMsgId;

  final int childIndex;
  // final int trendingIndex;

  const Tabs({
    super.key,
    this.index = 0,
    this.inAppMsgId,
    this.childIndex = 0,
    // this.trendingIndex = 0,
  });

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;
  bool userPresent = false;

  @override
  void initState() {
    super.initState();
    splashLoaded = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SocketService.instance.connect();

      setState(() {
        _selectedIndex = widget.index ?? 0;
        activeContainerApiCalls(currentIndex: _selectedIndex);
      });

      AmplitudeService.logFirstOpenEvent();
    });
  }

  // Future _request() async {
  //   await Future.delayed(Duration(seconds: 8));
  //   await requestATT();
  // }

  _showMembership() {
    // Navigator.push(
    //   context,
    //   createRoute(
    //     NewMembership(cancel: true),
    //   ),
    // );

    // UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
    Extra? extra = navigatorKey.currentContext!.read<HomeProvider>().extra;

    closeKeyboard();
    if (extra?.showBlackFriday == true) {
      Navigator.push(
        navigatorKey.currentContext!,
        createRoute(
          const BlackFridayMembershipIndex(cancel: true),
        ),
      );
    } else if (extra?.christmasMembership == true ||
        extra?.newYearMembership == true) {
      Navigator.push(
        navigatorKey.currentContext!,
        createRoute(
          const ChristmasMembershipIndex(),
        ),
      );
    } else {
      subscribe();
      // Navigator.push(
      //   navigatorKey.currentContext!,
      //   createRoute(
      //     const NewMembership(cancel: true),
      //   ),
      // );
    }
  }

  BottomNavigationBarItem bottomTab({
    icon,
    label,
    bool selected = false,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 3.sp),
        // child: Icon(
        //   icon,
        //   size: 23,
        // ),
        child: Image.asset(
          icon,
          height: 27,
          width: 27,
          color: selected ? ThemeColors.black : ThemeColors.neutral60,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarHome(
      //   canSearch: true,
      //   showTrailing: true,
      //   isHome: _selectedIndex == 0,
      // ),
      // drawer: const BaseDrawer(),
      // body: Screens.screens(widget.trendingIndex).elementAt(_selectedIndex),
      body: Screens.screens(_selectedIndex, widget.childIndex)
          .elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: ThemeColors.neutral60,
        selectedItemColor: ThemeColors.black,
        // backgroundColor: ThemeColors.tabBack,
        backgroundColor: ThemeColors.white,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,

        unselectedLabelStyle:
            styleBaseRegular(color: ThemeColors.white, fontSize: 14),
        selectedLabelStyle: styleBaseBold(fontSize: 14),
        onTap: (index) {
          context.read<SearchProvider>().clearSearch();
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
              activeContainerApiCalls(currentIndex: index);
            });
          }
        },
        items: [
          bottomTab(
            icon: Images.bottomHome,
            label: "Home",
            selected: _selectedIndex == 0,
          ),
          bottomTab(
            icon: Images.bottomMarket,
            label: "Market",
            selected: _selectedIndex == 1,
          ),
          bottomTab(
            icon: Images.bottomSignals,
            label: "Signals",
            selected: _selectedIndex == 2,
          ),
          bottomTab(
            icon: Images.bottomTools,
            label: "Tools",
            selected: _selectedIndex == 3,
          ),
          bottomTab(
            icon: Images.bottomMore,
            label: "More",
            selected: _selectedIndex == 4,
          ),
        ],
      ),
    );
  }

  void activeContainerApiCalls({required int currentIndex}) async {
    MyHomeManager manager = context.read<MyHomeManager>();
    ToolsManager toolsManager = context.read<ToolsManager>();
    SignalsManager signalsManager = context.read<SignalsManager>();
    HomeGainersManager homeGainers = context.read<HomeGainersManager>();

    if (currentIndex != 0) homeGainers.stopListeningPorts();

    try {
      if (Platform.isAndroid) {
        bool isVibe = await Vibration.hasVibrator();
        if (isVibe) {
          Vibration.vibrate(pattern: [50, 50, 79, 55], intensities: [1, 10]);
        }
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      log('$e');
    }

    switch (currentIndex) {
      case 0:
        SocketService.instance.emitUpdateUser(SocketEnum.home);
        if (manager.data == null) {
          manager.getHomeData();
        }
        break;

      case 1:
        break;

      case 2:
        signalsManager.onScreenChange(-1);
        break;

      case 3:
        SocketService.instance.emitUpdateUser(SocketEnum.tools);

        if (toolsManager.data == null) {
          toolsManager.getToolsData();
        }
        break;

      case 4:
        break;

      case 5:
        break;
    }
  }
}

void _compareStocks(BuildContext context) {
  UserProvider provider = context.read<UserProvider>();
  final compareProvider = context.read<CompareStocksProvider>();
  if (provider.user != null && compareProvider.company.isEmpty) {
    compareProvider.getCompareStock();
  }
  // AmplitudeService.logUserInteractionEvent(type: 'Compare Stocks');
}

class Screens {
  static List<Widget> screens(int? trendingIndex, int? childIndex) {
    return <Widget>[
      HomeIndex(),
      MarketIndex(
        screenIndex: 0,
        marketIndex: childIndex ?? 0,
      ),
      SignalsIndex(),
      ToolsIndex(),
      MoreIndex(),
    ];
  }
}
