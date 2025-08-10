enum MedicineType { tablet, syrup, drops, injection, capsule }

class Medicine {
  final int id;
  final String name;
  final MedicineType type;
  final List<DateTime> scheduledTimes;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;

  Medicine({
    required this.id,
    required this.name,
    required this.type,
    required this.scheduledTimes,
    this.isActive = true,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'scheduledTimes': scheduledTimes.map((time) => time.toIso8601String()).toList(),
      'isActive': isActive,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      type: MedicineType.values[json['type']],
      scheduledTimes: (json['scheduledTimes'] as List)
          .map((timeStr) => DateTime.parse(timeStr))
          .toList(),
      isActive: json['isActive'] ?? true,
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class MedicineIntake {
  final int id;
  final int medicineId;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final bool isTaken;

  MedicineIntake({
    required this.id,
    required this.medicineId,
    required this.scheduledTime,
    this.takenTime,
    this.isTaken = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineId': medicineId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'takenTime': takenTime?.toIso8601String(),
      'isTaken': isTaken,
    };
  }

  factory MedicineIntake.fromJson(Map<String, dynamic> json) {
    return MedicineIntake(
      id: json['id'],
      medicineId: json['medicineId'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      takenTime: json['takenTime'] != null ? DateTime.parse(json['takenTime']) : null,
      isTaken: json['isTaken'] ?? false,
    );
  }
}