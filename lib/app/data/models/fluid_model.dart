class FluidIntake {
  final int id;
  final DateTime date;
  final double amount; // in ml
  final String type; // water, juice, etc.

  FluidIntake({
    required this.id,
    required this.date,
    required this.amount,
    this.type = 'water',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'type': type,
    };
  }

  factory FluidIntake.fromJson(Map<String, dynamic> json) {
    return FluidIntake(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
      type: json['type'] ?? 'water',
    );
  }
}

class FluidSettings {
  final double dailyGoal; // in ml
  final int reminderInterval; // in minutes
  final bool reminderEnabled;
  final DateTime startTime;
  final DateTime endTime;

  FluidSettings({
    this.dailyGoal = 2000,
    this.reminderInterval = 60,
    this.reminderEnabled = true,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'dailyGoal': dailyGoal,
      'reminderInterval': reminderInterval,
      'reminderEnabled': reminderEnabled,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  factory FluidSettings.fromJson(Map<String, dynamic> json) {
    return FluidSettings(
      dailyGoal: json['dailyGoal'].toDouble(),
      reminderInterval: json['reminderInterval'],
      reminderEnabled: json['reminderEnabled'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}