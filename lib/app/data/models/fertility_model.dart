class FertilityData {
  final int id;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int cycleLength;
  final DateTime nextPeriodDate;
  final DateTime ovulationDate;
  final List<DateTime> fertileDays;

  FertilityData({
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    this.cycleLength = 28,
    required this.nextPeriodDate,
    required this.ovulationDate,
    required this.fertileDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'cycleLength': cycleLength,
      'nextPeriodDate': nextPeriodDate.toIso8601String(),
      'ovulationDate': ovulationDate.toIso8601String(),
      'fertileDays': fertileDays.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory FertilityData.fromJson(Map<String, dynamic> json) {
    return FertilityData(
      id: json['id'],
      periodStart: DateTime.parse(json['periodStart']),
      periodEnd: DateTime.parse(json['periodEnd']),
      cycleLength: json['cycleLength'] ?? 28,
      nextPeriodDate: DateTime.parse(json['nextPeriodDate']),
      ovulationDate: DateTime.parse(json['ovulationDate']),
      fertileDays: (json['fertileDays'] as List)
          .map((dateStr) => DateTime.parse(dateStr))
          .toList(),
    );
  }
}

class PeriodEntry {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int flow; // 1-5 scale
  final List<String> symptoms;

  PeriodEntry({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.flow = 3,
    this.symptoms = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'flow': flow,
      'symptoms': symptoms,
    };
  }

  factory PeriodEntry.fromJson(Map<String, dynamic> json) {
    return PeriodEntry(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      flow: json['flow'] ?? 3,
      symptoms: List<String>.from(json['symptoms'] ?? []),
    );
  }
}