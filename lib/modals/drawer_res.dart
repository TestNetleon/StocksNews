import 'package:flutter/material.dart';

class DrawerRes {
  bool isSelected, showBadge;
  IconData iconData;
  String text;
  int? badgeCount;

  DrawerRes({
    required this.iconData,
    this.isSelected = false,
    required this.text,
    this.showBadge = false,
    this.badgeCount,
  });
}

List<DrawerRes> drawerItems = [
  DrawerRes(iconData: Icons.home_filled, text: "Home"),
  DrawerRes(iconData: Icons.stacked_line_chart_rounded, text: "Stocks"),
  DrawerRes(iconData: Icons.trending_up_rounded, text: "Trending Industries"),
  DrawerRes(iconData: Icons.add_alert, text: "Alerts"),
  DrawerRes(iconData: Icons.star, text: "Watchlist"),
  DrawerRes(iconData: Icons.notifications_active, text: "Notifications"),
  DrawerRes(iconData: Icons.person, text: "My Account"),
  DrawerRes(iconData: Icons.help_outline_rounded, text: "FAQs"),
  DrawerRes(iconData: Icons.newspaper_sharp, text: "About Us"),
  DrawerRes(iconData: Icons.mail_sharp, text: "Contact Us"),
  DrawerRes(iconData: Icons.edit_note_rounded, text: "Terms and Conditions"),
  DrawerRes(iconData: Icons.policy, text: "Privacy Policy"),
  DrawerRes(iconData: Icons.warning_amber_rounded, text: "Disclaimer"),
  DrawerRes(iconData: Icons.newspaper_sharp, text: "Blogs"),
  // DrawerRes(iconData: Icons.work_history, text: "What We Do"),
];
