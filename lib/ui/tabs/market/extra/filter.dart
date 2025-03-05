import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class MarketFilter extends StatelessWidget {
  const MarketFilter({super.key});

  @override
  Widget build(BuildContext context) {
    MarketManager manager = context.watch<MarketManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        title: "Filter",
        showBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (manager.data?.filter?.sorting != null)
                  FilterType(
                    title: "Sort By",
                    data: manager.data?.filter?.sorting,
                  ),
                if (manager.data?.filter?.exchange != null)
                  FilterType(
                    title: "Exchange",
                    data: manager.data?.filter?.exchange,
                  ),
                if (manager.data?.filter?.sectors != null)
                  FilterType(
                    title: "Sector",
                    data: manager.data?.filter?.sectors,
                  ),
                if (manager.data?.filter?.industries != null)
                  FilterType(
                    title: "Industry",
                    data: manager.data?.filter?.industries,
                  ),
                if (manager.data?.filter?.marketCap != null)
                  FilterType(
                    title: "Market Cap",
                    data: manager.data?.filter?.marketCap,
                  ),
                if (manager.data?.filter?.marketRank != null)
                  FilterType(
                    title: "Market Rank",
                    data: manager.data?.filter?.marketRank,
                  ),
                if (manager.data?.filter?.analystConsensus != null)
                  FilterType(
                    title: "Analyst Consensus",
                    data: manager.data?.filter?.analystConsensus,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: BaseButton(
                    text: 'Reset',
                    onPressed: () {},
                    color: ThemeColors.white,
                    side: BorderSide(color: ThemeColors.neutral20, width: 1),
                    textStyle: styleBaseSemiBold(
                      color: ThemeColors.neutral40,
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 16),
                Expanded(
                  child: BaseButton(
                    text: "Apply",
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FilterType extends StatefulWidget {
  final List<BaseKeyValueRes>? data;
  final String title;

  const FilterType({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  State<FilterType> createState() => _FilterTypeState();
}

class _FilterTypeState extends State<FilterType> {
  bool _isOpen = true;

  void _toggleOpen() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _toggleOpen(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: styleBaseBold(fontSize: 20, color: ThemeColors.black),
                ),
                Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => _toggleOpen(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: ThemeColors.neutral5),
                    ),
                    child: Image.asset(
                      _isOpen ? Images.arrowDOWN : Images.arrowUP,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: _isOpen ? 36 : 0,
            margin: EdgeInsets.only(
              top: _isOpen ? 5 : 0,
              bottom: _isOpen ? 16 : 0,
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Dimen.padding),
              itemBuilder: (context, index) {
                return MarketFilterItem(data: widget.data![index]);
              },
              separatorBuilder: (context, index) {
                return const SpacerHorizontal(width: Dimen.padding);
              },
              itemCount: widget.data?.length ?? 0,
            ),
          ),
        ),
        Divider(color: ThemeColors.neutral5, height: 1, thickness: 1)
      ],
    );
  }
}

class MarketFilterItem extends StatelessWidget {
  final BaseKeyValueRes data;
  const MarketFilterItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // MarketManager manager = context.watch<MarketManager>();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.neutral10, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      alignment: Alignment.center,
      child: Text(
        data.title ?? "",
        style: styleBaseRegular(fontSize: 14, color: ThemeColors.black),
      ),
    );
  }
}
