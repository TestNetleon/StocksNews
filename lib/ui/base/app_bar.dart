import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../../ui/tabs/tabs.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome, showBack, showSearch, showNotification;
  final String? title;
  final Function()? onSaveClick;

  const BaseAppBar({
    super.key,
    this.isHome = false,
    this.showBack = false,
    this.title,
    this.showSearch = false,
    this.showNotification = false,
    this.onSaveClick,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // padding: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(Pad.pad8),
        child: Stack(
          children: [
            if (title == null) CenterLogo(isHome: isHome),
            if (title != null) CenterTitle(title: title!),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Leading
                  Row(
                    children: [
                      if (showBack)
                        ActionButton(
                          icon: Images.back,
                          onTap: () {
                            Navigator.pop(navigatorKey.currentContext!);
                          },
                        ),
                      if (showNotification)
                        LeadingNotification(
                          showIndicator: true,
                        ),
                    ],
                  ),
                  // Actions
                  Row(
                    children: [
                      if (showSearch)
                        ActionButton(
                          icon: Images.search,
                          onTap: () {
                            Navigator.push(
                              navigatorKey.currentContext!,
                              MaterialPageRoute(
                                builder: (_) => const Notifications(),
                              ),
                            );
                          },
                        ),
                      if (onSaveClick != null)
                        SaveAction(onSaveClick: onSaveClick!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // Stack(
        //   alignment: Alignment.center,
        //   children: [
        //     if ((widget.title == null && widget.widget == null) ||
        //         widget.isHome)
        //       GestureDetector(
        //         onTap: widget.isHome
        //             ? null
        //             : () {
        //                 // Navigator.pushReplacement(
        //                 //   context,
        //                 //   MaterialPageRoute(builder: (_) => const Tabs(index: 0)),
        //                 // );
        //                 Navigator.popUntil(navigatorKey.currentContext!,
        //                     (route) => route.isFirst);
        //                 Navigator.pushReplacement(
        //                   navigatorKey.currentContext!,
        //                   MaterialPageRoute(builder: (_) => const Tabs()),
        //                 );
        //               },
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * .40,
        //           constraints:
        //               BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
        //           child: Container(
        //             margin: isPhone ? EdgeInsets.all(8.sp) : null,
        //             child: Image.asset(
        //               Images.mainBlackLogo,
        //               fit: BoxFit.contain,
        //             ),
        //           ),
        //         ),
        //       ),
        //     Row(
        //       mainAxisSize: MainAxisSize.max,
        //       children: [
        //         // Leading
        //         widget.isPopBack
        //             ? IconButton(
        //                 onPressed: widget.onTap ??
        //                     () {
        //                       if (popHome) {
        //                         if (CustomNavigatorObserver().stackCount >= 2 &&
        //                             splashLoaded) {
        //                           Navigator.pop(navigatorKey.currentContext!);
        //                         } else {
        //                           Navigator.popUntil(
        //                               navigatorKey.currentContext!,
        //                               (route) => route.isFirst);
        //                           Navigator.pushReplacement(
        //                             navigatorKey.currentContext!,
        //                             MaterialPageRoute(
        //                                 builder: (_) => const Tabs()),
        //                           );
        //                           popHome = false;
        //                         }
        //                       } else {
        //                         // Navigator.pop(navigatorKey.currentContext!);
        //                         if (CustomNavigatorObserver().stackCount >= 2 &&
        //                             splashLoaded) {
        //                           Navigator.pop(navigatorKey.currentContext!);
        //                         } else {
        //                           Navigator.popUntil(
        //                               navigatorKey.currentContext!,
        //                               (route) => route.isFirst);
        //                           Navigator.pushReplacement(
        //                             navigatorKey.currentContext!,
        //                             MaterialPageRoute(
        //                                 builder: (_) => const Tabs()),
        //                           );
        //                           popHome = false;
        //                         }
        //                       }
        //                     },
        //                 icon: Icon(
        //                   widget.icon ?? Icons.arrow_back_ios,
        //                   color: ThemeColors.black,
        //                 ),
        //               )
        //             : widget.showNotification
        //                 ? Container(
        //                     padding: const EdgeInsets.only(left: 16),
        //                     child: Stack(
        //                       alignment: Alignment.center,
        //                       children: [
        //                         InkWell(
        //                           borderRadius:
        //                               BorderRadius.circular(Pad.pad999),
        //                           onTap: () {
        //                             closeKeyboard();

        //                             if (provider.user != null) {
        //                               homeProvider.setNotification(true);
        //                             }
        //                             Navigator.push(
        //                               navigatorKey.currentContext!,
        //                               MaterialPageRoute(
        //                                 builder: (_) => const Notifications(),
        //                               ),
        //                             );
        //                           },
        //                           child: Image.asset(
        //                             Images.notification,
        //                             color: ThemeColors.black,
        //                             height: 35,
        //                             width: 35,
        //                           ),
        //                         ),
        //                         Visibility(
        //                           visible: !homeProvider.notificationSeen &&
        //                               provider.user != null,
        //                           child: Positioned(
        //                             right: 8.sp,
        //                             top: 8.sp,
        //                             child: Container(
        //                               decoration: BoxDecoration(
        //                                 shape: BoxShape.circle,
        //                                 color: ThemeColors.black,
        //                               ),
        //                               padding: EdgeInsets.all(0.7),
        //                               child: const CircleAvatar(
        //                                 radius: 4,
        //                                 backgroundColor: ThemeColors.sos,
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   )
        //                 : SizedBox(),
        //         // IconButton(
        //         //     onPressed: () {
        //         //       closeKeyboard();
        //         //       context.read<SearchProvider>().clearSearch();
        //         //       Scaffold.of(context).openDrawer();
        //         //     },
        //         //     icon: ClipRRect(
        //         //       borderRadius: BorderRadius.circular(90),
        //         //       child: isSVG
        //         //           ? SvgPicture.network(
        //         //               fit: BoxFit.cover,
        //         //               height: 24,
        //         //               width: 24,
        //         //               provider.user?.image ?? "",
        //         //               placeholderBuilder: (BuildContext context) =>
        //         //                   Container(
        //         //                 padding: const EdgeInsets.all(30.0),
        //         //                 child: const CircularProgressIndicator(
        //         //                   color: ThemeColors.accent,
        //         //                 ),
        //         //               ),
        //         //             )
        //         //           : CachedNetworkImagesWidget(
        //         //               provider.user?.image,
        //         //               height: 24,
        //         //               width: 24,
        //         //               showLoading: true,
        //         //               placeHolder: Images.userPlaceholder,
        //         //             ),
        //         //     ),
        //         //     // icon: ProfileImage(
        //         //     //   url: provider.user?.image,
        //         //     //   showCameraIcon: false,
        //         //     //   imageSize: 24,
        //         //     //   roundImage: true,
        //         //     // ),
        //         //     // Image.asset(
        //         //     //   Images.dotsMenu,
        //         //     //   color: ThemeColors.white,
        //         //     //   height: 18,
        //         //     //   width: 18,
        //         //     // ),
        //         //   ),

        //         // Title
        //         Expanded(
        //           child: Visibility(
        //             visible: widget.title != null || widget.widget != null,
        //             child: widget.widget ??
        //                 Text(
        //                   "${widget.title}",
        //                   style: styleBaseBold(fontSize: 18),
        //                   maxLines: 1,
        //                   overflow: TextOverflow.ellipsis,
        //                   textAlign: TextAlign.center,
        //                 ),
        //           ),
        //         ),
        //         // Actions
        //         Row(
        //           children: [
        //             if (!widget.isScannerFilter)
        //               Visibility(
        //                 visible: widget.onFilterClick != null,
        //                 child: IconButton(
        //                   onPressed: widget.onFilterClick,
        //                   icon: const Icon(
        //                     Icons.filter_alt,
        //                     color: ThemeColors.accent,
        //                   ),
        //                 ),
        //               ),

        //             if (widget.isScannerFilter)
        //               Consumer<MarketScannerProvider>(
        //                   builder: (context, value, child) {
        //                 return Visibility(
        //                   visible:
        //                       widget.onFilterClick != null && value.visible,
        //                   child: Stack(
        //                     children: [
        //                       IconButton(
        //                         onPressed: widget.onFilterClick,
        //                         icon: const Icon(
        //                           Icons.filter_alt,
        //                           color: ThemeColors.accent,
        //                         ),
        //                       ),
        //                       Positioned(
        //                         right: 24,
        //                         top: 14,
        //                         child: Container(
        //                           width: 8,
        //                           height: 8,
        //                           decoration: BoxDecoration(
        //                             color: Colors.red,
        //                             borderRadius: BorderRadius.circular(30),
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 );
        //               }),

        //             // Visibility(
        //             //   visible: widget.onFilterClick != null,
        //             //   child: IconButton(
        //             //     onPressed: widget.onFilterClick,
        //             //     icon: const Icon(
        //             //       Icons.filter_alt,
        //             //       color: ThemeColors.accent,
        //             //     ),
        //             //   ),
        //             // ),

        //             Visibility(
        //               visible: widget.canSearch,
        //               child: Container(
        //                 padding: EdgeInsets.only(right: Pad.pad16),
        //                 child: InkWell(
        //                   borderRadius: BorderRadius.circular(Pad.pad999),
        //                   onTap: () {
        //                     closeKeyboard();

        //                     if (provider.user != null) {
        //                       homeProvider.setNotification(true);
        //                     }
        //                     Navigator.push(
        //                       navigatorKey.currentContext!,
        //                       MaterialPageRoute(
        //                         builder: (_) => const Notifications(),
        //                       ),
        //                     );
        //                   },
        //                   child: Image.asset(
        //                     Images.search,
        //                     color: ThemeColors.black,
        //                     height: 32,
        //                     width: 32,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             Visibility(
        //               visible: widget.showPortfolio,
        //               child: IconButton(
        //                 onPressed: () {
        //                   Navigator.push(
        //                     navigatorKey.currentContext!,
        //                     createRoute(TsPortfolio()),
        //                   );
        //                 },
        //                 icon: const Icon(
        //                   Icons.person,
        //                   color: ThemeColors.black,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CenterLogo extends StatelessWidget {
  const CenterLogo({super.key, required this.isHome});

  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          if (isHome) return;
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushReplacementNamed(
            navigatorKey.currentContext!,
            Tabs.path,
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * .40,
          constraints: BoxConstraints(maxHeight: kTextTabBarHeight - 2.sp),
          child: Container(
            margin: isPhone ? EdgeInsets.all(8.sp) : null,
            child: Image.asset(
              Images.mainBlackLogo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class CenterTitle extends StatelessWidget {
  const CenterTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: styleBaseBold(fontSize: 18),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final String icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        icon,
        width: 32,
        height: 32,
      ),
    );
  }
}

class LeadingNotification extends StatelessWidget {
  const LeadingNotification({
    super.key,
    this.showIndicator = false,
  });

  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(Pad.pad999),
          onTap: () {
            closeKeyboard();
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (_) => const Notifications(),
              ),
            );
          },
          child: Image.asset(
            Images.notification,
            color: ThemeColors.black,
            height: 35,
            width: 35,
          ),
        ),
        Visibility(
          visible: showIndicator,
          child: Positioned(
            right: 5.sp,
            top: 6.sp,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.black,
                  border: Border.all(color: Colors.white, width: 1)),
              padding: EdgeInsets.all(0.7),
              child: const CircleAvatar(
                radius: 4,
                backgroundColor: ThemeColors.secondary100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SaveAction extends StatelessWidget {
  const SaveAction({super.key, required this.onSaveClick});

  final Function() onSaveClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Pad.pad999),
      onTap: onSaveClick,
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.primary100,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: 8),
        child: Text(
          "Save",
          style: styleBaseBold(fontSize: 14, color: ThemeColors.black),
        ),
      ),
    );
  }
}
