import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/jobs/jobs_page.dart';

import 'home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key? key,
    required this.currentTab,
    required this.onSelected,
    required this.widgetBuilders,
    required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelected;
  final Map<TabItem, WidgetBuilder>  widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _buildItem(TabItem.jobs),
            _buildItem(TabItem.entries),
            _buildItem(TabItem.account),
          ],
          onTap: (index) => onSelected(TabItem.values[index]),
        ),
      tabBuilder: (BuildContext context, int index) {
          final item = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[item],
            builder: (context) => widgetBuilders[item]!(context),
          );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey ;
    return BottomNavigationBarItem(
        icon: Icon(
            itemData!.icon,
            color: color,
        ),
        title: Text(
            itemData.title,
            style: TextStyle(color: color,),
        ),
    );
  }
}
