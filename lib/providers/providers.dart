import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/jumps_dao.dart';
import '../db/drop_zones_dao.dart';
import '../db/equipment_dao.dart';
import '../db/jump_types_dao.dart';
import '../db/aircraft_dao.dart';
import '../db/useful_links_dao.dart';
import '../models/jump.dart';
import '../models/drop_zone.dart';
import '../models/equipment.dart';
import '../models/jump_type.dart';
import '../models/aircraft.dart';
import '../models/useful_link.dart';

final jumpsDaoProvider = Provider((_) => JumpsDao());
final dropZonesDaoProvider = Provider((_) => DropZonesDao());
final equipmentDaoProvider = Provider((_) => EquipmentDao());
final jumpTypesDaoProvider = Provider((_) => JumpTypesDao());
final aircraftDaoProvider = Provider((_) => AircraftDao());
final usefulLinksDaoProvider = Provider((_) => UsefulLinksDao());

final jumpsProvider = FutureProvider<List<Jump>>((ref) {
  return ref.watch(jumpsDaoProvider).getAll();
});

final dropZonesProvider = FutureProvider<List<DropZone>>((ref) {
  return ref.watch(dropZonesDaoProvider).getAll();
});

final jumpTypesProvider = FutureProvider<List<JumpType>>((ref) {
  return ref.watch(jumpTypesDaoProvider).getAll();
});

final aircraftProvider = FutureProvider<List<Aircraft>>((ref) {
  return ref.watch(aircraftDaoProvider).getAll();
});

final bagsProvider = FutureProvider<List<Equipment>>((ref) {
  return ref.watch(equipmentDaoProvider).getByType(EquipmentType.bag);
});

final canopiesProvider = FutureProvider<List<Equipment>>((ref) {
  return ref.watch(equipmentDaoProvider).getByType(EquipmentType.canopy);
});

final suitsProvider = FutureProvider<List<Equipment>>((ref) {
  return ref.watch(equipmentDaoProvider).getByType(EquipmentType.suit);
});

final summaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dao = ref.watch(jumpsDaoProvider);
  final total = await dao.countAll();
  final cutaways = await dao.countCutaways();
  final last30 = await dao.countLast30Days();
  final last12m = await dao.countLast12Months();
  final dzCount = await dao.countDistinctDropZones();
  final countryCount = await dao.countDistinctCountries();
  final lastJump = await dao.getLast();
  return {
    'total': total,
    'cutaways': cutaways,
    'last30': last30,
    'last12m': last12m,
    'dzCount': dzCount,
    'countryCount': countryCount,
    'lastJump': lastJump,
  };
});

final activeRemindersProvider = FutureProvider<List<Equipment>>((ref) {
  return ref.watch(equipmentDaoProvider).getActiveReminders();
});

final usefulLinksProvider = FutureProvider<List<UsefulLink>>((ref) {
  return ref.watch(usefulLinksDaoProvider).getAll();
});
