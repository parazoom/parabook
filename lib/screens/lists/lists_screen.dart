import 'package:flutter/material.dart';
import 'package:parabook/l10n/app_localizations.dart';
import 'equipment_list_screen.dart';
import 'drop_zones_list_screen.dart';
import 'jump_types_list_screen.dart';
import 'aircraft_list_screen.dart';
import 'useful_links_screen.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l.equipment),
              Tab(text: l.dropZones),
              Tab(text: l.jumpTypes),
              Tab(text: l.aircraftList),
              const Tab(text: 'Liens utiles'),
            ],
          ),
          Expanded(
            child: TabBarView(children: [
              const EquipmentListScreen(),
              const DropZonesListScreen(),
              const JumpTypesListScreen(),
              const AircraftListScreen(),
              const UsefulLinksScreen(),
            ]),
          ),
        ],
      ),
    );
  }
}
