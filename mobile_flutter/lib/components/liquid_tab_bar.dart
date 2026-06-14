import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../theme/monochrome_glass.dart';

enum TabItem { feed, analyze, insights, settings }

extension TabItemExtension on TabItem {
  String get label {
    switch (this) {
      case TabItem.feed: return 'Feed';
      case TabItem.analyze: return 'Analyze';
      case TabItem.insights: return 'Insights';
      case TabItem.settings: return 'Settings';
    }
  }

  IconData get icon {
    switch (this) {
      case TabItem.feed: return Icons.article_outlined;
      case TabItem.analyze: return Icons.search;
      case TabItem.insights: return Icons.bar_chart_outlined;
      case TabItem.settings: return Icons.settings_outlined;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case TabItem.feed: return Icons.article;
      case TabItem.analyze: return Icons.search;
      case TabItem.insights: return Icons.bar_chart;
      case TabItem.settings: return Icons.settings;
    }
  }
}

class LiquidTabBar extends StatelessWidget {
  final TabItem selectedTab;
  final ValueChanged<TabItem> onTabSelected;

  const LiquidTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tabs = TabItem.values.map((tab) {
      final i = tab.index;
      return GlassBottomBarTab(
        label: tab.label,
        icon: Icon(tab.icon, size: 22),
        activeIcon: Icon(tab.selectedIcon, size: 22),
      );
    }).toList();

    return GlassBottomBar(
      tabs: tabs,
      selectedIndex: selectedTab.index,
      onTabSelected: (index) => onTabSelected(TabItem.values[index]),
      barHeight: 64,
      spacing: 4,
      horizontalPadding: 12,
      glassSettings: LiquidGlassSettings(
        blur: dark ? 18 : 12,
        thickness: 36,
        refractiveIndex: 1.25,
        glassColor: dark ? const Color(0x1AFFFFFF) : const Color(0xE6FFFFFF),
        chromaticAberration: dark ? 0.4 : 0.3,
        lightIntensity: dark ? 1.5 : 1.2,
        ambientStrength: dark ? 0.15 : 0.2,
        saturation: dark ? 1.0 : 1.1,
      ),
      selectedIconColor: dark ? DarkColors.label : LightColors.label,
      unselectedIconColor: dark ? DarkColors.tertiaryLabel : LightColors.tertiaryLabel,
      iconSize: 22,
      textStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: dark ? DarkColors.label : LightColors.label,
      ),
      barBorderRadius: 24.0,
    );
  }
}
