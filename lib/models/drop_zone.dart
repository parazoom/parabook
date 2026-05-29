class DropZone {
  final int? id;
  final String name;
  final String country;
  final bool isDefault;
  final bool isArchived;
  final int jumpsBefore;
  final String notes;

  DropZone({
    this.id,
    required this.name,
    this.country = '',
    this.isDefault = false,
    this.isArchived = false,
    this.jumpsBefore = 0,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'country': country,
        'is_default': isDefault ? 1 : 0,
        'is_archived': isArchived ? 1 : 0,
        'jumps_before': jumpsBefore,
        'notes': notes,
      };

  factory DropZone.fromMap(Map<String, dynamic> m) => DropZone(
        id: m['id'],
        name: m['name'],
        country: m['country'] ?? '',
        isDefault: m['is_default'] == 1,
        isArchived: m['is_archived'] == 1,
        jumpsBefore: m['jumps_before'] ?? 0,
        notes: m['notes'] ?? '',
      );

  DropZone copyWith({
    int? id,
    String? name,
    String? country,
    bool? isDefault,
    bool? isArchived,
    int? jumpsBefore,
    String? notes,
  }) =>
      DropZone(
        id: id ?? this.id,
        name: name ?? this.name,
        country: country ?? this.country,
        isDefault: isDefault ?? this.isDefault,
        isArchived: isArchived ?? this.isArchived,
        jumpsBefore: jumpsBefore ?? this.jumpsBefore,
        notes: notes ?? this.notes,
      );
}
