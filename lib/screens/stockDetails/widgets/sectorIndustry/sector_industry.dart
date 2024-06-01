// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/sector_industry_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer_copy.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/sectorIndustry/sector_industry_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

//
class SectorIndustry extends StatefulWidget {
  final StockStates stockStates;
  final String name;
  final String titleName;
  static const String path = "SectorIndustry";
  const SectorIndustry({
    required this.stockStates,
    super.key,
    required this.name,
    required this.titleName,
  });

  @override
  State<SectorIndustry> createState() => _SectorIndustryState();
}

class _SectorIndustryState extends State<SectorIndustry> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getStateIndustry();
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Trending Industries - Sectors"},
      );
    });
  }

  void _getStateIndustry() {
    context.read<SectorIndustryProvider>().getStateIndustry(
          stockStates: widget.stockStates,
          name: widget.name,
          showProgress: false,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SectorIndustryBase(
      stockStates: widget.stockStates,
      name: widget.name,
      titleName: widget.titleName,
      onRefresh: () {
        _getStateIndustry();
      },
    );
  }
}

class SectorIndustryBase extends StatelessWidget {
  final StockStates stockStates;
  final String name;
  final String titleName;
  final dynamic Function()? onRefresh;

  const SectorIndustryBase({
    super.key,
    required this.stockStates,
    required this.name,
    required this.titleName,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    SectorIndustryProvider provider = context.watch<SectorIndustryProvider>();
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: BaseUiContainer(
        isLoading: provider.isLoading,
        hasData: provider.data != null,
        error: provider.error,
        errorDispCommon: true,
        onRefresh: onRefresh,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
          child: Column(
            children: [
              ScreenTitle(
                title: stockStates == StockStates.sector
                    ? "Sector Performance - $titleName"
                    : "Industry - $titleName",
                // optionalText: 'Last Updated: 5/12/2022',
              ),
              Expanded(
                child: SectorIndustryList(
                  stockStates: stockStates,
                  name: name,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
