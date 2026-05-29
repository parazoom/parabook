import 'package:flutter/material.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'summary/summary_screen.dart';
import 'jumps/jumps_screen.dart';
import 'stats/stats_screen.dart';
import 'lists/lists_screen.dart';
import 'settings/actions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l.tabSummary.toUpperCase()),
            Tab(text: l.tabJumps.toUpperCase()),
            Tab(text: l.tabStats.toUpperCase()),
            Tab(text: l.tabLists.toUpperCase()),
            Tab(text: l.tabActions.toUpperCase()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SummaryScreen(),
          JumpsScreen(),
          StatsScreen(),
          ListsScreen(),
          ActionsScreen(),
        ],
      ),
    );
  }
}
