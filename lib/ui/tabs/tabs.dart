import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/managers/news.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/service/transparency.dart';
import 'package:stocks_news_new/socket/socket.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/losers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:vibration/vibration.dart';
import 'home/home.dart';
import 'more/news/index.dart';
import 'tools/scanner/index.dart';
import 'tools/simulator/screens/index.dart';
import 'tools/tools.dart';

bool affiliateClosed = false;

class Tabs extends StatefulWidget {
  static const String path = "Tabs";
  final int? index;
  final String? inAppMsgId;
  final int childIndex;
  final int innerChildIndex;

  const Tabs({
    super.key,
    this.index = 0,
    this.inAppMsgId,
    this.childIndex = 0,
    this.innerChildIndex = 0,
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
      _checkReferBox();
      setState(() {
        _selectedIndex = widget.index ?? 0;
        activeContainerApiCalls(currentIndex: _selectedIndex);
      });

      AmplitudeService.instance.logFirstOpenEvent();
      requestATT();
    });
  }

  _checkReferBox() async {
    affiliateClosed = await Preference.getReferralBoxClosed();
  }

  BottomNavigationBarItem bottomTab(
      {icon, label, bool selected = false, double size = 27}) {
    return BottomNavigationBarItem(
      icon: Consumer<ThemeManager>(
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.only(bottom: 3.sp),
            child: Image.asset(
              icon,
              height: size,
              width: size,
              color:
                  selected ? ThemeColors.navigationBar : ThemeColors.neutral60,
            ),
          );
        },
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Screens.screens(
              _selectedIndex, widget.childIndex, widget.innerChildIndex)
          .elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: ThemeColors.neutral60,
        // selectedItemColor: ThemeColors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: ThemeColors.navigationBar,
        unselectedLabelStyle:
            styleBaseRegular(color: ThemeColors.white, fontSize: 14),
        selectedLabelStyle: styleBaseBold(fontSize: 14),
        onTap: (index) {
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
            icon: Images.bottomScanner,
            label: "Scanner",
            selected: _selectedIndex == 1,
          ),
          bottomTab(
            icon: Images.bottomMarket,
            label: "Simulator",
            selected: _selectedIndex == 2,
          ),
          bottomTab(
            icon: Images.bottomSignals,
            label: "News",
            selected: _selectedIndex == 3,
          ),
          bottomTab(
            icon: Images.bottomTools,
            label: "Tools",
            selected: _selectedIndex == 4,
          ),
          // bottomTab(
          //   icon: Images.bottomMore,
          //   label: "More",
          //   selected: _selectedIndex == 5,
          // ),
        ],
      ),
    );
  }

  void activeContainerApiCalls({required int currentIndex}) async {
    MyHomeManager manager = context.read<MyHomeManager>();
    ToolsManager toolsManager = context.read<ToolsManager>();

    HomeGainersManager homeGainers = context.read<HomeGainersManager>();
    NewsManager newsManager = context.read<NewsManager>();

    ScannerManager scannerManager = context.read<ScannerManager>();
    ScannerGainersManager gainersManager =
        context.read<ScannerGainersManager>();
    ScannerLosersManager losersManager = context.read<ScannerLosersManager>();

    if (currentIndex != 0) homeGainers.stopListeningPorts();

    if (currentIndex != 1) {
      scannerManager.stopListeningPorts();
      gainersManager.stopListeningPorts();
      losersManager.stopListeningPorts();
    }

    if (currentIndex != 2) {
      SSEManager.instance.disconnectScreen(SimulatorEnum.open);
    }

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
        pingApi(SocketEnum.home);
        SocketService.instance.emitUpdateUser(SocketEnum.home);
        EventsService.instance.homeHomePage();
        if (manager.data == null) {
          manager.getHomeData();
        }
        break;

      case 1:
        // scannerManager.setDataEmpty();
        EventsService.instance.scannerHomePage();
        pingApi(SocketEnum.scanner);
        break;

      case 2:
        EventsService.instance.simulatorHomePage();
        pingApi(SocketEnum.simulator);
        break;

      case 3:
        EventsService.instance.newsHomePage();
        newsManager.setSelectedIndex(0);
        pingApi(SocketEnum.news);
        break;

      case 4:
        // signalsManager.onScreenChange(-1);
        EventsService.instance.toolsHomePage();
        pingApi(SocketEnum.tools);
        SocketService.instance.emitUpdateUser(SocketEnum.tools);
        if (toolsManager.data == null) {
          toolsManager.getToolsData();
        }
        break;

      // case 5:
      //   break;

      // case 6:
      //   break;
    }
  }
}

class Screens {
  static List<Widget> screens(
    int? trendingIndex,
    int? childIndex,
    int? innerChildIndex,
  ) {
    return <Widget>[
      HomeIndex(),
      ToolsScannerIndex(),
      // MarketIndex(
      //   screenIndex: 0,
      //   marketIndex: childIndex ?? 0,
      //   marketInnerIndex: innerChildIndex,
      // ),
      SimulatorIndex(initialIndex: childIndex ?? 0),
      CategoriesNewsIndex(),
      ToolsIndex(),
      // MoreIndex(),
    ];
  }
}
