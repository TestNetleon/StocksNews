import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';

class TabScrollDemo extends StatelessWidget {
  const TabScrollDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: BaseAppBar(),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: SizedBox(),
                expandedHeight: 200.0,
                pinned: false,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Top Container 1',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(height: 10),
                        Text('Top Container 2',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),

              // Tab bar (stays visible)
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'Tab 1'),
                      Tab(text: 'Tab 2'),
                      Tab(text: 'Tab 3'),
                    ],
                  ),
                ),
              ),

              // Tab views
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    _buildTabContent('Tab 1 Content'),
                    _buildTabContent('Tab 2 Content'),
                    _buildTabContent('Tab 3 Content'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String text) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 30,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('$text - Item $index'),
        );
      },
    );
  }
}

// Custom delegate to keep the TabBar pinned
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
