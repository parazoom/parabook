class Aircraft {
  final int? id;
  final String name;
  final bool isDefault;
  final bool isArchived;
  final int jumpsBefore;
  final String notes;

  Aircraft({
    this.id,
    required this.name,
    this.isDefault = false,
    this.isArchived = false,
    this.jumpsBefore = 0,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'is_default': isDefault ? 1 : 0,
        'is_archived': isArchived ? 1 : 0,
        'jumps_before': jumpsBefore,
        'notes': notes,
      };

  factory Aircraft.fromMap(Map<String, dynamic> m) => Aircraft(
        id: m['id'],
        name: m['name'],
        isDefault: m['is_default'] == 1,
        isArchived: m['is_archived'] == 1,
        jumpsBefore: m['jumps_before'] ?? 0,
        notes: m['notes'] ?? '',
      );

  Aircraft copyWith({int? id, String? name, bool? isDefault, bool? isArchived, int? jumpsBefore, String? notes}) =>
      Aircraft(
        id: id ?? this.id,
        name: name ?? this.name,
        isDefault: isDefault ?? this.isDefault,
        isArchived: isArchived ?? this.isArchived,
        jumpsBefore: jumpsBefore ?? this.jumpsBefore,
        notes: notes ?? this.notes,
      );
}
