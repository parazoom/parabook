enum EquipmentType { bag, canopy, suit }

class Equipment {
  final int? id;
  final String name;
  final EquipmentType type;
  final bool isDefault;
  final bool isArchived;
  final int jumpsBefore;
  final DateTime? reminderDate;
  final String notes;

  Equipment({
    this.id,
    required this.name,
    required this.type,
    this.isDefault = false,
    this.isArchived = false,
    this.jumpsBefore = 0,
    this.reminderDate,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type.name,
        'is_default': isDefault ? 1 : 0,
        'is_archived': isArchived ? 1 : 0,
        'jumps_before': jumpsBefore,
        'reminder_date': reminderDate?.toIso8601String(),
        'notes': notes,
      };

  factory Equipment.fromMap(Map<String, dynamic> m) => Equipment(
        id: m['id'],
        name: m['name'],
        type: EquipmentType.values.firstWhere((e) => e.name == m['type']),
        isDefault: m['is_default'] == 1,
        isArchived: m['is_archived'] == 1,
        jumpsBefore: m['jumps_before'] ?? 0,
        reminderDate: m['reminder_date'] != null ? DateTime.parse(m['reminder_date']) : null,
        notes: m['notes'] ?? '',
      );

  Equipment copyWith({
    int? id,
    String? name,
    EquipmentType? type,
    bool? isDefault,
    bool? isArchived,
    int? jumpsBefore,
    DateTime? reminderDate,
    String? notes,
  }) =>
      Equipment(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        isDefault: isDefault ?? this.isDefault,
        isArchived: isArchived ?? this.isArchived,
        jumpsBefore: jumpsBefore ?? this.jumpsBefore,
        reminderDate: reminderDate ?? this.reminderDate,
        notes: notes ?? this.notes,
      );

  ReminderStatus get reminderStatus {
    if (reminderDate == null) return ReminderStatus.none;
    final now = DateTime.now();
    if (reminderDate!.isBefore(now)) return ReminderStatus.overdue;
    if (reminderDate!.isBefore(now.add(const Duration(days: 30)))) return ReminderStatus.soon;
    return ReminderStatus.ok;
  }
}

enum ReminderStatus { none, ok, soon, overdue }
