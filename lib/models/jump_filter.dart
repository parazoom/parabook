class JumpFilter {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String searchText;
  final bool cutawayOnly;
  final int? dropZoneId;
  final String? country;
  final int? aircraftId;
  final int? jumpTypeId;

  const JumpFilter({
    this.dateFrom,
    this.dateTo,
    this.searchText = '',
    this.cutawayOnly = false,
    this.dropZoneId,
    this.country,
    this.aircraftId,
    this.jumpTypeId,
  });

  bool get isActive =>
      dateFrom != null ||
      dateTo != null ||
      searchText.isNotEmpty ||
      cutawayOnly ||
      dropZoneId != null ||
      (country != null && country!.isNotEmpty) ||
      aircraftId != null ||
      jumpTypeId != null;
}
