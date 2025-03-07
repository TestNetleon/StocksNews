import 'package:flutter/material.dart';

class DrawerRes {
  bool isSelected, showBadge;
  IconData iconData;
  String? icon;
  String text;
  int? badgeCount;
  Function()? onTap;
  // Color? iconColor;
  DrawerRes({
    required this.iconData,
    this.isSelected = false,
    required this.text,
    this.icon,
    this.showBadge = false,
    this.badgeCount,
    this.onTap,
    // this.iconColor = Colors.white,
  });
}

class DrawerResNew {
  bool isSelected, showBadge;
  String icon;
  String text;
  int? badgeCount;
  DrawerResNew({
    required this.icon,
    this.isSelected = false,
    required this.text,
    this.showBadge = false,
    this.badgeCount,
  });
}

//
// List<DrawerRes> drawerItems = [
//   DrawerRes(iconData: Icons.home_filled, text: "Home"),
//   DrawerRes(iconData: Icons.stacked_line_chart_rounded, text: "Stocks"),
//   DrawerRes(iconData: Icons.add_alert_outlined, text: "Stock Alerts"),
//   DrawerRes(iconData: Icons.star_border, text: "Stock Watchlist"),
//   DrawerRes(iconData: Icons.trending_up_rounded, text: "Trending Industries"),
//   DrawerRes(iconData: Icons.notifications_active, text: "Notifications"),
//   DrawerRes(iconData: Icons.person, text: "My Account"),
//   DrawerRes(iconData: Icons.help_outline_rounded, text: "FAQs"),
//   DrawerRes(iconData: Icons.newspaper_sharp, text: "About Us"),
//   DrawerRes(iconData: Icons.mail_sharp, text: "Contact Us"),
//   DrawerRes(iconData: Icons.edit_note_rounded, text: "Terms and Conditions"),
//   DrawerRes(iconData: Icons.policy, text: "Privacy Policy"),
//   DrawerRes(iconData: Icons.warning_amber_rounded, text: "Disclaimer"),
//   DrawerRes(iconData: Icons.newspaper_sharp, text: "Blogs"),
//   // DrawerRes(iconData: Icons.work_history, text: "What We Do"),
// ];

List<DrawerRes> drawerItems = [
  // DrawerRes(iconData: Icons.home_filled, text: "Home"),
  DrawerRes(iconData: Icons.stacked_line_chart_outlined, text: "Stocks"),
  // DrawerRes(iconData: Icons.add_alert_outlined, text: "Stock Alerts"),
  // DrawerRes(iconData: Icons.star_border, text: "Stock Watchlist"),
  // DrawerRes(iconData: Icons.trending_up, text: "Trending Industries"),
  // DrawerRes(
  // iconData: Icons.notifications_active_outlined, text: "Notifications"),
  DrawerRes(iconData: Icons.person_2_outlined, text: "My Profile"),
  DrawerRes(iconData: Icons.newspaper_rounded, text: "Blogs"),
  DrawerRes(iconData: Icons.list_alt_rounded, text: "About Stocks.News"),
  DrawerRes(iconData: Icons.featured_play_list_outlined, text: "What We Do"),
  DrawerRes(iconData: Icons.mail_outline_sharp, text: "Contact Us"),
  DrawerRes(iconData: Icons.help_outline_rounded, text: "FAQs"),
  // DrawerRes(iconData: Icons.edit_note_rounded, text: "Terms and Conditions"),
  // DrawerRes(iconData: Icons.policy_outlined, text: "Privacy Policy"),
  // DrawerRes(iconData: Icons.warning_amber_rounded, text: "Disclaimer"),
  // DrawerRes(iconData: Icons.logout_outlined, text: "Logout"),
];
