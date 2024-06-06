import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/container.dart';

class PlaidHome extends StatefulWidget {
  const PlaidHome({super.key});

  @override
  State<PlaidHome> createState() => _PlaidHomeState();
}

class _PlaidHomeState extends State<PlaidHome> {
  @override
  Widget build(BuildContext context) {
    return const PlaidHomeContainer();
  }
}
