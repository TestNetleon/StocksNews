import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/arena/provider/arena.dart';
import 'package:stocks_news_new/arena/screens/tournaments/widgets/header.dart';
import 'widgets/grid.dart';

class TournamentsIndex extends StatefulWidget {
  const TournamentsIndex({super.key});

  @override
  State<TournamentsIndex> createState() => _TournamentsIndexState();
}

class _TournamentsIndexState extends State<TournamentsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArenaProvider>().getTournamentData();
      context.read<ArenaProvider>().getSearchDefaults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: TournamentHeader(),
        ),
        SliverToBoxAdapter(
          child: TournamentGrids(),
        ),
      ],
    );
  }
}
