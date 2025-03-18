import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../api/api_response.dart';
import '../../utils/utils.dart';
import 'item.dart';
import 'manager.dart';

class AdManagerIndex extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final PopupAdRes? data;
  final AdPlaces places;
  final AdScreen screen;
  const AdManagerIndex({
    super.key,
    this.margin,
    this.data,
    this.places = AdPlaces.place1,
    this.screen = AdScreen.home,
  });

  @override
  State<AdManagerIndex> createState() => _AdManagerIndexState();
}

class _AdManagerIndexState extends State<AdManagerIndex> {
  bool _isVisible = false;

  // void _visibilityCall() {
  //   switch (widget.places) {
  //     case AdPlaces.place1:
  //       if (_isVisible && !firstCalled) {
  //         Utils().showLog("Calling API For Place 1");
  //         _callAPI();
  //         firstCalled = true;
  //       }
  //       break;
  //     case AdPlaces.place2:
  //       if (_isVisible && !secondCalled) {
  //         Utils().showLog("Calling API For Place 2");
  //         _callAPI();
  //         secondCalled = true;
  //       }
  //       break;
  //     case AdPlaces.place3:
  //       if (_isVisible && !thirdCalled) {
  //         Utils().showLog("Calling API For Place 3");
  //         _callAPI();
  //         thirdCalled = true;
  //       }
  //     default:
  //   }
  // }

  void _visibilityCall(AdScreen screen) {
    try {
      if (!_isVisible) return;

      Map<AdPlaces, bool>? screenMap = adVisibilityMap[screen];

      if (screenMap == null) {
        Utils().showLog("Screen $screen not found in adVisibilityMap");
        return;
      }

      switch (widget.places) {
        case AdPlaces.place1:
          if (screenMap[AdPlaces.place1] != null &&
              !screenMap[AdPlaces.place1]!) {
            Utils().showLog("Calling API For Place 1 on $screen");
            _callAPI();
            screenMap[AdPlaces.place1] = true;
          }
          break;
        case AdPlaces.place2:
          if (screenMap[AdPlaces.place2] != null &&
              !screenMap[AdPlaces.place2]!) {
            Utils().showLog("Calling API For Place 2 on $screen");
            _callAPI();
            screenMap[AdPlaces.place2] = true;
          }
          break;
        case AdPlaces.place3:
          if (screenMap[AdPlaces.place3] != null &&
              !screenMap[AdPlaces.place3]!) {
            Utils().showLog("Calling API For Place 3 on $screen");
            _callAPI();
            screenMap[AdPlaces.place3] = true;
          }
          break;
      }
      adVisibilityMap[screen] = screenMap;
    } catch (e) {
      //
    }
  }

  _callAPI() {
    AdManager provider = context.read<AdManager>();
    provider.callAPI(id: widget.data?.id);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) {
      return SizedBox();
    }

    return VisibilityDetector(
      key: Key(widget.places.name),
      onVisibilityChanged: (visibilityInfo) {
        if (mounted) {
          setState(() {
            _isVisible = handleAdVisibility(visibilityInfo);
          });
          _visibilityCall(widget.screen);
        }
      },
      child: AdManagerItem(
        margin: widget.margin,
        data: widget.data,
      ),
    );
  }
}
