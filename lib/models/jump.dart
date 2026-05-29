class Jump {
  final int? id;
  final int num;
  final DateTime date;
  final int? jumpTypeId;
  final int? dropZoneId;
  final int? aircraftId;
  final int? bagId;
  final int? canopyId;
  final int? suitId;
  final bool cutaway;
  final String notes;

  Jump({
    this.id,
    required this.num,
    required this.date,
    this.jumpTypeId,
    this.dropZoneId,
    this.aircraftId,
    this.bagId,
    this.canopyId,
    this.suitId,
    this.cutaway = false,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'num': num,
        'date': date.toIso8601String(),
        'jump_type_id': jumpTypeId,
        'drop_zone_id': dropZoneId,
        'aircraft_id': aircraftId,
        'bag_id': bagId,
        'canopy_id': canopyId,
        'suit_id': suitId,
        'cutaway': cutaway ? 1 : 0,
        'notes': notes,
      };

  factory Jump.fromMap(Map<String, dynamic> m) => Jump(
        id: m['id'],
        num: m['num'],
        date: DateTime.parse(m['date']),
        jumpTypeId: m['jump_type_id'],
        dropZoneId: m['drop_zone_id'],
        aircraftId: m['aircraft_id'],
        bagId: m['bag_id'],
        canopyId: m['canopy_id'],
        suitId: m['suit_id'],
        cutaway: m['cutaway'] == 1,
        notes: m['notes'] ?? '',
      );

  Jump copyWith({
    int? id,
    int? num,
    DateTime? date,
    int? jumpTypeId,
    int? dropZoneId,
    int? aircraftId,
    int? bagId,
    int? canopyId,
    int? suitId,
    bool? cutaway,
    String? notes,
  }) =>
      Jump(
        id: id ?? this.id,
        num: num ?? this.num,
        date: date ?? this.date,
        jumpTypeId: jumpTypeId ?? this.jumpTypeId,
        dropZoneId: dropZoneId ?? this.dropZoneId,
        aircraftId: aircraftId ?? this.aircraftId,
        bagId: bagId ?? this.bagId,
        canopyId: canopyId ?? this.canopyId,
        suitId: suitId ?? this.suitId,
        cutaway: cutaway ?? this.cutaway,
        notes: notes ?? this.notes,
      );
}
